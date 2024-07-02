include("shared.lua")

function ENT:GetMessage()
	local energyNetwork = MelonWars.electricNetwork[self:GetNWInt("network", nil)]
	if not energyNetwork then return "" end

	local addText = ""
	local energy = energyNetwork.energy
	local max = energyNetwork.capacity
	if max == 0 then
		addText = "No energy capacity.\nConnect batteries!"
	else
		addText = "Energy: " .. energy .. " / " .. max
	end

	if energy + 250 > max then
		return "Energy full!\n" .. addText
	else
		local turnedOn = self:GetNWBool("active", false)
		local onText = (turnedOn and "Importing energy\n") or "Generator Off\n"
		return onText .. addText
	end
end