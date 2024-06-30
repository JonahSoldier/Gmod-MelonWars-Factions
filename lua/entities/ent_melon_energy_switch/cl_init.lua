include("shared.lua")

function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	local state = (self:GetNWBool("open") and 1) or 0
	local s = 11

	cam.Start3D2D(self:GetPos() + Vector(0, 0, 20), Angle(0, 0, 0), 1)
	surface.SetDrawColor(Color(50, 50, 50, 255))
	surface.DrawRect(-s, -s, s * 2, s * 2)
	surface.SetDrawColor(Color((1 - state) * 255, state * 255, 0, 255))
	surface.DrawRect(-s + 2, -s + 2, s * 2 - 4, s * 2 - 4)
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

	if self:GetNWBool("open") then
		return "Open\n" .. addText
	else
		return "Closed\n" .. addText
	end
end