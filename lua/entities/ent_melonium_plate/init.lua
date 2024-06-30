AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate32x32.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )
end

function ENT:PhysicsCollide( data, phys )
	local hitEnt = data.HitEntity
	local hitEntTbl = hitEnt:GetTable()
	if hitEntTbl.Base == "ent_melon_base" and hitEntTbl.canMove and not hitEntTbl.carryingMelonium then
		hitEnt:SetNWFloat("mw_sick", 10)
	end
end