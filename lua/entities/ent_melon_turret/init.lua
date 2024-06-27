AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/combine_turrets/ground_turret.mdl"
	self.speed = 80
	self.spread = 7
	self.damageDeal = 10
	self.maxHP = 45
	self.range = 500
	self.population = 2
	self.shotSound = "weapons/ar1/ar1_dist2.wav"
	self.tracer = "AR2Tracer"

	self.shotOffset = Vector(0,0,-2.5) --TODO: make visual shot offset different, if possible. We use a different origin for targeting and for displaying muzzleflashes, but the same offset, causing issues.

	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 1

	self:Setup()
	self:GetPhysicsObject():EnableMotion(true)
end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )
end

function ENT:Shoot ( ent )
	MelonWars.defaultShoot(ent)
	local angle = (ent.targetEntity:GetPos() - self:GetPos()):Angle() + Angle(180,180,0)
	self:SetAngles( Angle(-angle.x, angle.y, angle.z) )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end