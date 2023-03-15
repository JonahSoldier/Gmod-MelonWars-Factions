AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate32x32.mdl")


	self:PhysicsInit( SOLID_VPHYSICS )
end

function ENT:Think()
end

function ENT:PhysicsCollide( data, phys )
	if (string.StartWith(data.HitEntity:GetClass(), "ent_melon_")) then
		if (data.HitEntity.canMove) then
			if (not data.HitEntity.carryingMelonium) then
				data.HitEntity:SetNWFloat("mw_sick", 10)
			end
		end
	end
end