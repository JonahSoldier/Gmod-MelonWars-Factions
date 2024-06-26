include( "shared.lua" )

local angOffset = Angle( -90, 0, 0 )
local vOffset = Vector( 0, 0, 40 )
function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side
	if self:GetNWInt("capture") < 100 or cvars.Number( "mw_team" ) ~= self:GetNWInt( "capTeam", -1 ) then return end
	local angle = LocalPlayer():EyeAngles() + angOffset
	local vpos = self:WorldSpaceCenter() + vOffset + angle:Forward() * 7 + angle:Right() * 7

	cam.Start3D2D( vpos, angle, 1 )
		--Display de actividad
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