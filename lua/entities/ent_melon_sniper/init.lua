AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/props_junk/propane_tank001a.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.maxHP = 20
	self.speed = 60
	self.range = 500
	self.spread = 0.5
	self.damageDeal = 40

	self.buildingDamageMultiplier = 0.7

	self.shotOffset = Vector(0,0,12)

	self.ai_chases = false

	self.angularDamping = 10

	self.nextShot = CurTime()+3

	self.population = 2

	self:Setup()

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )
end

function ENT:PhysicsUpdate()
	self:AlignUpright( 1000, 100 )

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent, forceTargetPos )
	if (ent:GetVelocity():Length() < 15 and ent.nextShot < CurTime()) then
		if (ent.ai or CurTime() > ent.nextControlShoot) then
			MelonWars.defaultShoot ( ent, forceTargetPos )
			for k, v in pairs( player.GetAll() ) do
				sound.Play("physics/metal/metal_computer_impact_bullet1.wav", v:GetPos(), 40, 90, 1)
				sound.Play("weapons/357/357_fire2.wav", v:GetPos(), 40, 80, 1)
			end

			sound.Play("physics/metal/metal_computer_impact_bullet1.wav", ent:GetPos(), 100, 90, 1)
			sound.Play("weapons/357/357_fire2.wav", ent:GetPos(), 100, 80, 1)

			ent.nextShot = CurTime()+7.5
			ent.nextControlShoot = CurTime()+7.5
		end
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end