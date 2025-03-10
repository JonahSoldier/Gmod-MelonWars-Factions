AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.unit = 5
	self.modelString = "models/props_combine/combine_interface002.mdl"
	self.maxHP = 100

	self.shotOffset = Vector(0,0,50)

	self:BarrackInitialize()
	self.population = 1
	self:SetNWInt("maxunits", 10)

	self:Setup()
end

function ENT:Think(ent)

	self:SetNWInt("count", 0)

	self:BarrackSlowThink()

	self:NextThink(CurTime() + 0.2)
	return true
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end