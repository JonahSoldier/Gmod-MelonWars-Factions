include("shared.lua")

function ENT:Draw()
    self:DrawModel() -- Draws Model Client Side

    local state = self:GetState() / 1000
    local s = 25

    cam.Start3D2D(self:GetPos() + Vector(0, 0, 65), Angle(0, 0, 0), 1)
        surface.SetDrawColor(Color(50, 50, 50, 255))
        surface.DrawRect(-s, -s, s * 2, s * 2)
        surface.SetDrawColor(Color(0, state * 255, state * 255, 255))
        surface.DrawRect(-s + 2, -s + 2, s * 2 - 4, s * 2 - 4)
    cam.End3D2D()
end