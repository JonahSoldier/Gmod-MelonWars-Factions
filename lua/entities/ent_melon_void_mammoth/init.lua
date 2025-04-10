AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/mechanics/wheels/wheel_spike_48.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.deathSound = "npc/antlion_guard/angry1.wav"
	self.shotSound = "npc/antlion_guard/shove1.wav"
	self.maxHP = 125
	self.speed = 70
	self.range = 100

	self.damageDeal = 40
	self.buildingDamageMultiplier = 1.5

	self.population = 4

	self.captureSpeed = 2

	--print("My Initialization")

	self:Setup()

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )

	self:SetMaterial("phoenix_storms/wire/pcb_blue")
end

function ENT:SkinMaterial()

end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )

end

function ENT:Shoot ( ent, forceTargetPos )
	self.phys:SetDamping(0, 0)
	self:SetVelocity(Vector(0,0,0))
	self.phys:ApplyForceCenter(Vector(0,0,115)+(self.targetEntity:GetPos()-self:GetPos())*3*self.phys:GetMass())
	self.fired = true
	timer.Simple(0.2, function()
		if (IsValid(self.targetEntity)) then
			self:Explode()
		end
	end)
end


function ENT:Explode()
	timer.Simple( 0.1, function()
		if (IsValid(self)) then
			if not self.forceExplode and not IsValid(self.targetEntity) then
				self.targetEntity = nil
				self.nextSlowThink = CurTime()+0.1
				return false
			else
				MelonWars.defaultShoot ( self, forceTargetPos )
			end
		end
	end )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end