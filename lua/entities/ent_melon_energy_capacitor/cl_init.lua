include("shared.lua")
--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    self:DrawModel() -- Draws Model Client Side

    local state = self:GetState() / 1000
    local s = 18

    cam.Start3D2D(self:GetPos() + Vector(0, 0, 45), Angle(0, 0, 0), 1)
    surface.SetDrawColor(Color(50, 50, 50, 255))
    surface.DrawRect(-s, -s, s * 2, s * 2)
    surface.SetDrawColor(Color(0, state * 255, state * 255, 255))
    surface.DrawRect(-s + 2, -s + 2, s * 2 - 4, s * 2 - 4)
    cam.End3D2D()
end