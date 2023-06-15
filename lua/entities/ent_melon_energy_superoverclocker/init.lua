AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_circuitbreaker01a.mdl"
	self.maxHP = 250
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
end

function ENT:Think(ent)
	local powerReduced

	if self.spawned then
		local energyCost = 20
		print(self:GetOwner().GetNWInt(mw_spawntime,0))

		if (MelonWars.electricNetwork[self.network].energy >= energyCost) then
			if (self:DrainPower(energyCost)) then

				self:SetNWString("message", "Reducing power.")

				if not powerReduced then
					MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] - 15
					--This is for reducing team power

					for _, v in ipairs( player.GetAll() ) do
						if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
							net.Start("MW_TeamUnits")
								net.WriteInt(MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] ,32)
							net.Send(v)
						end
					powerReduced = true
					end
				end
			end
		else

			if powerReduced then
				MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] + 15
				--Reducing power or something, if this comment's still here in the final product I forgot to remove it.

				for _, v in ipairs( player.GetAll() ) do
					if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
						net.Start("MW_TeamUnits")
							net.WriteInt(MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] ,32)
						net.Send(v)
					end
				end
				powerReduced = false
			end

		end
		self:Energy_Add_State()
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