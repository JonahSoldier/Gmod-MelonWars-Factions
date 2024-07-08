AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

MelonWars.teamColors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(50,0,40,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}

function ENT:Initialize()
	if IsValid(self.zone) then self.zone:Remove() end

	self:SetModel( "models/props_docks/dock03_pole01a_256.mdl" )

	self:SetAngles(angle_zero)
	self:SetPos(self:GetPos() + Vector(0,0,75))

	self:SetMaterial("models/shiny")

	self.captured = {0,0,0,0,0,0,0,0}
	self:SetNWInt("captured", 0)
	self:SetNWInt("capTeam", 0)

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:GetPhysicsObject():EnableMotion(false)

	self.zone = ents.Create( "ent_melon_zone" )
		self.zone:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

		self.zone:Spawn()
		self.zone:SetPos(self:GetPos() + Vector(0,0,-100))
		self.zone:SetMoveType( MOVETYPE_NONE )

		self.zone:SetZoneTeam(0)

		self.zone:SetZoneRadius(600)

		self:DeleteOnRemove( self.zone )
end

function ENT:OnDuplicated( entTable )
	self:SetPos(self:GetPos() - Vector(0,0,75))
end

function ENT:Think()
	if not cvars.Bool("mw_admin_playing") then
		self:NextThink(CurTime() + 2)
		return true
	end

	local selfTbl = self:GetTable()

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
		local capture = math.Round(math.sqrt(capturing[i])) * 4
		--Si hay gente capturando
		if capturing[i] > 0 then
			local othersHaveCapture = false
			for ii = 1,8 do
				local otherCapture = selfTbl.captured[ii]
				if ii ~= i and otherCapture > 0 then
					if MelonWars.sameTeam(i, ii) then --Assist our allies instead of obstructing them
						if capture <= otherCapture then
							selfTbl.captured[ii] = math.min(100, otherCapture + capture)
							capture = 0
							selfTbl.captured[i] = 0
						end
					else
						selfTbl.captured[ii] = math.max(0,otherCapture-capture)
					end
					othersHaveCapture = true
				end
			end
			--Si nadie estaba capturando, capturar
			if not othersHaveCapture then
				selfTbl.captured[i] = math.min(100, selfTbl.captured[i] + capture)
			end
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
				break
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
	if capturingTeam > 0 then newColor = MelonWars.teamColors[capturingTeam] end

	ent.zone:SetZoneTeam(capturingTeam)
	ent:SetColor(newColor)
end

