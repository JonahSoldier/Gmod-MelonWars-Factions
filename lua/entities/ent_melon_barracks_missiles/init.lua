AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.unit = 6
	self.modelString = "models/props_interiors/VendingMachineSoda01a.mdl"
	self.maxHP = 120
	--self.Angles = Angle(-45,0,45)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	--self:SetAngles(self:GetAngles()+self.Angles)
	self.shotOffset = Vector(30,0,0)

	self:BarrackInitialize()
	self.population = 1
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