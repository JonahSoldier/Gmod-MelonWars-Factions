include("shared.lua")

local vOffset = Vector(0,0,16)
local greenCol = Color( 0,255,0, 255 )
local redCol = Color( 255,0,0, 255 )
function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	render.SetMaterial( Material( "color" ) )
	local angle = Angle(-69.5,LocalPlayer():EyeAngles().y,0)
	local vpos = self:WorldSpaceCenter() + vOffset - angle:Forward() * 40 + angle:Right() * 10 + angle:Up() * 25
	cam.Start3D2D( vpos, angle, 1 )
		if self:GetNWBool("active", false) then
			surface.SetDrawColor( greenCol )
		else
			surface.SetDrawColor( redCol )
		end
		surface.DrawRect( -10, -15, 50, 10 )
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( -10, -15,50, 10 )
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

	if energy + 20 > max then
		return "Energy full!\n" .. addText
	else
		local turnedOn = self:GetNWBool("active", false)
		local onText = (turnedOn and "Generating energy\n") or "Generator Off\n"
		return onText .. addText
	end
end