AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MW_Energy_Defaults ( self )

	self.modelString = "models/props_wasteland/lighthouse_fresnel_light_base.mdl"
	--self.speed = 320
	--self.spread = 0
	--self.damageDeal = 0
	self.maxHP = 200
	self.minRange = 400
	self.range = 1600
	self.shotSound = "NPC_CombineBall.Impact"
	self.energyCost = 1000
	self.shotOffset = Vector(0,0,30)

	self.careForWalls = true
	self.nextShot = CurTime()+2
	self.fireDelay = 30
	self.canMove = false
	self.canBeSelected = true
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 0.2
	--self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))

	MW_Energy_Setup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)

	self:SetNWBool("Fired", false)
end

function ENT:SlowThink ( ent )

	local pos = (ent:GetPos()+Vector(0,0,200))
	local energyCost = 5000
	if (mw_electric_network[self.network].energy >= energyCost) then
		if (ent.ai or CurTime() > ent.nextControlShoot) then
			if (forcedTargetPos ~= nil) then
				--The way mw does this is pretty weird
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

				if (IsValid(ent.targetEntity)and ent.targetEntity ~= ent) then
					if ((ent.targetEntity:GetPos()-ent:GetPos()):LengthSqr() < ent.range*ent.range) then
						local tr = util.TraceLine( {
							start = pos,
							endpos = ent.targetEntity:GetPos()+ent.targetEntity:GetVar("shotOffset", Vector(0,0,0)),
							filter = function( foundEntity ) if (foundEntity.Base ~= "ent_melon_base" and foundEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 1)or foundEntity:GetClass() == "prop_physics" and foundEntity ~= ent.targetEntity) then return true end end
							})
						if  (tr ~= nil and tostring(tr.Entity) == '[NULL Entity]') then
							ent:Shoot( ent, forcedTargetPos)
							self:DrainPower(energyCost)
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

	local bullet = ents.Create( "ent_melonbullet_particlebeamtracer" )
	if not IsValid( bullet ) then return end -- Check whether we successfully made an entity, if not - bail
	bullet:SetPos( ent:GetPos() + Vector(0,0,200) )
	bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
	bullet:Spawn()
	bullet:SetNWEntity("target", ent.targetEntity)
	bullet.owner = ent
	ent.fired = true
	ent.nextShot = CurTime()+ent.fireDelay

	self:SetNWBool("Fired", true)
	timer.Simple(13, function() self:SetNWBool("Fired", false) end)

	local beamSound = CreateSound( self, "d3_citadel.weapon_zapper_beam_loop1" )
	beamSound:Play()
	beamSound:ChangePitch( 75, 0 )
	timer.Simple(8, function() beamSound:ChangePitch( 255, 5 ) end)
	timer.Simple(13, function() beamSound:Stop() end)
end

function ENT:DeathEffect ( ent )
	--ent:StopSound("d3_citadel.combine_ball_field_loop1")
	MW_DefaultDeathEffect ( ent )
end