AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_citizen_tech/steamengine001a.mdl"
	self.speed = 320
	self.spread = 0
	self.damageDeal = 0
	self.maxHP = 200
	self.minRange = 10000
	self.range = 50000
	self.shotSound = "k_lab.teleport_post_thunder"
	self.energyCost = 1000
	self.shotOffset = Vector(0,0,30)

	self.careForWalls = true
	self.nextShot = CurTime()+2
	self.fireDelay = 600
	self.canMove = false
	self.canBeSelected = true
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 0.2
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))

	self.firePrint = false
	self.population = 0


	MelonWars.energySetup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:SlowThink ( ent )
	local pos = (ent:GetPos()+Vector(0,0,180))
	local energyCost = 500
	if (MelonWars.electricNetwork[self.network].energy >= energyCost) then
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
				if(self.fireprint == false) then
					for k, v in pairs( player.GetAll() ) do
						v:PrintMessage( HUD_PRINTTALK, "== Cannon ready to fire! ==" )
					end
					self.fireprint = true
				end
				if (ent.targetPos ~= Vector(0,0,0) ) then
					if ((ent.targetPos-ent:GetPos()):LengthSqr() < ent.range*ent.range) then
						if((ent.targetPos-ent:GetPos()):LengthSqr() > ent.minRange*ent.minRange) then


							local foundBuilding = false
							local buildingDetect = ents.FindInSphere( ent.targetPos, 600 )

							for k, v in pairs(buildingDetect) do
								if (v.moveType == MOVETYPE_NONE and v:GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0)) then
									foundBuilding = true
								end
							end

							ent:Shoot( ent, ent.targetPos)
							self:DrainPower(500)
							ent.targetPos = Vector(0,0,0)
							self.fireprint = false
						end
					end
				end
			end
		end
	end
	self:Energy_Set_State()
end

function ENT:Shoot(ent, forcedTargetPos)


	for k, v in pairs( player.GetAll() ) do
		sound.Play( ent.shotSound, v:GetPos() )
	end

	local bullet = ents.Create( "ent_melonbullet_supershell" )
	if not IsValid( bullet ) then return end -- Check whether we successfully made an entity, if not - bail
	bullet:SetPos( ent:GetPos() + Vector(0,0,200) )
	bullet:SetNWInt("mw_melonTeam",self:GetNWInt("mw_melonTeam", -1))
	bullet:Spawn()
	bullet:SetNWVector("targetPos", forcedTargetPos)
	bullet.owner = ent

	ent.fired = true
	ent.nextShot = CurTime()+ent.fireDelay

end


function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end
