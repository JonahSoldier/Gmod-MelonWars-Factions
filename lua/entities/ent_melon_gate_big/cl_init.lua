include("shared.lua")

local greyCol = Color(50, 50, 50, 255)
local greenCol = Color(0, 255, 0, 255)
local redCol = Color(255, 0, 0, 255)
local beamOffset = Vector(0, 0, -220)
local vOffset = Vector(0, 0, 16)
local angOffset = Angle(-90, 0, 0)
local colorMat = Material("color")
function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	local selfPos = self:GetPos()

	render.SetMaterial( colorMat )
	render.DrawBeam(selfPos, selfPos + beamOffset, 4, 1, 1, greyCol)

	local angle = LocalPlayer():EyeAngles() + angOffset
	local vpos = self:WorldSpaceCenter() + vOffset - angle:Forward() * 10 + angle:Right() * 10 + angle:Up() * 4

	cam.Start3D2D(vpos, angle, 1)
		if self:GetNWBool("open", false) then
			surface.SetDrawColor(greenCol)
		else
			surface.SetDrawColor(redCol)
		end

		surface.DrawRect(-10, -15, 10, 10)
		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(-10, -15, 10, 10)
	cam.End3D2D()
end