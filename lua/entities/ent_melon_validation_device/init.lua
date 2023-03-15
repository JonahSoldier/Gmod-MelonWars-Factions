AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self.slowThinkTimer = 2
	self:SetModel( "models/props_c17/fountain_01.mdl" )
	self.nextSlowThink = 0

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, "== WARNING ==" )
		v:PrintMessage( HUD_PRINTTALK, "The entity you have just spawned is made to forcibly update all of your contraption files." )
		v:PrintMessage( HUD_PRINTTALK, "If you have any files from the main version of melon wars that you want to keep, or any file edited files you want to keep, back them up now." )
		v:PrintMessage( HUD_PRINTTALK, "Otherwise, to activate the device and update your contraption files to work with this version, simply press E on this entity." )
	end

	self.nextUsage=CurTime()
end

function ENT:Use( pl )
	if (self.nextUsage < CurTime()) then
		for k, v in pairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTTALK, "test", "nameasc" )
		end

		--Important part starts here

		net.Start("ContraptionValidateClient")

		net.Send(pl)

		--contraptions = player:file.Find("contraptions/*.txt", "DATA")

		self.nextUsage = CurTime()+10
	end
end

function ENT:Think()
end