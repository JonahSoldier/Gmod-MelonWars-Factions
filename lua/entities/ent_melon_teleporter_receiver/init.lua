AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/props_lab/teleplatform.mdl"
	self.maxHP = 75
	self.shotOffset = Vector(0,0,10)

	self.moveType = MOVETYPE_NONE
	self.canMove = false
	self.population = 1

	self:Setup()

	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	timer.Simple(0.1, function () self:FriendlyUnitsNearby() end)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2+100, self:GetColor().g/2+100, self:GetColor().b/2+100, 255))
end

function ENT:SlowThink(ent)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:FriendlyUnitsNearby()
	local selfTeam = self:GetNWInt("mw_melonTeam", 0)
	for i, v in ipairs(ents.FindInSphere( self:GetPos(), 250)) do
		if not(v:GetClass() == "ent_melon_teleporter_receiver") and v.Base == "ent_melon_base" and MelonWars.sameTeam(v:GetNWInt("mw_melonTeam", 0), selfTeam) then
			return
		end
	end

	MelonWars.broadcastTeamMessage(selfTeam, "== Receivers require nearby units to build! ==")
	self:Remove()
end