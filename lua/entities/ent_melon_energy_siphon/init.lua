AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_stripebox01a.mdl"
	self.maxHP = 50

	--self.Angles = Angle(0,0,0)

	self.population = 5

	self.capacity = 0
	self.connectToMachines = true
	self:SetNWVector("energyPos", Vector(0,0,60))

	MelonWars.energySetup ( self )
	timer.Simple(0.5, function () self:ConnectToBarrack() end)

	self.connectionRange = 750

	--timer.Simple(0.1, function () self:Special_CalculateConnections(self, true) end)

	timer.Simple(0.1, function () self:Siphon_Connect(self, true) end)

	self.targetConnections = {}
end

function ENT:Think(ent)

	--TODO: Possibly re-connect to any newly built energy 
	for k, v in pairs(self.targetConnections) do
		if(IsValid(v)) then
			if((MelonWars.electricNetwork[self.network].capacity - MelonWars.electricNetwork[self.network].energy >= 5)) then
				if(MelonWars.electricNetwork[v.network].energy >= 5) then
					v:DrainPower(5)
					self:GivePower(5) --Steal power if we have space for it
				end
			else
				v:DrainPower(1) --Discharge power if we don't have space
			end
		end
	end

	self:Energy_Set_State()
	self:NextThink( CurTime()+1 )
	return true
end


function ENT:ConnectToBarrack() --TODO: This sucks and it's used in a few places. Rewrite and separate into standard function.
	local connected = false
	local entities = ents.FindInSphere( self:GetPos(), self.range )
		--------------------------------------------------------Disparar
	local foundEntities = {}

	for k, v in pairs(entities) do
		if ((v.Base == "ent_melon_base") and v:GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", 0)) then -- si no es un aliado
			table.insert(foundEntities, v)
		end
	end

	local closestEntity = nil
	local closestDistance = 0
	for k, v in pairs(foundEntities) do
		if (closestEntity == nil or self:GetPos():DistToSqr( v:GetPos() ) < closestDistance) then
			closestEntity = v
			closestDistance = self:GetPos():DistToSqr( v:GetPos() )
		end
	end

	if (closestEntity ~= nil) then
		self.connection = closestEntity
	else
		for k, v in pairs(player.GetAll()) do
			if (v:GetInfoNum("mw_team", 0) == self:GetNWInt("mw_melonTeam", 0)) then
				v:PrintMessage( HUD_PRINTTALK, "== Siphons require nearby units to build! ==" )
			end
		end
		self:Remove()
	end

end

function ENT:Siphon_Connect(ent,all)
	local foundEnts = ents.FindInSphere(ent:GetPos(), ent.connectionRange)

	for k, v in pairs(foundEnts) do
		if v.Base == "ent_melon_energy_base" and not ent:SameTeam(v) then
			table.insert( ent.targetConnections, v)
		end
	end

	for k, v in pairs(ent.targetConnections) do
		constraint.Rope( ent, v, 0, 0, ent:GetNWVector("energyPos",Vector(0,0,0)), v:GetNWVector("energyPos",Vector(0,0,0)), ent:LocalToWorld( ent:GetNWVector("energyPos",Vector(0,0,0)) ):Distance(v:LocalToWorld( v:GetNWVector("energyPos",Vector(0,0,0)) )), 125, 1, 3, "cable/cable2", false )
	end
end

function ENT:SlowThink(ent) end

function ENT:Shoot( ent ) end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end