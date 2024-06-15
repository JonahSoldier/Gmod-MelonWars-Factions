include("shared.lua")

local vOffset = Vector(0,0,-52)
local greenCol = Color( 0,255,0, 255 )
local redCol = Color( 255,0,0, 255 )
function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	render.SetMaterial( Material( "color" ) )
	local angle = self:GetAngles()
	local vpos = self:WorldSpaceCenter() + vOffset
	cam.Start3D2D( vpos, angle, 1 )
		if self:GetNWBool("active", false) then
			surface.SetDrawColor( greenCol )
		else
			surface.SetDrawColor( redCol )
		end
		surface.DrawRect( -60, -30, 30, 60 )
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( -60, -30,30, 60 )
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

	if energy + 100 > max then
		return "Energy full!\n" .. addText
	else
		local turnedOn = self:GetNWBool("active", false)
		local onText = (turnedOn and "Generating energy\n") or "Generator Off\n"
		return onText .. addText
	end
end