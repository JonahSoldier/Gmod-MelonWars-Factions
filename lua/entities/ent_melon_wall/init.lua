AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

local function PropSetup( ent )

	if (SERVER) then
		ent:SetNWEntity( "targetEntity", ent.targetEntity )

		--ent:SetModel( ent.modelString )

		ent:SetSolid( SOLID_VPHYSICS )         -- Toolbox

		ent:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,

		if (ent.moveType == 0) then
			local weld = constraint.Weld( ent, game.GetWorld(), 0, 0, 0, true , false )
			canMove = false
		end

		ent.phys = ent:GetPhysicsObject()
		if (IsValid(ent.phys)) then
			ent.phys:Wake()
		end

		if (ent.changeAngles) then
			ent:SetAngles( ent.Angles )
		end

		if (cvars.Number("mw_admin_spawn_time") == 1 and ent.mw_spawntime ~= nil) then
			timer.Simple( ent.mw_spawntime-CurTime(), function()
				if (IsValid(ent)) then
					MW_PropSpawn(ent)
				end
			end)
		else
			MW_PropSpawn(ent)
		end
	end

	local mw_melonTeam = ent:GetNWInt("mw_melonTeam", 0)

	local newColor = mw_team_colors[mw_melonTeam]
	ent:SetColor(newColor)
end

function ENT:Initialize()

	self:PropDefaults( self )

	self.moveType = MOVETYPE_VPHYSICS

	self.modelString = "models/hunter/blocks/cube05x105x05.mdl"
	self.materialString = "phoenix_storms/dome"

	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	PropSetup( self )

	self:SetCollisionGroup(COLLISION_GROUP_DISSOLVING)
end

function ENT:PropDeathEffect ( ent )
	MW_PropDefaultDeathEffect ( ent )
end