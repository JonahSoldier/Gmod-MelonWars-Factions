AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

local Network = {}
Network.active = true
Network.name = "Nameless network"
Network.energy = 0
Network.capacity = 0
Network.elements = {}

MelonWars.electricNetwork = MelonWars.electricNetwork or {}

local lastThink = 0
hook.Add("Think", "MW_UpdateNetWorks", function() --This is similar to using setNW on an entity, but will send less data than the old solution.
	if CurTime() - lastThink < 1 then return end

	for i, v in pairs(MelonWars.electricNetwork) do --TODO: idk if this table stays sequential or not.
		if not(v.updated == false) then
			net.Start("MW_UpdateNetwork")
				net.WriteUInt(i, 10)
				net.WriteUInt(v.energy, 20)
				net.WriteUInt(v.capacity, 20)
			net.Broadcast()
			v.updated = false
		end
	end

	lastThink = CurTime()
end)

local function MW_Network()
	return table.Copy( Network )
end

local function MW_Energy_Network_New(ent)
	local newNetwork = nil
	local recycled = false
	local index = 0
	for k, v in pairs(MelonWars.electricNetwork) do
		if not(recycled or v.active) then
			v.active = true
			index = k
			newNetwork = v
			recycled = true
			break
		end
	end
	if not recycled then
		newNetwork = MW_Network()
		index = table.insert(MelonWars.electricNetwork, newNetwork)
	end

	newNetwork.name = "Network " .. index
	ent:SetNetwork(index)
end

local function MW_Energy_Deactivate_Network(nw)
	nw.active = false
	nw.capacity = 0
	table.Empty(nw.elements)
	nw.energy = 0
	nw.name = "Network"
end

local function MW_Energy_Network_Merge(ent, networkA, networkB)
	--MW_Energy_Network_Insert_Element(ent, networkA)
	local nwa = MelonWars.electricNetwork[networkA]
	local nwb = MelonWars.electricNetwork[networkB]
	--nwa.capacity = nwa.capacity + nwb.capacity
	nwa.energy = nwa.energy + nwb.energy
	nwa.updated = true
	local count = table.Count(nwb.elements)
	local safety = 0
	for i=1, count do
		nwb.elements[1]:SetNetwork(networkA)
		if (safety >= 10000) then break end
	end
	if (safety >= 10000) then error("SAFETY MERGE STOP") end
	MW_Energy_Deactivate_Network(nwb)
end

local function MW_CleanUp_Network(network)
	local deleted = 0
	for k, v in pairs(MelonWars.electricNetwork[network].elements) do
		if not IsValid(MelonWars.electricNetwork[network].elements[k-deleted]) then
			table.remove( MelonWars.electricNetwork[network].elements, k-deleted )
			deleted = deleted + 1
		end
	end
	if (table.Count(MelonWars.electricNetwork[network].elements) == 0) then
		MW_Energy_Deactivate_Network(MelonWars.electricNetwork[network])
	end
end

local function MW_Energy_Network_Insert_Element(ent, network)
	MW_CleanUp_Network(network)
	local nw = MelonWars.electricNetwork[network]
	nw.active = true
	nw.capacity = nw.capacity + ent.capacity
	nw.updated = true
	table.insert(nw.elements, ent)
	ent.network = network
	ent:SetNWInt("network", network)
end

function MelonWars.calculateConnections(ent, all)
	timer.Simple(0.05, function ()
		constraint.RemoveConstraints( ent, "Rope" )
		local foundEntities = table.Add(foundConnections, ents.FindInSphere(ent:GetPos(), ent.connectionRange))
		local count = 0
		local hasConnection = false
			--find every energy entity
		local pos = ent:OBBCenter()
		table.sort( foundEntities, function( a, b ) return ((a:GetPos()-pos):LengthSqr() < (b:GetPos()-pos):LengthSqr()) end )
		for k, v in pairs(foundEntities) do
			if (count >= 3) then break end
			if (v ~= ent) then
				if ((all == true and v.Base == "ent_melon_energy_base") or (all == false and v.connectToMachines) or (ent.connectToRelaysOnly == true and string.StartWith(v:GetClass(), "ent_melon_energy_relay"))) then
					if (v.allowConnections == true) then
						if (ent:SameTeam(v)) then
							table.insert(ent.connections, v)
							table.insert(v.connections, ent)
							if not all or string.StartWith(v:GetClass(), "ent_melon_energy_relay") then
								count = count + 1
							end
							hasConnection = true
						end
					end
				end
			end
		end
		--wires!
		for k, v in pairs(ent.connections) do
			constraint.Rope( ent, v, 0, 0, ent:GetNWVector("energyPos",Vector(0,0,0)), v:GetNWVector("energyPos",Vector(0,0,0)), ent:LocalToWorld( ent:GetNWVector("energyPos",Vector(0,0,0)) ):Distance(v:LocalToWorld( v:GetNWVector("energyPos",Vector(0,0,0)) )), 100, 1, 3, "cable/cable2", false )
		end
		--include self in network system
		if (hasConnection == false) then
			--no connections make new network
			MW_Energy_Network_New(ent)
		else
			local nw = -1
			for k, v in pairs(ent.connections) do
				local othernw = v.network
				if (nw == -1) then
					nw = othernw
					MW_Energy_Network_Insert_Element(ent, nw)
				else
					if (nw ~= othernw) then
						MW_Energy_Network_Merge(ent, nw, othernw)
					end
				end
				MW_CleanUp_Network(othernw)
			end
			MW_CleanUp_Network(nw)
		end
	end)
end

local function MW_Energy_Network_Search(ent, targetEnt)
	local openList = {}
	local closedList = {}
	local foundEnt = nil
	local safety = 0
	table.insert(openList, ent)
	while(table.Count(openList) > 0 and foundEnt == nil and safety < 10000) do
		local current = openList[1]

		current.alreadySearched = true
		table.insert(closedList, current)
		table.RemoveByValue(openList, current)
		for k, v in pairs(current.connections) do
			if (v == ent) then continue end
			if (v.alreadySearched == false) then
				if (v == targetEnt) then
					foundEnt = v
					current.alreadySet = true
				end
				table.insert(openList, v)
				v.alreadySearched = true
			end
		end
		safety = safety + 1
	end
	if (safety == 10000) then
		error("SAFETY SEARCH STOP")
	end
	local found = (foundEnt ~= nil)
	table.Add(closedList, openList)
	for k, v in pairs(closedList) do
		v.alreadySearched = false
	end
	return closedList, found
end

function MelonWars.energyNetworkRemoveElement(ent)
	local network = ent.network
	local nw = MelonWars.electricNetwork[network]
	if (nw ~= nil) then
		nw.energy = nw.energy-ent:GetEnergy()
		nw.capacity = nw.capacity - ent.capacity
		nw.updated = true
		table.RemoveByValue( nw.elements, ent )
		local touched = {}
		local ambassador = nil
		local totalSeparatedEnergy = 0
		for k, v in pairs(ent.connections) do
			if (k == 1) then
				ambassador = v
				v.alreadySet = true
				table.insert(touched, v)
			else
				local searched, found = MW_Energy_Network_Search(v, ambassador)
				if (istable(searched)) then
					if (found == false) then
						if (v.alreadySet == false) then
							local separatedEnergy = 0
							local newNetwork = 0
							for j, i in pairs(searched) do
								separatedEnergy = separatedEnergy + i:GetEnergy(i.network)
								if (j == 1)  then
									MW_Energy_Network_New(i)
									newNetwork = i.network
								else
									i:SetNetwork(newNetwork)
								end
								i.alreadySet = true
								table.insert(touched, i)
							end
							MelonWars.electricNetwork[newNetwork].energy = separatedEnergy
							MelonWars.electricNetwork[newNetwork].updated = true
							totalSeparatedEnergy = totalSeparatedEnergy + separatedEnergy
						end
						for j, i in pairs(searched) do
							table.insert(touched, i)
						end
					end
				end
				v.alreadySet = false
			end
		end
	end
	if (istable(touched)) then
		for k, v in pairs(touched) do
			v.alreadySet = false
			v.alreadySearched = false
		end
		table.Empty(touched)
	end
	MW_CleanUp_Network(network)
end

function MelonWars.energyDefaults( ent )
	MelonWars.defaults(ent)

	ent.moveType = MOVETYPE_NONE
	ent.connections = {}
	ent.capacity = 0
	ent.canMove = false
	ent.slowThinkTimer = 10
	ent.connectToMachines = false
	ent.connectToRelaysOnly = false
	ent.allowConnections = true
	ent.alreadySearched = false
	ent.alreadySet = false
	ent.connectionRange = 200

	ent.network = 0

	ent:SetNWFloat("percentage", 0)
end

function MelonWars.energySetup( ent )
	ent:Setup()
	MelonWars.calculateConnections(ent, ent.connectToMachines)
end

function ENT:Energy_Set_State() --TODO: This function might not be needed any more
	local energy = MelonWars.electricNetwork[self.network].energy
	if (tostring(energy) == "nan") then
		MelonWars.electricNetwork[self.network].energy = 0
		MelonWars.electricNetwork[self.network].updated = true
	end
end

function ENT:Energy_Add_State() --TODO: This function might not be needed any more
	local energy = MelonWars.electricNetwork[self.network].energy
	if (tostring(energy) == "nan") then
		MelonWars.electricNetwork[self.network].energy = 0
		MelonWars.electricNetwork[self.network].updated = true
	end
end

function ENT:OnRemove()
	if (istable(self.connections)) then
		for k, v in pairs(self.connections) do
			table.RemoveByValue(v.connections, self)
		end
	end
	MelonWars.energyNetworkRemoveElement(self)
	self:DefaultOnRemove()
end

function ENT:SetNetwork(network)
	local previousNetwork = self.network

	if (previousNetwork > 0) then
		if (previousNetwork ~= nil) then
			local prevnw = MelonWars.electricNetwork[previousNetwork]
			prevnw.energy = prevnw.energy-self:GetEnergy()
			prevnw.capacity = prevnw.capacity - self.capacity
			prevnw.updated = true
			table.RemoveByValue( prevnw.elements, self )
			if (table.Count( prevnw.elements ) == 0) then
				MW_Energy_Deactivate_Network(prevnw)
			end
		end
	end

	MW_Energy_Network_Insert_Element(self, network, self:GetEnergy(previousNetwork))
end

function ENT:GetEnergy(network) --TODO: Is there even a point of passing network here?
	local selfTbl = self:GetTable()
	network = network or selfTbl.network

	if selfTbl.network > 0 then
		local energyNetwork = MelonWars.electricNetwork[selfTbl.network]
		return math.floor(energyNetwork.energy * (selfTbl.capacity / energyNetwork.capacity))
	else
		return 0
	end
end

function ENT:DrainPower(power) --TODO: See if we can use this and GivePower to reliably detect updates. I'm not sure if any entities mess with energy directly.
	local energyNetwork = MelonWars.electricNetwork[self:GetTable().network]
	if (energyNetwork.energy >= power) then
		energyNetwork.energy = energyNetwork.energy - power
		energyNetwork.updated = true
		return true
	end
	return false
end

function ENT:GivePower(power)
	local netIndex = self:GetTable().network
	if (netIndex > 0) then
		local nw = MelonWars.electricNetwork[netIndex]
		if (nw.energy + power > nw.capacity) then
			return false
		else
			nw.energy = nw.energy + power
			nw.updated = true
		end
	end
	return true
end