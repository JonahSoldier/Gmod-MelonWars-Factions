include("shared.lua")

function ENT:Initialize()
	self.lastAttack = 0
	self.circleSize = 50
end

function ENT:AttackParticle()
	local pos = self:GetPos() + Vector(0,0,200)
	local emitter = ParticleEmitter( pos )
	local part = emitter:Add( "effects/ar2_altfire1", pos  )

	part:SetDieTime( 13 )

	part:SetStartSize( 20 )
	part:SetEndSize( 20 )

	emitter:Finish()
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

	local autoFireText
	if self:GetNWBool("active", false) then
		autoFireText = "<AutoFire Enabled>\n"
	else
		autoFireText = "<AutoFire Disabled>\n"
	end

	if energy < 5000 then
		return "Not Enough Energy\n" .. autoFireText .. addText
	end
	if CurTime() - self.lastAttack < 30 then
		return "Cooling Down...\n" .. autoFireText .. addText
	end

	return "Ready To Fire\n" .. autoFireText .. addText
end