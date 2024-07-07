AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/props_phx/misc/soccerball.mdl"
	self.materialString = ""

	self.deathSound = "ambient/explosions/explode_9.wav"

	self.careForFriendlyFire = false

	self.slowThinkTimer = 1

	self.population = 2

	self.sphereRadius = 9

	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.range = 80
	self.speed = 115
	self.damageDeal = 80
	self.maxHP = 15

	self.meleeAi = true

	self.dootChance = 0

	self.isAOE = true

	self:Setup()
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r*1.3, self:GetColor().g*1.3, self:GetColor().b*1.3, 255))
end

function ENT:SkinMaterial()
	self:SetMaterial("")
end

function ENT:DeathEffect( ent )
	timer.Simple( 0.02, function()
		if (IsValid(ent)) then
			util.BlastDamage( ent, ent, ent:GetPos(), 80, ent.damageDeal )
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			util.Effect( "Explosion", effectdata )

			local pos1 = ent:GetPos()
			local pos2 = ent:GetPos() + Vector(0,0,-20) -- Set worldpos 2. Subtract from the hitpos the world normal.
			ent.fired = true
			ent:Remove()

			util.Decal("Scorch",pos1,pos2)
		end
	end)
end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )
end

function ENT:PostEntityPaste( ply, ent, createdEntities )
	self:SetPos(self:GetPos()+Vector(0,0,1.2))
end

--[[
function ENT:Welded (ent, trace)
	ent:SetModel("models/props_c17/clock01.mdl")
	ent:SetPos(ent:GetPos()+Vector(0,0,0))
	ent.canMove = false
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	ent.maxHP = 10
	ent.HP = 10
	ent.population = 1

	ent.range = 100
	ent.materialString = "Models/effects/comball_sphere"

	timer.Simple( 1.3, function()
		if (ent:IsValid()) then
			ent:SetMaterial(ent.materialString)
			ent:SetColor(Color(255, 255, 255, 255))
			ent:DrawShadow( false )
			local effectdata = EffectData()
			effectdata:SetStart( ent:GetPos())
			util.Effect( "ImpactJeep", effectdata )
			ent.targetable = false
		end
	end )
	constraint.Weld( self, game.GetWorld(), 0, trace.PhysicsBone, 0, true , false )
end
--]]

function ENT:OnTakeDamage( damage )
	if (self.canMove) then
		if ((damage:GetAttacker():GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0) or not damage:GetAttacker():GetVar('careForFriendlyFire')) and not damage:GetAttacker():IsPlayer()) then
			if (damage:GetAttacker():GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", 0)) then
				self.HP = self.HP - damage:GetDamage()/10
			else
				self.HP = self.HP - damage:GetDamage()
			end
			self:SetNWFloat( "healthFrac", self.HP / self.maxHP )
			if (self.HP <= 0) then
				MelonWars.die (self)
			end
		end
	else
		--Negate damage
	end
end

function ENT:Shoot ( ent, forcedTargetPos)
	sound.Play("buttons/button8.wav", ent:GetPos())
	ent.forceExplode = (forcedTargetPos ~= nil)
	timer.Simple( 0.3, function()
		if not IsValid(self) then return end
		sound.Play(self.deathSound, ent:GetPos())
		if ent.forceExplode or IsValid(ent.targetEntity) then
			ent:SetPos(ent:GetPos() + Vector(0,0,3))
			MelonWars.die ( ent )
		else
			ent.targetEntity = nil
			ent.nextSlowThink = CurTime () + 0.1
			return false
		end
	end )
end