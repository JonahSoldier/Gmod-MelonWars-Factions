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
		v:PrintMessage( HUD_PRINTTALK, "This entity will boost the range of every unit on the map to 3x their default. Press E to activate." )
	end

	self.nextUsage = CurTime()
end

function ENT:Use( pl )
	if (self.nextUsage < CurTime()) then
		for k, v in pairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTTALK, "Unit stats altered", "nameasc" )
		end

		local allEnts = ents.FindInSphere( Vector(0,0,0), 60000 )

		for k, v in pairs(allEnts) do
			if(v.Base == "ent_melon_base") then
				if not v.hasRangeMultiplier then
					v.range = v.range*3
					v.hasRangeMultiplier = true
				end
			end
		end

		self.nextUsage = CurTime()+10
	end
end

function ENT:Think()
end