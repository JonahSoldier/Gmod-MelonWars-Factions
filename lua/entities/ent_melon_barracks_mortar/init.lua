AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.unit = 9
	self.modelString = "models/XQM/CoasterTrack/train_1.mdl"
	self.maxHP = 120
	--self.Angles = Angle(0,0,0)
	--self:SetPos(self:GetPos()+Vector(0,0,-25))

	self.shotOffset = Vector(0,0,60)

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