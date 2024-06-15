AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_docks/channelmarker02a.mdl"
	self.moveType = MOVETYPE_NONE
	self.slowThinkTimer = 0.1
	self.canMove = false
	self.canShoot = false
	self.range = 300
	self.population = 3
	self.nextShot = CurTime()

	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,23.5)

	MelonWars.energySetup ( self )
end

function ENT:ModifyColor()
end

function ENT:SlowThink ( ent )
	local selfTbl = self:GetTable()
	if selfTbl.nextShot > CurTime() then return end
	local energyCost = 50

	if MelonWars.electricNetwork[selfTbl.network].energy < energyCost then return end


	local selfPos = self:GetPos()
	local targetEnt
	local closestDist = math.huge

	for i, v in ipairs(ents.FindInSphere( ent:GetPos() + Vector(0,0,200), ent.range )) do
		local vClass = v:GetClass()
		if string.StartWith(vClass, "ent_melonbullet") and not( vClass == "ent_melonbullet_unit_shell" or vClass == "ent_melonbullet_particlebeamtracer" or vClass == "ent_melonbullet_flamerfuel" ) and v:GetPos():DistToSqr(selfPos) < closestDist then
			local tr = util.TraceLine( {
				start = self:GetPos() + selfTbl.shotOffset,
				endpos = v:GetPos() + selfTbl.shotOffset,
				filter = function( foundEnt )
					local foundClass = foundEnt:GetClass()
					return not(foundEnt.Base == "ent_melon_base" or foundEnt.Base == "ent_melon_energy_base" or foundClass == "prop_physics" or string.StartWith(foundClass, "ent_melonbullet"))
				end
			})
			if not tr.Entity:IsValid() then
				targetEnt = v
			end
		end
	end

	if IsValid(targetEnt) and self:DrainPower(energyCost) then
		selfTbl.targetEntity = targetEnt
		ent:Shoot(ent)
		selfTbl.nextShot = CurTime() + 5
		if targetEnt.Explode then targetEnt:Explode() end
		targetEnt:Remove()
	end
end

function ENT:Shoot ( ent )
	if ent.targetEntity == ent then ent.targetEntity = nil end
	if not IsValid(ent.targetEntity) then return end

	local targetPos = ent.targetEntity:GetPos()
	if ent.targetEntity.shotOffset then
		targetPos = targetPos + ent.targetEntity.shotOffset
	end
	local effectdata = EffectData()
	effectdata:SetScale(3000)
	effectdata:SetMagnitude(3000)
	effectdata:SetStart( self:GetPos() + Vector(0,0,170))
	effectdata:SetOrigin( targetPos )
	util.Effect( "AirboatGunTracer", effectdata )
	sound.Play( "ambient.electrical_random_zap_1", ent:GetPos() )
	sound.Play( "NPC_Strider.Shoot", ent:GetPos() )


	effectdata:SetOrigin( targetPos )
	util.Effect( "Explosion", effectdata )

	ent.fired = true
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end