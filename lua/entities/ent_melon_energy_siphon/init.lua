AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_stripebox01a.mdl"
	self.maxHP = 50

	self.population = 5

	self.capacity = 0
	self.connectToMachines = true
	self:SetNWVector("energyPos", Vector(0,0,60))

	MelonWars.energySetup ( self )
	self.connectionRange = 750

	timer.Simple(0.1, function ()
		self:FriendlyUnitsNearby()
		self:Siphon_Connect()
	end)

	self.targetConnections = {}
end

function ENT:Think(ent)
	local selfTbl = self:GetTable()
	for i, v in ipairs(selfTbl.targetConnections) do
		if IsValid(v) then
			if MelonWars.electricNetwork[selfTbl.network].capacity - MelonWars.electricNetwork[selfTbl.network].energy >= 5 then
				if MelonWars.electricNetwork[v.network].energy >= 5 then
					v:DrainPower(5)
					self:GivePower(5) --Steal power if we have space for it
				end
			else
				v:DrainPower(1) --Discharge power if we don't have space
			end
		end
	end

	self:Siphon_Connect()

	self:Energy_Set_State()
	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:FriendlyUnitsNearby()
	local selfTeam = self:GetNWInt("mw_melonTeam", 0)
	if cvars.Bool("mw_admin_allow_free_placing") or MelonWars.isInRange( self:GetPos(), selfTeam ) then return end

	for i, v in ipairs(ents.FindInSphere( self:GetPos(), self.range)) do
		if v.Base == "ent_melon_base" and MelonWars.sameTeam(v:GetNWInt("mw_melonTeam", 0), selfTeam) then
			return
		end
	end

	MelonWars.broadcastTeamMessage(selfTeam, "== Siphons require nearby units to build! ==")
	self:Remove()
end

function ENT:Siphon_Connect()
	if not self:IsValid() then return end

	local selfEnergyPos = self:GetNWVector("energyPos",vector_origin)
	for i, v in ipairs(ents.FindInSphere(self:GetPos(), self.connectionRange)) do
		if v.Base == "ent_melon_energy_base" and not self:SameTeam(v) and not table.HasValue(self.targetConnections, v) then
			table.insert(self.targetConnections, v)

			local vEnergyPos = v:GetNWVector("energyPos",vector_origin)
			constraint.Rope( self, v, 0, 0, selfEnergyPos, vEnergyPos, self:LocalToWorld( selfEnergyPos ):Distance(v:LocalToWorld( vEnergyPos )), 125, 0, 3, "cable/cable2", false )

			local zap = CreateSound( v, "ambient.electrical_random_zap_1" )
			zap:Play()
		end
	end
end

function ENT:Shoot( ent ) end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end