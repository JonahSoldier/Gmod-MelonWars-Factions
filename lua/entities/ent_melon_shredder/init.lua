AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/props_c17/TrapPropeller_Blade.mdl"
	self.canMove = false
	self.canBeSelected = false
	self.canShoot = false
	self.maxHP = 20
	self.moveType = MOVETYPE_VPHYSICS

	self.damageDeal = 10
	self.slowThinkTimer = 0.1

	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self.careForFriendlyFire = false

	self.population = 0

	self.melons = {}
	self:Setup()

	local LPos1 = vector_origin
	local LVector = Vector(0,0,1)

	timer.Simple(0.2, function()
		constraint.RemoveAll( self )
		constraint.Axis(self, game.GetWorld(), 0, 0, LPos1, LPos1, 0, 0, 0, 0, LVector, false)
		self:GetPhysicsObject():EnableCollisions( false )
		self:SetCollisionGroup(COLLISION_GROUP_DISSOLVING)
	end)
end

function ENT:SlowThink(ent) --TODO: Refactor
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceOffset(Vector(-5000,0,0), Vector(0, 100, 0))
	phys:ApplyForceOffset(Vector(5000,0,0), Vector(0, -100, 0))

	local foundEnts = ents.FindInSphere( ent:GetPos() , 60 )
	if #foundEnts == 0 then return end

	local selfTeam = self:GetNWInt("mw_melonTeam", 0)
	for k, v in pairs( foundEnts ) do
		if (v.Base == "ent_melon_base" or v.Base == "ent_melon_energy_base") and v:GetClass() ~= "ent_melon_shredder" then
			if v.isShredding ~= true and v.HP <= self.damageDeal then
				local gain = v:GetVar("value")*0.75
				if (v.spawned and v:GetClass() == "ent_melon_voidling") then
					gain = v:GetVar("value")+1
				end
				MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam]+gain
				MelonWars.updateClientCredits(selfTeam)
				v.isShredding = true
			end

			v.damage = v.damage + self.damageDeal
			v.gotHit = true
		end
	end
end


function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end