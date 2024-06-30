include("shared.lua")

local vOffset = Vector(0,0,16)
local greenCol = Color( 0,255,0, 255 )
local redCol = Color( 255,0,0, 255 )
local angOffset = Angle(-90, 0, 0)
function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	local angle = LocalPlayer():EyeAngles() + angOffset
	local vpos = self:WorldSpaceCenter() + vOffset - angle:Forward() * 10 + angle:Right() * 10 + angle:Up() * 4
	cam.Start3D2D(vpos, angle, 1)
		if self:GetNWBool("active", false) then
			surface.SetDrawColor(greenCol)
		else
			surface.SetDrawColor(redCol)
		end

		surface.DrawRect(-10, -15, 10, 10)
		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(-10, -15, 10, 10)
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

	if self:GetNWBool("active", true) then
		return "Working\n" .. addText
	else
		return "Idle\n" .. addText
	end
end