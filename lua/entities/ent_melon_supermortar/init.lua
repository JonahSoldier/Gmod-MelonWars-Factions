AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_citizen_tech/steamengine001a.mdl"
	self.speed = 320
	self.spread = 0
	self.damageDeal = 0
	self.maxHP = 500
	self.minRange = 400
	self.range = 1600
	self.shotSound = "NPC_CombineBall.Impact"
	self.energyCost = 500
	self.shotOffset = Vector(0,0,300)
	
	self.careForWalls = true
	self.nextShot = CurTime()+2
	self.fireDelay = 5
	self.canMove = false
	self.canBeSelected = true
	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 0.2
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 2500)
	self:SetNWBool("mw_active", true)
	self:SetNWFloat("mw_ready", 0)
	MW_Energy_Setup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
end


function ENT:Actuate()
	self:SetNWBool("mw_active", not self:GetNWBool("mw_active", false))
end

function ENT:SlowThink ( ent )

	local energyCost = 500
	if (mw_electric_network[self.network].energy >= energyCost) then
		if (ent.ai or CurTime() > ent.nextControlShoot) then
			--------------------------------------------------------Disparar
			if (forcedTargetPos != nil) then
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
			
				if (IsValid(ent.targetEntity)and ent.targetEntity != ent) then
					if ((ent.targetEntity:GetPos()-ent:GetPos()):LengthSqr() < ent.range*ent.range) then
						local tr = util.TraceLine( {
							start = pos,
							endpos = ent.targetEntity:GetPos()+ent.targetEntity:GetVar("shotOffset", Vector(0,0,0)),
							filter = function( foundEntity ) if (foundEntity.Base ~= "ent_melon_base" and foundEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 1) or foundEntity:GetClass() == "prop_physics" and foundEntity ~= ent.targetEntity) then return true end end
							})

						
						if  (tr != nil and tostring(tr.Entity) == '[NULL Entity]') then
							ent:Shoot( ent, forcedTargetPos)
							self:DrainPower(500)
						end
					end			
				end
			end
		end
	end
	self:Energy_Set_State()
end

function ENT:Shoot(ent, forcedTargetPos)

	sound.Play( ent.shotSound, ent:GetPos() )
			
		
	local targetPos = ent.targetEntity:GetPos()

	if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
		targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
	end


	local shootVector = (targetPos-ent:GetPos() + Vector(0, 0, 1000) + Vector(math.random(-self.spread,self.spread),math.random(-self.spread,self.spread),math.random(-self.spread,self.spread)))*24
		
	local bullet = ents.Create( "ent_melonbullet_siegebomb" )
	if ( !IsValid( bullet ) ) then return end -- Check whether we successfully made an entity, if not - bail
	bullet:SetPos( ent:GetPos() + Vector(0,0,250) )
	bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
	bullet:SetModel("models/props_phx/cannonball.mdl")
	bullet:Spawn()
	bullet:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	bullet:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	bulletphys = bullet:GetPhysicsObject()
	bulletphys:ApplyForceCenter( shootVector )
	bulletphys:SetDamping(0.3,3)
	bullet.owner = ent
	ent.fired = true
	ent.nextShot = CurTime()+ent.fireDelay

end




function ENT:DeathEffect ( ent )
	ent:StopSound("d3_citadel.combine_ball_field_loop1")
	MW_DefaultDeathEffect ( ent )
end