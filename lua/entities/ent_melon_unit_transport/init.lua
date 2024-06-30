AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_junk/wood_crate002a.mdl"
	self.maxHP = 50

	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.speed = 0

	self.population = 1
	self:SetNWInt("maxunits", 10)
	self:SetNWInt("count", 0)

	self.canEatUnits = true

	self.isContraptionPart = true

	self:Setup()

	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	self.containedEnts = {}
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2+100, self:GetColor().g/2+100, self:GetColor().b/2+100, 255))
end

function ENT:SlowThink(ent)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:PhysicsCollide( data, physobj )
	local hitEntity = data.HitEntity
	if hitEntity:IsValid() then
		self:AbsorbUnit(hitEntity)
	end
end

function ENT:AbsorbUnit(unit)
	if self.canEatUnits and unit.Base == "ent_melon_base" then
		local uClass = unit:GetClass()
		local selfTeam = self:GetNWInt("mw_melonTeam", -1)
		if unit:GetNWInt("mw_melonTeam", 0) == selfTeam and unit.canMove and not unit.isContraptionPart and unit:GetClass() ~= "ent_melon_main_unit" then
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
	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	for i = 1, totalCount do
		local cEnt = self.containedEnts[i]
		if cEnt then
			local pos = self:GetPos() + self:GetForward() * (i % 3-1) * 15 + self:GetRight() * (40 + i * 5)
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
	end
	self.canEatUnits = false

	local originalColor = self:GetColor()
	self:SetColor(Color(originalColor.r / 2, originalColor.g / 2, originalColor.b / 2, 255))
	timer.Simple(10, function()
		if not IsValid(self) then return end
		self.canEatUnits = true
		self:SetColor(originalColor)
	end)

	self:SetNWInt("count", 0)
	sound.Play( "doors/door_metal_medium_open1.wav", self:GetPos() )
end


function ENT:OnRemove()
	MelonWars.updatePopulation(-self.population, self:GetNWInt("mw_melonTeam", 0))
	self:FreeUnits()
end