AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/hunter/misc/sphere025x025.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.deathSound = "npc/antlion/pain2.wav"
	self.shotSound = "npc/antlion/attack_single1.wav"

	self.speed = 125
	self.range = 150
	self.maxHP = 2
	self.damageDeal = 20
	self.materialString = "phoenix_storms/wire/pcb_blue"
	self.buildingDamageMultiplier = 0.5

	self.captureSpeed = 0.1

	self.dootChance = 0

	self.sphereRadius = 4

	self.canBeSelected = false

	self:Setup()

	self:SetMaterial("phoenix_storms/wire/pcb_blue")
end

function ENT:SkinMaterial()
end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )
	if (ent:GetNWInt("mw_melonTeam", 0) == 0 and ent.targetEntity == nil) then
		local pos = ent:GetPos()+VectorRand(-100, 100)
		ent:RemoveRallyPoints()
		ent:SetVar("targetPos", pos)
		ent:SetNWVector("targetPos", pos)
		ent:SetVar("moving", true)
		ent:SetNWBool("moving", true)
		ent:SetVar("chasing", false)
		ent:SetVar("followEntity", ent)
		ent:SetNWEntity("followEntity", ent)
		ent.damage = 0.1
	end
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SkinMaterial()
	self:SetMaterial("")
end

function ENT:Shoot ( ent, forceTargetPos )
	local selfTbl = self:GetTable()
	local phys = selfTbl.phys
	phys:SetDamping(0, 0)
	self:SetVelocity(vector_origin)
	phys:ApplyForceCenter( Vector(0,0,115) + (selfTbl.targetEntity:GetPos() - self:GetPos() ) * 3 / phys:GetMass())
	selfTbl.fired = true
	timer.Simple(0.4, function()
		if (IsValid(selfTbl.targetEntity)) then
			self:Explode()
		end
	end)
end

function ENT:Explode()
	timer.Simple( 0.1, function()
		if not IsValid(self) then return end
		local selfTbl = self:GetTable()
		if not selfTbl.forceExplode and not IsValid(selfTbl.targetEntity) then
			selfTbl.targetEntity = nil
			selfTbl.nextSlowThink = CurTime()+0.1
			return false
		end

		if selfTbl.forceExplode or selfTbl.targetEntity:IsValid() then
			--allows this to damage base props, self.damageDeal is divided by 2 so it does half damage to them.
			if (selfTbl.targetEntity.Base == "ent_melon_prop_base") then
				selfTbl.targetEntity:SetNWFloat( "health", selfTbl.targetEntity:GetNWFloat( "health", 1) - selfTbl.damageDeal / 2)
				if (selfTbl.targetEntity:GetNWFloat( "health", 1) <= 0) then
					selfTbl.targetEntity:PropDie()
				end
				sound.Play( selfTbl.shotSound, self:GetPos(), 75, 145 )
				MelonWars.die ( self )
			else
				selfTbl.targetEntity:TakeDamage( selfTbl.damageDeal, self, self )
				sound.Play( selfTbl.shotSound, self:GetPos(), 75, 145 )
				MelonWars.die ( self )
			end
		end
	end )
end

function ENT:DeathEffect( ent )
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	util.Effect( ent.deathEffect, effectdata )
	sound.Play( ent.deathSound, ent:GetPos(), 20, 145 )
	ent:Remove()
end
