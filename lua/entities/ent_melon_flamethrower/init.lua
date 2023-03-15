AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_citizen_tech/firetrap_propanecanister01a.mdl"

	--"models/props_citizen_tech/firetrap_propanecanister01a.mdl"

	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 60
	self.spread = 10
	self.damageDeal = 2
	self.maxHP = 150
	self.range = 550
	self.minRange = 100
	self.angularDamping = 10

	self.ai_chases = false


	self.careForWalls = true

	self.nextShot = CurTime()+0.05
	self.fireDelay = 0.05

	self.shotOffset = Vector(0,0,10)

	self.population = 3

	self.shotSound = "coast.gaspump_ignite"
	self.tracer = "AR2Tracer"

	self.slowThinkTimer = 0.05

	MW_Setup ( self )

	self.phys:SetMass( 50 )

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	MW_UnitDefaultThink ( ent )
end

function ENT:PhysicsUpdate()

	local inclination = self:Align(self:GetAngles():Up(), Vector(0,0,1), 1000)
	self.phys:Wake()

	--self.phys:ApplyForceCenter(Vector(0,0,inclination*100*self.phys:GetMass()))
	self.phys:SetAngleVelocity( self:GetAngles():Up()*500*inclination)

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		--------------------------------------------------------Disparar
		if (forcedTargetPos ~= nil) then
			local targets = ents.FindInSphere( forcedTargetPos, 3 )
			ent.targetEntity = nil
			for k, v in pairs(targets) do
				if (not ent:SameTeam(v)) then
					ent.targetEntity = v
					break;
				end
			end
		end

		if (ent.nextShot < CurTime()) then

			if (IsValid(ent.targetEntity)) then

				sound.Play( ent.shotSound, ent:GetPos() )

				local targetPos = ent.targetEntity:GetPos()
				if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
					targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
				end

				local bullet = ents.Create( "ent_melonbullet_flamerfuel" )
				if not IsValid( bullet ) then return end -- Check whether we successfully made an entity, if not - bail
				bullet:SetPos( ent:GetPos() + Vector(0,0, 75) )
				bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
				bullet:Spawn()
				bullet:SetNWEntity("target", ent.targetEntity)
				bullet.owner = ent
				ent.fired = true
				ent.nextShot = CurTime()+ent.fireDelay
			end
		end
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end