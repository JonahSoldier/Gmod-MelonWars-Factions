AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_circuitbreaker01a.mdl"
	self.maxHP = 100
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", true)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))

	MelonWars.energySetup ( self )

	self.currentPowerEffect = 0

	timer.Simple(0.1, function ()
		local selfTeam = self:GetNWInt("mw_melonTeam", 0)
		for i, v in ipairs(ents.FindByClass("ent_melon_energy_powerupgrader")) do
			if v ~= self and v:GetNWInt("mw_melonTeam", 0) == selfTeam then
				for j, ply in pairs(player.GetAll()) do
					if ply:GetInfoNum("mw_team", 0) == selfTeam then
						ply:PrintMessage( HUD_PRINTTALK, "== You can only have one Anti-power Reactor at a time. ==" )
					end
				end
				self:Remove()
			end
		end
	end)
end

function ENT:Think(ent)
	local selfTbl = self:GetTable()
	if selfTbl.spawned then
		local energyCost = 35 -- max reduction
		local powerAffected = 0

		local energyNetwork = MelonWars.electricNetwork[selfTbl.network]

		powerAffected = math.min(energyNetwork.energy, energyCost)
		--TODO: Approximate energy income?

		if self:DrainPower(powerAffected) then
			if selfTbl.currentPowerEffect ~= powerAffected then
				MelonWars.updatePopulation(selfTbl.currentPowerEffect-powerAffected, self:GetNWInt("mw_melonTeam",-1))
			end

			selfTbl.currentPowerEffect = powerAffected
		end
	end

	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:SlowThink(ent)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:OnRemove()
	if self.currentPowerEffect ~= 0 then
		MelonWars.updatePopulation(self.currentPowerEffect, self:GetNWInt("mw_melonTeam",-1))
	end
end