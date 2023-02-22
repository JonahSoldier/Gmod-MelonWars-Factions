AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self.nextSlowThink = 0

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	for _, v in ipairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, "== Buildspeed modifier x1.33 spawned! ==" )
	end
	self.affectedPlayers = {}

	self.nextUsage = CurTime()
end

--[[
function ENT:Think()
	self:NextThink(CurTime()+1)
	return true
end
]]
function ENT:Use( pl )
	if self.nextUsage < CurTime() then
		for _, v in ipairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTTALK, "== Buildspeed modifier x1.33 activated by " .. tostring(pl) .. " ==" )
		end
		--[[
		net.Start("MWClient_modifySpawnTime") -- There is no receiver for MWClient_modifySpawnTime!
			net.WriteFloat(1 / 3)
		net.Send(pl)
		]]
		table.insert(self.affectedPlayers, pl)

		self.nextUsage = CurTime() + 3
	end
end

function ENT:OnRemove()
	--[[ for _, v in pairs(self.affectedPlayers) do -- There is no receiver for MWClient_modifySpawnTime!
		net.Start("MWClient_modifySpawnTime")
			net.WriteFloat(0)
		net.Send(v)
	end ]]
	for _, v in ipairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, "== Buildspeed modifier x1.33 removed! ==" )
	end
end