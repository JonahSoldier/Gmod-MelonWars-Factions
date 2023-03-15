AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

local melons = {}
local melonsCount = 0
local index = 1

function ENT:Initialize()
	self:SetModel("models/hunter/tubes/circle2x2.mdl")
	self:SetMaterial("Models/effects/vol_light001")

	self.sizeMultiplier = 1
	self.nextRun = CurTime()

	--timer.Simple(20, function() self:Remove() end)
	self:SetNoDraw( true )
end

function ENT:Think ( ent )
	if (self.sizeMultiplier < 0.5 ) then
		if ( IsValid( self.moreFlames ) ) then
			self.moreFlames:Remove()
		end

		self:Remove()
	end

	if (self.nextRun < CurTime()) then
		if(self.sizeMultiplier > 7.5) then
			self.sizeMultiplier = 7.5
		end

		if (self.sizeMultiplier > 3.5) then
			if ( IsValid( self.moreFlames ) ) then
				self.moreFlames:Remove()
			end

			self.moreFlames = ents.Create( "prop_physics" )
			if not IsValid( self.moreFlames ) then return end

			self.moreFlames:SetModel("models/hunter/tubes/circle4x4.mdl")
			self.moreFlames:SetMaterial("Models/effects/vol_light001")
			self.moreFlames:SetParent(self)

			self.moreFlames:SetLocalPos(Vector(0,0,0))

			self.moreFlames:Spawn()

			self.moreFlames:SetNoDraw( true )
			timer.Simple(0.1, function() self.moreFlames:Ignite(4.90, 0) end)
			self.moreFlames:SetModelScale( self.sizeMultiplier/2, 0.00000001 )
			self.moreFlames:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
		else
			if ( IsValid( self.moreFlames ) ) then
				self.moreFlames:Remove()
			end
		end

		self:Extinguish()
		self:Ignite(5, 93.9*self.sizeMultiplier)
		self:SetModelScale( self.sizeMultiplier, 0.00000001 )
		self.nextRun = CurTime() + 5
		self.sizeMultiplier = self.sizeMultiplier - 0.2
	end
end