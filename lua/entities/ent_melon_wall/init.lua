 --[[
	Logic for base props is split between this File and ent_melon_prop_base. 
 	This isn't great but I can't be bothered to change it. Blame Marum if you don't like it.

	There used to be a lot of extra logic spread out for them in hooks and other entities as well, but I've removed all of the instances of this that I could find.
--]]

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

local function propSpawn( ent )
	if SERVER then
		ent:SetMoveType( ent.moveType )   -- after all, gmod is a physics

		ent:SetMaterial(ent.materialString)
		ent.spawned = true
		ent.HP = ent.maxHP

		hook.Run("MelonWarsEntitySpawned", ent)
	end
end

local function PropSetup( ent )
	if SERVER then
		ent:SetSolid( SOLID_VPHYSICS )
		ent:PhysicsInit( SOLID_VPHYSICS )

		if ent.moveType == 0 then
			constraint.Weld( ent, game.GetWorld(), 0, 0, 0, true , false )
			ent.canMove = false
		end

		ent.phys = ent:GetPhysicsObject()
		if IsValid(ent.phys) then
			ent.phys:Wake()
		end

		if ent.changeAngles then
			ent:SetAngles( ent.Angles )
		end

		if cvars.Number("mw_admin_spawn_time") == 1 and ent.mw_spawntime ~= nil then
			timer.Simple( ent.mw_spawntime-CurTime(), function()
				if IsValid(ent) then
					propSpawn(ent)
				end
			end)
		else
			propSpawn(ent)
		end
	end

	local mw_melonTeam = ent:GetNWInt("mw_melonTeam", 0)

	local newColor = MelonWars.teamColors[mw_melonTeam]
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

function ENT:PropDeathEffect()
	self:PropDefaultDeathEffect()
end