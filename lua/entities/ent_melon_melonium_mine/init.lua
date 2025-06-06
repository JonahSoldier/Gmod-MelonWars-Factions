AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

function ENT:Initialize()

	self.slowThinkTimer = 2

	self.mw_melonTeam = 0

	self.nextSlowThink = 0

	self.spawnTime = 60

	self:SetNWFloat("next", CurTime()+self.spawnTime)

	self:SetModel( "models/props_vehicles/generatortrailer01.mdl" )

	--self:SetAngles(Angle(90,0,0))
	--self:SetPos(self:GetPos()+Vector(0,0,35))

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:Think()
	if (CurTime() > self:GetNWFloat("next", CurTime()+1)) then
		self:SetNWFloat("next", CurTime()+self.spawnTime)

		local melonium = ents.Create("ent_melonium")
		melonium:SetPos(self:GetPos()+self:GetAngles():Forward()*30+self:GetAngles():Up()*50)
		melonium:Spawn()
		melonium:GetPhysicsObject():ApplyForceCenter(self:GetAngles():Forward()*200+VectorRand(-50, 50))
	end
end