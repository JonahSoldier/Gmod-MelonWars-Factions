AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.unit = 7
	self.modelString = "models/props_wasteland/laundry_cart001.mdl"
	self.maxHP = 100
	--self.Angles = Angle(90,45,0)
	--self:SetPos(self:GetPos()+Vector(0,0,15))
	--self:SetAngles(self:GetAngles()+self.Angles)

	self.population = 1

	self:BarrackInitialize()
	self:SetNWInt("maxunits", 4)

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