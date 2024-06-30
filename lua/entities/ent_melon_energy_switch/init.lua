AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_trainstation/trashcan_indoor001b.mdl"
	self.maxHP = 20

	self.population = 0

	self.connectToMachines = true

	self.open = true
	self.allowConnection = self.open
	self.lastSwitch = CurTime()
	self:SetNWBool("open", self.open)

	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,10))

	MelonWars.energySetup ( self )
end

function ENT:Actuate ()
	if (self.lastSwitch < CurTime() - 1) then
		self.open = not self.open
		self:SetNWBool("open", self.open)
		if self.open then
			self:Energy_Add_State()
			MelonWars.calculateConnections(self, self.connectToMachines)
		else
			for k, v in pairs(self.connections) do
				table.RemoveByValue(v.connections, self)
			end
			MelonWars.energyNetworkRemoveElement(self)
		end
		self.allowConnections = self.open
		self.lastSwitch = CurTime()
	end
end

--[[
function ENT:Think(ent)
	if (self.open) then
		self:SetNWString("message", "Open")
		self:Energy_Add_State()
	else
		self:SetNWString("message", "Closed")
	end
	self:NextThink( CurTime()+1 )
	return true
end
--]]

function ENT:SlowThink(ent)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end