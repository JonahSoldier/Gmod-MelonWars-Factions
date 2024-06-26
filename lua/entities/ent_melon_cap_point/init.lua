AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

MelonWars.teamColors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(50,0,40,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/buoy01.mdl" )

	self:SetMaterial("models/shiny")

	self.captured = {0,0,0,0,0,0,0,0}
	self:SetNWInt("captured", 0)

	self.capTeam = 0

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMoveType( MOVETYPE_NONE )
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:Think()
	if not cvars.Bool("mw_admin_playing") then
		self:NextThink(CurTime() + 2)
		return true
	end

	local selfTbl = self:GetTable()

	if selfTbl.capTeam ~= 0 then
		MelonWars.teamCredits[selfTbl.capTeam] = MelonWars.teamCredits[selfTbl.capTeam] + 5
		for i, v in pairs( player.GetAll() ) do
			if v:GetInfoNum("mw_team", -1) == selfTbl.capTeam then
				net.Start("MW_TeamCredits")
					net.WriteInt(MelonWars.teamCredits[selfTbl.capTeam] ,32)
				net.Send(v)
			end
		end
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector(0,0,100))
		effectdata:SetScale(10)
		util.Effect( "watersplash", effectdata )
	end

	local capturing = {0,0,0,0,0,0,0,0}

	local captured = self:GetNWInt("captured", 0)
	for i, v in ipairs( ents.FindInSphere(self:GetPos(), 200) ) do
		local vTbl = v:GetTable()
		if vTbl.Base == "ent_melon_base" then
			local vTeam = v:GetNWInt("mw_melonTeam", -1)
			if vTeam > 0 then
				capturing[vTeam] = capturing[vTeam] + vTbl.captureSpeed

				if captured < 100 then
					local pos = v:GetPos() + Vector(0,0,20)
					local effectdata = EffectData()
					effectdata:SetScale(0)
					effectdata:SetStart(pos)
					effectdata:SetOrigin(pos)
					util.Effect( "MuzzleEffect", effectdata )
				end
			end
		end
	end

	for i = 1,8 do
		local capture = math.Round(math.sqrt(capturing[i]))*4
		--Si hay gente capturando
		if (capturing[i] > 0) then
			local othersHaveCapture = false
			for ii = 1,8 do
				if ii ~= i and selfTbl.captured[ii] > 0 then
					selfTbl.captured[ii] = math.max(0,selfTbl.captured[ii]-capture)
					othersHaveCapture = true
				end
			end
			--Si nadie estaba capturando, capturar
			if not othersHaveCapture then
				selfTbl.captured[i] = math.min(100, selfTbl.captured[i]+capture)
			end
		else
		--Si no, bajarle
			selfTbl.captured[i] = math.max(0, selfTbl.captured[i]-20)
		end
	end

	local totalCapture = 0
	for i = 1,8 do
		totalCapture = totalCapture + selfTbl.captured[i]
	end

	if totalCapture > 0 then
		for i = 1,8 do
			if selfTbl.captured[i] == totalCapture then
				self:SetNWInt("capTeam", i)
				if totalCapture == 100 then
					self:GetCaptured(i, self)
				end
			end
		end
	else
		self:GetCaptured(0, self)
	end

	self:SetNWInt("captured", totalCapture)

	self:NextThink(CurTime() + 2)
	return true
end

function ENT:GetCaptured(capturingTeam, ent)
	local newColor = color_white
	if (capturingTeam > 0) then newColor = MelonWars.teamColors[capturingTeam] end
	ent.capTeam = capturingTeam
	ent:SetNWInt("capTeam", capturingTeam)

	ent:SetColor(newColor)
end