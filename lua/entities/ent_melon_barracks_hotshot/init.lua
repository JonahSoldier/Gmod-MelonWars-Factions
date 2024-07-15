AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.unit = 8
	self.modelString = "models/props_wasteland/laundry_dryer002.mdl"
	self.maxHP = 120

	self:BarrackInitialize()
	self.population = 1
	self:SetNWInt("maxunits", 3)

	self:Setup()
end

function ENT:Think(ent)

	self:SetNWInt("count", 0)

	self:BarrackSlowThink()

	self:NextThink(CurTime()+0.2)
	return true
end

function ENT:Shoot ( ent )
	--MelonWars.defaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end