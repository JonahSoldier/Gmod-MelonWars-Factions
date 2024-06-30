include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	if EyePos():DistToSqr(self:GetPos()) > 100000 then return end

	local angle = LocalPlayer():EyeAngles() + Angle( -90, 0, 0 )
	local vpos = self:WorldSpaceCenter() + Vector( 0, 0, 20 ) + angle:Right() * 10

	cam.Start3D2D( vpos, angle, 1 )
		surface.SetDrawColor( 0, 100, 50, 255 )
		surface.DrawRect( -10, -15, 10, 10 )
		surface.SetDrawColor( 0, 255, 0, 255 )
		surface.DrawOutlinedRect( -10, -15, 10, 10 )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( -8, -12, 6, 1 )
		surface.DrawRect( -8, -12, 1, 4 )
		surface.DrawRect( -5, -12, 1, 4 )
		surface.DrawRect( -3, -12, 1, 4 )
	cam.End3D2D()
end