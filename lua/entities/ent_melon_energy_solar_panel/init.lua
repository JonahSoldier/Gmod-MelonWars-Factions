AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_combine/weaponstripper.mdl"
	self.maxHP = 50
	self.moveType = MOVETYPE_NONE

	self.canMove = false

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,62.5))

	self.shotOffset = Vector(0,0,65)

	self.history = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	self.historyTotal = 25

	MelonWars.energySetup ( self )

	self:SetNWFloat("EnergyEfficiency", 0)
	self:EstimateEfficiency()
end

local endOffset = Vector(0, 0, 10000)
function ENT:EstimateEfficiency()
	local angles = self:GetAngles()
	local selfPos = self:GetPos()
	local filterEnts = player.GetAll()
	table.insert(filterEnts, self)

	for i = 0, 25 do
		local offset = angles:Right() * math.random(-60,60) --+ angles:Up() * math.random(0,120)
		local tr = util.TraceLine( {
			start = selfPos + offset,
			endpos = selfPos + offset + endOffset,
			filter = filterEnts
		} )
		if tr.HitSky or not tr.Hit then --free sky
			table.insert(self.history, 1)
			self.historyTotal = self.historyTotal + 1
		else
			table.insert(self.history, 0)
		end

		self.historyTotal = self.historyTotal-self.history[1]
		table.remove(self.history, 1)
	end
end

function ENT:Think(ent)
	if MelonWars.admin_playing and self.spawned then
		local angles = self:GetAngles()
		local selfPos = self:GetPos()
		local offset = angles:Right() * math.random(-60,60) --+ angles:Up() * math.random(0,120)

		local filterEnts = player.GetAll()
		table.insert(filterEnts, self)

		local tr = util.TraceLine( {
			start = selfPos + offset,
			endpos = selfPos + offset + endOffset,
			filter = filterEnts
		} )

		if tr.HitSky or not tr.Hit then --free sky
			self:GivePower(10)
			table.insert(self.history, 1)
			self.historyTotal = self.historyTotal + 1
		else
			table.insert(self.history, 0)
		end

		self.historyTotal = self.historyTotal-self.history[1]
		table.remove(self.history, 1)
		self:SetNWFloat("EnergyEfficiency", self.historyTotal * 4)
	end

	--self:Energy_Add_State()
	self:NextThink( CurTime() + 5 )
	return true
end

function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end