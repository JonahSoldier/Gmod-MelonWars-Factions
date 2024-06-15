include("shared.lua")

--TODO: Maybe make a proper on/off indicator

function ENT:GetMessage()
	local energyNetwork = MelonWars.electricNetwork[self:GetNWInt("network", nil)]
	if not energyNetwork then return "" end

	local maxWater = 4000 --Not ideal but saves us a NWVar
	local waterGenerated = self:GetNWInt("waterGenerated", 0)

	if waterGenerated >= maxWater then
		return "Water depleted. Disassembling..."
	end

	local addText = ""
	local energy = energyNetwork.energy
	local max = energyNetwork.capacity
	if max == 0 then
		addText = "No energy capacity.\nConnect batteries!"
	else
		addText = "Energy: " .. energy .. " / " .. max
	end


	if not self:GetNWBool("active", false) then
		return "Pump Off (" .. waterGenerated .. "/" .. maxWater .. "w)\n" .. addText
	end
	if energy < 5 then
		return "Not enough energy! (" .. waterGenerated .. "/" .. maxWater .. "w)\n" .. addText
	end
	return "Generating water (" .. waterGenerated .. "/" .. maxWater .. "w)\n" .. addText
end