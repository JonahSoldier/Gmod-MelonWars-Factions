AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_circuitbreaker01a.mdl"
	self.maxHP = 100
	self.range = 999999
	--self.Angles = Angle(0,0,0)
	--/local offset = Vector(0,0,50)
	--offset:Rotate(self:GetAngles())
	--self:SetPos(self:GetPos()+offset)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", true)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))

	MelonWars.energySetup ( self )

	self.currentPowerEffect = 0 --Almost definitely not the best way to do this but idc
	timer.Simple(0.5, function () self:ConnectToBarrack() end)
end

function ENT:ConnectToBarrack()
	local entities = ents.FindInSphere( self:GetPos(), 999999 )
		--------------------------------------------------------Disparar
	local found = false

	for k, v in pairs(entities) do
		if ((v:GetClass() == "ent_melon_energy_powerupgrader") and v:GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", 0) and v ~= self) then

			for k, v in pairs(player.GetAll()) do
				if (v:GetInfoNum("mw_team", 0) == self:GetNWInt("mw_melonTeam", 0)) then
					v:PrintMessage( HUD_PRINTTALK, "== You can only have one Anti-power Reactor at a time. ==" )
				end
			end
			self:Remove()
		end
	end
end

function ENT:Think(ent)
	if(self.spawned) then
		local energyCost = 35 -- max reduction
		local powerAffected = 0

		--if(MelonWars.electricNetwork[self.network].energy > 0) then

		if (powerAffected < MelonWars.electricNetwork[self.network].energy) then
			if (powerAffected < energyCost) then
				if(MelonWars.electricNetwork[self.network].energy > energyCost) then
					powerAffected = energyCost
				else
					powerAffected = MelonWars.electricNetwork[self.network].energy
				end
			end
		else
			powerAffected = MelonWars.electricNetwork[self.network].energy
		end

		if (self:DrainPower(powerAffected)) then
			if (self.currentPowerEffect ~= powerAffected) then
				MelonWars.updatePopulation(self.currentPowerEffect-powerAffected, self:GetNWInt("mw_melonTeam",-1))
			end

			self.currentPowerEffect = powerAffected
		end

		/*if(MelonWars.electricNetwork[self.network].energy > powerAffected) then
			powerAffected = powerAffected - 1
			MelonWars.updatePopulation(1, self:GetNWInt("mw_melonTeam",-1))
		end*/

		self:Energy_Add_State()
	end

	self:NextThink( CurTime()+1 )

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
	if (self.currentPowerEffect ~= 0) then
		MelonWars.updatePopulation(self.currentPowerEffect, self:GetNWInt("mw_melonTeam",-1))
	end
end





/*

			if (self:DrainPower(energyCost)) then

				self:SetNWString("message", "Reducing power.")

				if not self.powerReduced then
					--MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)]-15
					MelonWars.updatePopulation(-15, self:GetNWInt("mw_melonTeam",-1))
					--This is for reducing team power

					for k, v in pairs( player.GetAll() ) do
						if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
							net.Start("MW_TeamUnits")
								net.WriteInt(MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] ,32)
							net.Send(v)
						end
					self.powerReduced = true
					end
				end
			end
		else

			if self.powerReduced then
				--MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)]+15
				MelonWars.updatePopulation(15, self:GetNWInt("mw_melonTeam",-1))

				for k, v in pairs( player.GetAll() ) do
					if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
						net.Start("MW_TeamUnits")
							net.WriteInt(MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] ,32)
						net.Send(v)
					end
				end
				self.powerReduced = false
			end

		end
*/