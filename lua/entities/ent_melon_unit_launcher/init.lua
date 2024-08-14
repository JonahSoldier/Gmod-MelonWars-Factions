AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_citizen_tech/steamengine001a.mdl"
	self.maxHP = 200
	self.minRange = 750
	self.range = 5000
	self.shotSound = "HeadcrabCanister.LaunchSound"
	self.energyCost = 1000
	self.shotOffset = Vector(0,0,30)

	self.careForWalls = false
	self.nextShot = CurTime() + 2
	self.fireDelay = 15
	self.canMove = false
	self.canBeSelected = true
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 0.2
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))

	self:SetNWInt("maxunits", 10)
	self:SetNWInt("count", 0)
	self.canEatUnits = true

	MelonWars.energySetup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)

	self.containedEnts = {}

	self:SetNWFloat("lastAttack", CurTime())
end

function ENT:PhysicsCollide( data, physobj )
	local hitEntity = data.HitEntity
	if hitEntity:IsValid() and hitEntity.spawned then
		self:AbsorbUnit(hitEntity)
	end
end

function ENT:AbsorbUnit(unit)
	if self.canEatUnits and unit.Base == "ent_melon_base" then
		local uClass = unit:GetClass()
		local selfTeam = self:GetNWInt("mw_melonTeam", -1)
		if unit:GetNWInt("mw_melonTeam", 0) == selfTeam and unit.canMove and not unit.isContraptionPart and uClass ~= "ent_melon_main_unit" then
			if unit.population <= self:GetNWInt("maxunits", 0) - self:GetNWInt("count", 0) then
				local index = self:GetNWInt("count", 0)
				self.containedEnts[index+1] = {
					class = unit:GetClass(),
					hp = unit.HP,
					value = unit.value,
					energy = unit:GetNWInt("mw_charge", -1),
					owner = unit:GetOwner(),
				}
				self:SetNWInt("count", index+unit.population)
				MelonWars.updatePopulation(unit.population, selfTeam)
				unit.fired = true

				unit:Remove()
				unit.spawned = false

				sound.Play("items/ammocrate_close.wav", self:GetPos())
			end
		end
	end
end

function ENT:Actuate()
	self:FreeUnits()
end

function ENT:FreeUnits()
	local totalCount = self:GetNWInt("count", 0)
	if totalCount <= 0 then return end

	local exitPos = self:GetPos() + (self:GetRight() * -98.1) - Vector(0,0,110)
	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	for i = 1, totalCount + 1 do
		local cEnt = self.containedEnts[i]
		if cEnt then
			local pos = exitPos + Vector(math.random(-10,10),math.random(-10,10), i * 10)
			local newUnit = MelonWars.spawnUnitAtPos( cEnt.class, pos, angle_zero, cEnt.value, 0, selfTeam, false, nil, cEnt.owner, 0 )

			if cEnt.energy > 0 then
				newUnit:SetNWInt("mw_charge", cEnt.Energy)
			end

			undo.Create("Melon Marine")
				undo.AddEntity( newUnit )
				undo.SetPlayer( pl)
			undo.Finish()

			MelonWars.updatePopulation(-newUnit.population, selfTeam)
		end
		self.containedEnts[i] = nil
	end
	self:SetNWInt("count", 0)
	sound.Play( "doors/door_metal_medium_open1.wav", self:GetPos() )
end

function ENT:OnRemove()
	MelonWars.updatePopulation(-self.population, self:GetNWInt("mw_melonTeam", 0))

	self:FreeUnits()
end

function ENT:SlowThink ( ent )
	local energyCost = 500
	if  MelonWars.electricNetwork[self.network].energy < energyCost then return end

	--Don't clear our orders if we're just on cooldown
	if not(ent.nextShot < CurTime() and ent.targetPos ~= vector_origin) then return end

	--Do clear our orders if it's another valid reason (too far, too close, enemy buildings in range)
	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	local dist = ent.targetPos:DistToSqr(ent:GetPos())
	if not(dist < ent.range^2 and dist > ent.minRange^2) then
		self:ClearOrders()
		return
	end

	for i, v in ipairs(ents.FindInSphere( ent.targetPos, 400 )) do
		if v.moveType == MOVETYPE_NONE and not MelonWars.sameTeam(selfTeam, v:GetNWInt("mw_melonTeam", -1)) then
			MelonWars.broadcastTeamMessage(selfTeam, "== Unit launcher target position too close to an enemy building! ==")
			self:ClearOrders()
			return
		end
	end

	ent:Shoot( ent, ent.targetPos)
	self:DrainPower(energyCost)
	self:ClearOrders()
end

function ENT:Shoot(ent, forcedTargetPos)
	self:SetNWFloat("lastAttack", CurTime())

	MelonWars.playGlobalSound(ent.shotSound, self:GetPos(), 140)

	local bullet = ents.Create( "ent_melonbullet_unit_shell" )
	if not IsValid( bullet ) then return end -- Check whether we successfully made an entity, if not - bail
	bullet:SetPos( ent:GetPos() + Vector(0,0,200) )
	bullet:SetNWInt("mw_melonTeam", self:GetNWInt("mw_melonTeam", -1))
	bullet:Spawn()
	bullet:SetNWVector("targetPos", forcedTargetPos)
	bullet.owner = ent

	bullet:SetNWInt("count", self:GetNWInt("count", 0))

	bullet.containedEnts = table.Copy(self.containedEnts)
	table.Empty(self.containedEnts)

	self:SetNWInt("count", 0)

	ent.fired = true
	ent.nextShot = CurTime() + ent.fireDelay
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end
