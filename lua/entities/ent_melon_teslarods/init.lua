AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_rooftop/antennaclusters01a.mdl"
	self.damageDeal = 2
	self.maxHP = 65
	self.range = 80
	self.sphereRadius = 0
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"
	self.shotOffset = Vector(0,0,65)

	self.canMove = false
	--self.canBeSelected = false --TODO: Does this do anything?
	self.moveType = MOVETYPE_NONE

	self.population = 0

	self.slowThinkTimer = 0.75

	self.AOETargetableOnly = true

	self:Setup()

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
	self:SetNotSolid(true)
	self:SetPos(self:GetPos() - Vector(0,0, 20)) --Offset relative to client display pos. This isn't a great solution but I'm not sure how else to move the serverside origin around.
end


function ENT:SlowThink ( ent )
	local selfTbl = self:GetTable()
	local selfPos = self:GetPos()
	local selfTeam = self:GetNWInt("mw_melonTeam", -1)

	local dmg = selfTbl.damageDeal
	local count = 0
	for i, v in ipairs(ents.FindInSphere( selfPos, selfTbl.range )) do
		local vTbl = v:GetTable()
		if vTbl.Base == "ent_melon_base" and not MelonWars.sameTeam(selfTeam, v:GetNWInt("mw_melonTeam", -1)) then
			vTbl.damage = vTbl.damage + dmg
			sound.Play( selfTbl.shotSound, selfPos )
			count = count + 1
		end
	end
	for i = 1, math.min(count, 10), 1 do
		selfTbl.DischargeEffect(self)
	end
end

function ENT:DischargeEffect()
	local discharge = ents.Create("point_tesla")

	discharge:SetPos(self:GetPos() + Vector(math.Rand( -25, 25 ), math.Rand( -25, 25 ), math.Rand( -10, 10 )))
	discharge:SetKeyValue("texture", "trails/laser.vmt")
	discharge:SetKeyValue("m_Color", "255 255 255")
	discharge:SetKeyValue("m_flRadius", tostring(self.range * 1.2))
	discharge:SetKeyValue("interval_min", tostring(0))
	discharge:SetKeyValue("interval_max", tostring(1))
	discharge:SetKeyValue("beamcount_min", tostring(1))
	discharge:SetKeyValue("beamcount_max", tostring(3))
	discharge:SetKeyValue("thick_min", tostring(3))
	discharge:SetKeyValue("thick_max", tostring(5))
	discharge:SetKeyValue("lifetime_min", tostring(0.1))
	discharge:SetKeyValue("lifetime_max", tostring(0.15))

	discharge:Spawn()
	discharge:Activate()

	discharge:Fire("DoSpark", "", 0)
	discharge:Fire("TurnOn", "", 0)

	timer.Simple(0.1, function() discharge:Remove()  end)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end