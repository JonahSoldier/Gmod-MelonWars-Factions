AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_borealis/bluebarrel001.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 60
	self.spread = 0
	self.damageDeal = 2
	self.maxHP = 80
	self.range = 750
	self.minRange = 200

	self.ai_chases = false

	self.careForFriendlyFire = false
	self.careForWalls = false
	self.shotOffset = Vector(0,0,15)

	self.fireDelay = 6

	self.damping = 5

	self.population = 3

	self.nextShot = CurTime() + 3

	self.shotSound = "weapons/ar2/npc_ar2_altfire.wav"
	self.tracer = "AR2Tracer"

	self.slowThinkTimer = 0.5

	self.isAOE = true

	self:Setup()
	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.8, self:GetColor().g/1.8, self:GetColor().b/1.8, 255))
end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )
end

function ENT:PhysicsUpdate()
	if not self:GetTable().canMove then return end
	self:AlignUpright( 10000, 100 )

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent, forceTargetPos )
	if (ent:GetVelocity():Length() < 15 and ent.nextShot < CurTime()) then
		sound.Play( ent.shotSound, ent:GetPos() )
		if (forceTargetPos ~= nil or IsValid(ent.targetEntity)) then

			local targetPos
			if (IsValid(ent.targetEntity)) then
				targetPos = ent.targetEntity:GetPos()
				if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
					targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
				end
			else
				targetPos = forceTargetPos
			end

			local shootVector = (targetPos-ent:GetPos() + Vector(0, 0, 1000) + Vector(math.random(-self.spread,self.spread),math.random(-self.spread,self.spread),math.random(-self.spread,self.spread)))*24
			--local shootVector = (targetPos-ent:GetPos() + Vector(0, 0, 700))*36
			local bullet = ents.Create( "ent_melonbullet_bomb" )
			if not IsValid( bullet ) then return end -- Check whether we successfully made an entity, if not - bail
			bullet:SetPos( ent:GetPos() + Vector(0,0,50) )
			bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
			bullet:SetModel("models/props_phx/misc/smallcannonball.mdl")
			bullet:Spawn()
			bullet:SetSolid( SOLID_VPHYSICS )         -- Toolbox
			bullet:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
			local bulletphys = bullet:GetPhysicsObject()
			bulletphys:ApplyForceCenter( shootVector )
			bulletphys:SetDamping(0.3,3)
			bullet.owner = ent
			ent.fired = true
			ent.nextShot = CurTime()+ent.fireDelay
		end
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end