AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults(self)

	self.modelString = "models/props_trainstation/trainstation_column001.mdl"
	self.maxHP = 40
	self.range = 1000

	self.shotOffset = Vector(0,0,15)
	self.careForFriendlyFire = false
	self.careForWalls = false

	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 5
	self.population = 0

	self:Setup()

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:SlowThink ( ent )
	MelonWars.unitDefaultThink ( ent )
end

function ENT:Shoot ( ent )
	self:CreateAlert (ent.targetEntity:GetPos(), ent:GetNWInt("mw_melonTeam", 0))
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:CreateAlert (pos, _team)
	self:PlayHudSound("ambient/alarms/doomsday_lift_alarm.wav", 0.1, 100, _team)
	local alert = ents.Create( "ent_melon_HUD_alert" )
	alert:SetPos(pos + Vector(0,0,100))
	alert:Spawn()
	alert:SetNWInt("drawTeam", _team)
end