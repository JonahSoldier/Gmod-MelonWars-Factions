include("shared.lua")

MelonWars.electricNetwork = MelonWars.electricNetwork or {}

hook.Add( "Think", "MelonWars_EnergyMessage", function()
	local ent = LocalPlayer():GetEyeTrace().Entity --The trace for this is already run automatically on client, so it's not expensive to use it here.
	local entTbl = ent:GetTable()
	if entTbl and entTbl.GetMessage then --Apparently entities' lua tables get removed before the entity itself does?
		AddWorldTip( nil, ent:GetMessage(), nil, vector_origin, ent )
	end
end )

net.Receive("MW_UpdateNetwork", function()
	local index = net.ReadUInt(10)
	local energyNetworks = MelonWars.electricNetwork
	energyNetworks[index] = energyNetworks[index] or {}

	local eNetwork = MelonWars.electricNetwork[index]
	eNetwork.energy = net.ReadUInt(20)
	eNetwork.capacity = net.ReadUInt(20)
end)

function ENT:GetState()
	local energyNetwork = MelonWars.electricNetwork[self:GetNWInt("network", nil)]
	if not energyNetwork then return 0 end
	local energy = energyNetwork.energy
	local max = energyNetwork.capacity

	local state = math.Round( energy / max * 1000)
	state = (max == 0 and 0) or state

	return state
end

function ENT:GetMessage()
	local energyNetwork = MelonWars.electricNetwork[self:GetNWInt("network", nil)]
	if not energyNetwork then return "" end
	local energy = energyNetwork.energy
	local max = energyNetwork.capacity
	if max == 0 then
		return "No energy capacity.\nConnect batteries!"
	else
		return "Energy: " .. energy .. " / " .. max
	end
end