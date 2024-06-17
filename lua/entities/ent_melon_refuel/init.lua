AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/xqm/jetenginepropellerlarge.mdl"
	self.moveType = MOVETYPE_NONE
	self.canMove = false
	self.canShoot = false
	self.maxHP = 100

	self.active = true

	self.slowThinkTimer = 1

	self.population = 1

	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self:Setup()
end


function ENT:SlowThink(ent) --TODO: Rework, Currently overcharges fighters among other issues. I was actually surprised how bare-bones this file is compared to most of the other buildings I added.
	for i, v in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
		if v:GetClass() == "ent_melon_fighter" then
			v:SetNWInt("fuel", v:GetNWInt("fuel", 0) + 1)
		end
	end
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end