include('shared.lua')

function ENT:Initialize()
	self.drawPos = self:GetPos() + Vector(0,0,20)
	self:SetPos(self.drawPos)
end

function ENT:Draw()
	self:SetPos(self:GetTable().drawPos)
	self:DrawModel()
end