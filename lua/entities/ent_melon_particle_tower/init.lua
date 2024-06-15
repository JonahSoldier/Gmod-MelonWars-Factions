AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_wasteland/lighthouse_fresnel_light_base.mdl"
	self.maxHP = 200
	self.minRange = 400
	self.range = 1600
	self.shotSound = "NPC_CombineBall.Impact"
	self.energyCost = 1000
	self.shotOffset = Vector(0,0,30)

	self.careForWalls = true
	self.fireDelay = 30
	self.canMove = false
	self.canBeSelected = true
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 1
	self:SetNWVector("energyPos", Vector(0,0,20))

	MelonWars.energySetup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)

	self:SetNWBool("Fired", false)
	self:SetNWBool("active", false)
end

function ENT:Actuate()
	local on = self:GetNWBool("active", false)
	self:SetNWBool("active", not on)
end

function ENT:SlowThink ( ent )
	local pos = ( ent:GetPos() + Vector(0,0,200) )
	local energyCost = 5000
	if MelonWars.electricNetwork[self.network].energy < energyCost or CurTime() < ent.nextControlShoot then return end

	local function validTarget( targetEnt )
		if IsValid(targetEnt) and targetEnt ~= ent and (targetEnt:GetPos() - pos):LengthSqr() < ent.range ^ 2 then
			local entTeam = ent:GetNWInt("mw_melonTeam", -1)
			local tr = util.TraceLine( {
				start = pos,
				endpos = targetEnt:GetPos() + ent.shotOffset,
				filter = function( foundEntity ) if (foundEntity.Base ~= "ent_melon_base" and foundEntity:GetNWInt("mw_melonTeam", 0) == entTeam or foundEntity:GetClass() == "prop_physics" and foundEntity ~= ent.targetEntity) then return true end end
			})
			if not IsValid(tr.Entity) then
				return true
			end
		end
		return false
	end

	if self:GetNWBool("active", false) then --This is a little jank
		for i, v in ipairs(ents.FindInSphere(pos, self.range)) do
			if (v.Base == "ent_melon_base" or v.Base == "ent_melon_energy_base") and (not v.canMove) and (not ent:SameTeam(v)) and validTarget( v )  then
				ent.targetEntity = v
				ent:Shoot( ent )
				self:DrainPower(energyCost)
				break
			end
		end
	elseif validTarget( ent.targetEntity ) then
		ent:Shoot( ent )
		self:DrainPower(energyCost)
	end
end


function ENT:Shoot(ent)
	sound.Play( ent.shotSound, ent:GetPos() )

	local targetPos = ent.targetEntity:GetPos()

	if ent.targetEntity.shotOffset ~= nil then
		targetPos = targetPos + ent.targetEntity.shotOffset
	end

	local bullet = ents.Create( "ent_melonbullet_particlebeamtracer" )
	bullet:SetPos( ent:GetPos() + Vector(0,0,200) )
	bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
	bullet:Spawn()
	bullet:SetNWEntity("target", ent.targetEntity)
	bullet.owner = ent
	ent.fired = true

	ent.nextControlShoot = CurTime() + ent.fireDelay
	ent:LoseTarget()

	self:SetNWBool("Fired", true)
	timer.Simple(13, function() self:SetNWBool("Fired", false) end)

	local beamSound = CreateSound( self, "d3_citadel.weapon_zapper_beam_loop1" )
	beamSound:Play()
	beamSound:ChangePitch( 75, 0 )
	timer.Simple(8, function() beamSound:ChangePitch( 255, 5 ) end)
	timer.Simple(13, function() beamSound:Stop() end)
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end