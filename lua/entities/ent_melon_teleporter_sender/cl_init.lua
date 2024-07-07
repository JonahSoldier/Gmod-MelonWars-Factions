include("shared.lua")

PrecacheParticleSystem("vortigaunt_charge_token")

function ENT:Initialize()
	self.onParticles = CreateParticleSystem( self, "vortigaunt_charge_token", PATTACH_ABSORIGIN_FOLLOW, 0, Vector(0,0,15))
end

function ENT:Think()
	local turnedOn = self:GetNWBool("active", false)

	self:GetTable().onParticles:SetShouldDraw(turnedOn)

	self:SetNextClientThink(CurTime() + 2.5)
	return true
end