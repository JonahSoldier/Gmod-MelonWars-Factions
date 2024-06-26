AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.affectedPlayers = {}

	self.nextUsage = CurTime()
end

function ENT:Use( pl )
	if self.nextUsage >= CurTime() then return end

	local mult = self:GetSpeedMult()
	for _, v in ipairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, "== " .. pl:Nick() .. " set their Spawn-Time multiplier to " .. tostring(mult) .. "x ==" )
	end

	pl.spawnTimeMult = mult
	net.Start( "MW_ClientModifySpawnTime" )
		net.WriteFloat( mult )
	net.Send( pl )

	table.insert( self.affectedPlayers, pl )

	self.nextUsage = CurTime() + 3
end

function ENT:OnRemove()
	for _, v in ipairs( self.affectedPlayers ) do
		v.spawnTimeMult = 1
		net.Start( "MW_ClientModifySpawnTime" )
			net.WriteFloat( 1 )
		net.Send( v )
	end

	for _, v in ipairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, "== BuildSpeed Multiplier removed! Spawn-Time multiplier reset. ==" )
	end
end