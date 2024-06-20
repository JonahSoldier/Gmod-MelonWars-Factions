include("shared.lua")

function ENT:Initialize()
	self.lastAttack = 0
end

function ENT:Draw()
	self:DrawModel() -- Draws Model Client Side

	self:TransportDraw(self, 190)
end

--[[ NOTE: 
	I'm not sure where this function comes from, but I'm pretty confident I didn't write it, and it isn't in vanilla MW
	or (easily findable) on the wiki. So I might've just lifted it from some other addon.

	If that's the case I probably want to write my own version to replace it. This wasn't an issue when it was just a small
	unlisted addon for my community, but I don't want to put it on the workshop with code I didn't ask permission to use.
--]]
local function drawSolidCircle(x, y, radius, seg)
	local cir = {}
	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end

local mw_team_cv = GetConVar("mw_team")
local angOffset = Angle(-90, 0, 0)
function ENT:TransportDraw(self, offset)
	if mw_team_cv:GetInt() == self:GetNWInt("mw_melonTeam", -1) then
		local angle = LocalPlayer():EyeAngles() + angOffset
		local vpos = self:WorldSpaceCenter() + Vector(20, 0, 16 + offset) + angle:Forward() * 10 - angle:Right() * 6

		cam.Start3D2D(vpos, angle, 1)
			surface.SetDrawColor(Color(50, 50, 50, 255))
			local m = self:GetNWInt("maxunits", 0)
			for i = 1, math.min(m, 5) do
				surface.DrawRect(-5, -10 + i * 5, 5, 5)
			end

			for i = 6, math.min(m, 10) do
				surface.DrawRect(-10, -10 + (i - 5) * 5, 5, 5)
			end

			surface.SetDrawColor(color_white)
			local c = self:GetNWInt("count", 0)
			surface.DrawRect(-5, -5, 5, math.min(c, 5) * 5)
			if c > 5 then surface.DrawRect(-10, -5, 5, (c - 5) * 5) end

			surface.SetDrawColor(color_black)
			for i = 1, math.min(m, 5) do
				surface.DrawOutlinedRect(-5, -10 + i * 5, 5, 5)
			end

			for i = 6, math.min(m, 10) do
				surface.DrawOutlinedRect(-10, -10 + (i - 5) * 5, 5, 5)
			end
		cam.End3D2D()
	end

	local s = 17
	cam.Start3D2D(self:GetPos() + self:GetRight() * -68.5 - Vector(0, 0, 65), self:GetAngles() + Angle(0, 0, -90), 1)
		surface.SetDrawColor(Color(100, 100, 100, 255))
		drawSolidCircle(-3.1, 2.65, s, s)
	cam.End3D2D()

	local time = self:GetNWFloat("spawnTime", 0)
	if CurTime() < time then
		local eyeAng = LocalPlayer():EyeAngles()
		local angle = eyeAng + Angle(0, 0, 90)
		angle:RotateAroundAxis(eyeAng:Up(), -90)
		local vpos = self:WorldSpaceCenter()
		cam.Start3D2D(vpos, angle, 0.5)
		draw.SimpleText(tostring(math.ceil(time - CurTime())) .. "s", "Trebuchet24", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
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

	if energy < 1000 then
		return "Not Enough Energy\n" .. addText
	end
	if CurTime() - self:GetNWFloat("lastAttack", 0) < 15 then
		return "Cooling Down...\n" .. addText
	end

	return "Ready To Fire\n" .. addText
end