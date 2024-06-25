AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

MelonWars.teamColors = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(50,0,40,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}

function ENT:Initialize()
	self.slowThinkTimer = 2
	self.mw_melonTeam = 0
	self.nextSlowThink = 0
	self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
	self:SetMaterial( "models/shiny" )
	self.captured = {0,0,0,0,0,0,0,0}

	for i = 1, 8 do
		self:SetNWInt("captured" .. tostring(i), 0)
	end
	self.capTeam = 0

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMoveType( MOVETYPE_NONE )
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:Think()
	local selfTbl = self:GetTable()
	if CurTime() <= selfTbl.nextSlowThink then return end
	selfTbl.nextSlowThink = CurTime() + selfTbl.slowThinkTimer
	if not cvars.Bool( "mw_admin_playing" ) then return end

	self:SlowThink( self )
end

function ENT:SlowThink()
	local selfTbl = self:GetTable()
	local capturing = {0,0,0,0,0,0,0,0}

	local foundEnts = ents.FindInSphere( self:GetPos(), 200 )
	for _, v in ipairs( foundEnts ) do
		local vTbl = v:GetTable()
		if vTbl.Base == "ent_melon_base" then
			local vTeam = v:GetNWInt("mw_melonTeam", 0)
			if vTeam > 0 then
				capturing[vTeam] = capturing[vTeam] + vTbl.captureSpeed

				local pos =  v:GetPos() + Vector(0,0,20)
				local effectdata = EffectData()
				effectdata:SetScale(0)
				effectdata:SetStart(pos)
				effectdata:SetOrigin(pos)
				util.Effect( "MuzzleEffect", effectdata )
			end
		end
	end

	for i = 1, 8 do
		local capture = math.Round(math.sqrt(capturing[i])) * 4
		--Si hay gente capturando
		if capturing[i] > 0 then
			local othersHaveCapture = false
			for ii = 1, 8 do
				if ii ~= i and selfTbl.captured[ii] > 0 then --Si alguien más estaba capturando
					--Bajar su captura
					selfTbl.captured[ii] = selfTbl.captured[ii] - capture
					othersHaveCapture = true
				end
			end
			--Si nadie estaba capturando, capturar
			if not othersHaveCapture then
				selfTbl.captured[i] = math.min(100, selfTbl.captured[i] + capture)
			end
		else
		--Si no, bajarle
			selfTbl.captured[i] = math.max(0, selfTbl.captured[i]-20)
		end
	end

	local totalCapture = 0

	for i = 1, 8 do
		totalCapture = totalCapture + selfTbl.captured[i]
	end

	if totalCapture == 100 then
		for i = 1, 8 do
			if (selfTbl.captured[i] == totalCapture) then
				self:GetCaptured(i, self)
			end
		end
	end

	if totalCapture == 0 then
		self:GetCaptured(0, self)
	end

	if selfTbl.captured[selfTbl.capTeam] == 0 then
		self:GetCaptured(0, self)
	end

	for i = 1, 8 do
		self:SetNWInt("captured" .. tostring(i), selfTbl.captured[i])
	end
end

function ENT:GetCaptured(capturingTeam, ent)
	local newColor = color_white
	if capturingTeam > 0 then newColor = MelonWars.teamColors[capturingTeam] end

	ent.capTeam = capturingTeam
	ent:SetNWInt("capTeam", capturingTeam)

	ent:SetColor(newColor)
end