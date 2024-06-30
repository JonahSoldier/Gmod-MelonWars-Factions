include("shared.lua")

function ENT:Initialize()
	self.nextBoop = 0
	self.digit = 0
end

function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	local s = 7
	cam.Start3D2D( self:GetPos() + Vector(0,0,256), angle_zero, 1 )
		surface.SetDrawColor( color_black )
		surface.DrawRect( -s, -s, s*2, s*2 )
	cam.End3D2D()
end

local morze = {1,2,0,2,1,1,1,0,2,2,2,0,1,1,2,0,2,0,0,0}
function ENT:Think()
	local boopTime = 0
	if morze[self.digit] == 1 then
		sound.Play( "buttons/blip1.wav", self:GetPos(), 60, 200, 1 )
		boopTime = 0.1
	elseif morze[self.digit] == 2 then
		sound.Play( "buttons/blip1.wav", self:GetPos(), 60, 110, 1 )
		boopTime = 0.2
	else
		boopTime = 0.75
		self.nextBoop = CurTime() + 0.75
	end
	self.digit = (self.digit + 1) % (#morze)
	self:SetNextClientThink(CurTime() + boopTime)
	return true
end