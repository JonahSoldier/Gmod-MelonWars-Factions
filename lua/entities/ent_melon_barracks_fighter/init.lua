AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:SetStats()
	self.unit = 15
	self.modelString = "models/phxtended/trieq2x2x2solid.mdl"
	self.maxHP = 100
	self.shotOffset = Vector(0,0,20)
	self.population = 1
	self:SetNWInt("maxunits", 5)
end

function ENT:Initialize()
	MelonWars.defaults ( self )

	self:SetStats()
	self:BarrackInitialize()

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