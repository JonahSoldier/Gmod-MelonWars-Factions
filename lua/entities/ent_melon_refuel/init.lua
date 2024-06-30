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

	self.slowThinkTimer = 1

	self.population = 1

	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self:Setup()
end

function ENT:SlowThink(ent)
	for i, v in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
		local fuel = v:GetNWInt("fuel", -1)
		if fuel > -1 then
			local maxFuel = v:GetNWInt("maxFuel", -1)
			v:SetNWInt("fuel", math.min(fuel + 1, maxFuel))
		end
	end
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end