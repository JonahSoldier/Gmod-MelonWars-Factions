include("shared.lua")

local upAngle = Angle(0, 0, 90)

function ENT:Draw()
	-- self.BaseClass.Draw(self) -- Overrides Draw
	self:DrawModel() -- Draws Model Client Side

	local time = self:GetNWFloat("spawnTime", 0)
	local curTime = CurTime()

	if curTime < time then
		local eyeAngs = LocalPlayer():EyeAngles()
		local angle = eyeAngs + upAngle
		angle:RotateAroundAxis(eyeAngs:Up(), -90)
		local vpos = self:WorldSpaceCenter() --+angle:Forward()*10-angle:Right()*10/2
		cam.Start3D2D(vpos, angle, 0.5)
		draw.SimpleText(tostring(math.ceil(time - curTime)), "Trebuchet24", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

	self:DrawExpirationDate()
end

function ENT:Initialize()
	self.circleSize = 0
	self.nextParticle = 0
end

function MelonWars.drawSickEffect(ent, amount)
	local entPos = ent:GetPos()
	local emitter = ParticleEmitter(entPos) -- Particle emitter in this position

	for _ = 1, amount do -- SMOKE
		local part = emitter:Add("effects/yellowflare", entPos) -- Create a new particle at pos
		if part then
			part:SetDieTime(math.Rand(1.0, 2.0)) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha(255)
			part:SetEndAlpha(255) -- Particle size at the end of its lifetime
			part:SetStartSize(math.random(12, 18))
			part:SetEndSize(0) -- Size when removed
			part:SetAirResistance(50)
			local vec = AngleRand():Forward() * math.random(10, 50)
			part:SetGravity(Vector(0, 0, 50)) -- Gravity of the particle
			part:SetVelocity(vec * 0.8) -- Initial velocity of the particle
		end
	end

	emitter:Finish()
end

function MelonWars.drawSiloSmoke(ent, amount)
	local entPos = ent:GetPos()
	local emitter = ParticleEmitter(entPos) -- Particle emitter in this position

	for _ = 1, amount do -- SMOKE
		local part = emitter:Add("effects/yellowflare", entPos + Vector(math.random(-30, 30), math.random(-30, 30), 0)) -- Create a new particle at pos
		if part then
			part:SetDieTime(math.Rand(1.0, 2.0)) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha(255)
			part:SetEndAlpha(255) -- Particle size at the end of its lifetime
			part:SetStartSize(math.random(10, 20))
			part:SetEndSize(0) -- Size when removed
			part:SetAirResistance(50)
			local vec = Vector(0, 0, math.random(100, 500))
			vec.z = math.abs(vec.z)
			part:SetGravity(Vector(0, 0, 50)) -- Gravity of the particle
			part:SetVelocity(vec) -- Initial velocity of the particle
		end
	end

	emitter:Finish()
end

local traceStartOff = Vector(0, 0, 20)
local traceEndOff = Vector(0, 0, -280)
local floorTrace = {
	filter = { "prop_physics" },
	whitelist = true,
	mask = bit.bor(MASK_SOLID, MASK_WATER)
}

function ENT:Think()
	local selfTbl = self:GetTable()
	local pos = self:GetPos()

	floorTrace.start = pos + traceStartOff
	floorTrace.endpos = pos + traceEndOff

	local tr = util.TraceLine(floorTrace)
	selfTbl.floorTrace = tr

	if selfTbl.circleSize == 0 then
		local baseSize = self:GetNWFloat("baseSize", -1)
		if baseSize > -1 then selfTbl.circleSize = baseSize end
	end

	if selfTbl.nextParticle and selfTbl.nextParticle < CurTime() then
		local sick = self:GetNWFloat("mw_sick", 0)
		if sick > 0 then
			MelonWars.drawSickEffect(self, 1)
			selfTbl.nextParticle = CurTime() + math.min(1 / sick, 1)
		end
	end
end

function ENT:DrawExpirationDate()
	if self:GetNWFloat("expiration", -1) == -1 then return end
	local vpos = self:GetPos() + Vector(0, 0, 30)
	local eyeAngle = LocalPlayer():EyeAngles()
	local angle = eyeAngle + upAngle
	angle:RotateAroundAxis(eyeAngle:Up(), -90)
	local timeLeft = self:GetNWFloat("expiration") - CurTime()
	cam.Start3D2D(vpos, angle, 0.5)
	draw.SimpleText(tostring(math.ceil(timeLeft)), "Trebuchet18", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:BarrackDraw(self, offset)
	if cvars.Number("mw_team") == self:GetNWInt("mw_melonTeam", -1) then
		render.SetMaterial(Material("color"))
		--render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
		local angle = LocalPlayer():EyeAngles() + Angle(-90, 0, 0)
		local vpos = self:WorldSpaceCenter() + Vector(0, 0, 16) + Vector(0, 0, offset) + angle:Forward() * 10 - angle:Right() * 5 / 2
		local NST = self:GetNWFloat("nextSlowThink", 0)
		local STT = self:GetNWFloat("slowThinkTimer", 0)
		local OD = self:GetNWFloat("overdrive", 0)
		cam.Start3D2D(vpos, angle, 1)
		if not self:GetNWBool("spawned", false) and NST > CurTime() then
			surface.SetDrawColor(Color(0, 255, 255))
			surface.DrawRect(0, -15, 5, math.min(35, 35 + (CurTime() + OD - NST) * 35 / STT))
			surface.SetDrawColor(Color(255, 240, 0))
			surface.DrawRect(0, -15, 5, 35 + (CurTime() - NST) * 35 / STT)
			surface.SetDrawColor(color_black)
			surface.DrawOutlinedRect(0, -15, 5, 35)
		end

		--Display de actividad
		if self:GetNWBool("active", false) then
			surface.SetDrawColor(Color(0, 255, 0, 255))
		else
			surface.SetDrawColor(Color(255, 0, 0, 255))
		end

		surface.DrawRect(-10, -15, 10, 10)
		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(-10, -15, 10, 10)
		--Display de unidades
		surface.SetDrawColor(Color(50, 50, 50, 255))
		local m = self:GetNWInt("maxunits", 0)
		for i = 1, 5 do
			if i <= m then surface.DrawRect(-5, -10 + i * 5, 5, 5) end
		end

		for i = 6, 10 do
			if i <= m then surface.DrawRect(-10, -10 + (i - 5) * 5, 5, 5) end
		end

		surface.SetDrawColor(color_white)
		local c = self:GetNWInt("count", 0)
		surface.DrawRect(-5, -5, 5, math.min(c, 5) * 5)
		if c > 5 then surface.DrawRect(-10, -5, 5, (c - 5) * 5) end
		surface.SetDrawColor(color_black)
		for i = 1, 5 do
			if i <= m then surface.DrawOutlinedRect(-5, -10 + i * 5, 5, 5) end
		end

		for i = 6, 10 do
			if i <= m then surface.DrawOutlinedRect(-10, -10 + (i - 5) * 5, 5, 5) end
		end

		cam.End3D2D()
	end

	local time = self:GetNWFloat("spawnTime", 0)
	if CurTime() >= time then return end
	local eyeAngle = LocalPlayer():EyeAngles()
	local angle = eyeAngle + upAngle
	angle:RotateAroundAxis(eyeAngle:Up(), -90)
	local vpos = self:WorldSpaceCenter() --+angle:Forward()*10-angle:Right()*10/2
	cam.Start3D2D(vpos, angle, 0.5)
	draw.SimpleText(tostring(math.ceil(time - CurTime())) .. "s", "Trebuchet24", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:OnRemove()
	for _, v in pairs(self:GetChildren()) do
		v:Remove()
	end
end
--[[
function ENT:OnRemove() -- New Year
	MW_Firework(self, 50, 1)
end
]]