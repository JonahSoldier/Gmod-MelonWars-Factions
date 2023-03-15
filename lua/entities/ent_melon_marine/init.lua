AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MW_Defaults( self )

	self.modelString = "models/props_junk/watermelon01.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.maxHP = 10
	self.speed = 90

	self.sphereRadius = 7
	self.damageDeal = 2
	self.slowThinkTimer = 3.5

	self.captureSpeed = 0.25

	MW_Setup( self )
end

function ENT:SlowThink( ent )
	MW_UnitDefaultThink( ent )
end

function ENT:Shoot( ent, forceTargetPos )
	if not ( ent.ai or CurTime() > ent.nextControlShoot ) then return end
	MW_DefaultShoot( ent, forceTargetPos )
	ent.nextControlShoot = CurTime() + ent.slowThinkTimer
end

function ENT:DeathEffect( ent )
	MW_DefaultDeathEffect( ent )
end