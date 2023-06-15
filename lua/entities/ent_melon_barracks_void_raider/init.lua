AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.unit = 13
	self.modelString = "models/props_vehicles/apc_tire001.mdl"
	--self.Angles = Angle(0,0,180)
	self.maxHP = 35

	--self.posOffset = Vector(0,0,10)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.shotOffset = Vector(0,0,5)
	self:BarrackInitialize()
	self.population = 1
	self:SetNWInt("maxunits", 2)

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