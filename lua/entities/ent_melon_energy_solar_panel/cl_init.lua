include("shared.lua")

function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side
	local state = self:GetState() / 1000
	local s = 60
	cam.Start3D2D(self:GetPos() + self:GetUp() * 63 + Vector(0, 0, 17), self:GetAngles() + Angle(90, 0, 180), 1)
	surface.SetDrawColor(Color(10, 10, 10, 255))
	surface.DrawRect(-s, -s, s * 2, s * 2)
	surface.SetDrawColor(Color(0, state * 255, state * 255, 255))
	surface.DrawRect(-10 + 2, -10 + 2, 10 * 2 - 4, 10 * 2 - 4)
	cam.End3D2D()
end

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

	local efficiency = self:GetNWFloat("EnergyEfficiency", 0)

	if efficiency == 0 then
		return "Sky blocked\nEfficiency:" .. tostring(efficiency) .. "%\n" .. addText
	end

	if energyNetwork.energy + 10 > energyNetwork.capacity then
		return "Energy full!\nEfficiency:" .. tostring(efficiency) .. "%\n" .. addText
	else
		return "Generating energy\nEfficiency:" .. tostring(efficiency) .. "%\n" .. addText
	end
end