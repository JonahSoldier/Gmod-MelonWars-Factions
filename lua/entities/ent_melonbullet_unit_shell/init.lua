AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props_combine/headcrabcannister01a.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit( SOLID_VPHYSICS )

	self.deathSound = "ambient/explosions/explode_9.wav"

	self:SetNWInt("count", 0)

	self.startPos = self:GetPos()
	self.startTime = CurTime()

	util.SpriteTrail(self, 0, color_white, false, 10, 1, 2, 1 / ( 15 + 1 ) * 0.5, "effects/beam_generic01.vmt")

	self.incomingSoundPlayed = false
	self.crashed = false

	self.mwBulletIndestructible = true
end

function ENT:Think()
	local selfTbl = self:GetTable()
	if selfTbl.crashed then
		local count = self:GetNWInt("count", 0)
		if count > 0 then
			self:FreeUnit(count)
			sound.Play( "doors/door_metal_medium_open1.wav", self:GetPos() )
			self:NextThink(CurTime() + 0.5)
			return true
		end

		self:NextThink(CurTime() + 5)
		return true
	end

	--From start to targetpos with no drag
	local t = (CurTime() - selfTbl.startTime) / 15 --15 second travel time

	self:SetPos( self:getTrajectoryPosition(t, 50000) )
	local nextPos = self:getTrajectoryPosition(t + 0.01, 50000)
	self:SetAngles( (nextPos - self:GetPos()):Angle() )

	if not selfTbl.incomingSoundPlayed and t > 13.5 / 15 then
		MelonWars.playGlobalSound("HeadcrabCanister.IncomingSound", self:GetPos(), 140)

		selfTbl.incomingSoundPlayed = true
	end

	if t >= 1 and self:IsValid() then
		self:GetPhysicsObject():EnableMotion(false)
		self:SetPos(self:GetNWVector("targetPos", nil))
		self:Explode()
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:getTrajectoryPosition(t, height)
	local targetPos = self:GetNWVector("targetPos", nil)

	--horizontal
	local pos = self.startPos * (1-t)
	pos:Add(targetPos * t)

	--vertical
	local vertical = vector_up * ( (t - t^2) * height )
	pos:Add(vertical)

	return pos
end

function ENT:FreeUnit(i)
	local cEnt = self.containedEnts[i]
	if cEnt then
		local pos = self:GetPos() + Vector(0,0,50) + self:GetForward() * (i % 3 - 1) * 15 + self:GetRight() * ( 40 + i * 5)

		local selfTeam = self:GetNWInt("mw_melonTeam", -1)
		local newUnit = MelonWars.spawnUnitAtPos( cEnt.class, pos, angle_zero, cEnt.value, 0, selfTeam, false, nil, cEnt.owner, 0 )

		if cEnt.energy > 0 then
			newUnit:SetNWInt("mw_charge", cEnt.Energy)
		end

		undo.Create("Melon Marine")
			undo.AddEntity( newUnit )
			undo.SetPlayer( pl)
		undo.Finish()
		MelonWars.updatePopulation(-newUnit.population, selfTeam)
	end
	self:SetNWInt("count", self:GetNWInt("count", 0) - 1 )
end

function ENT:OnRemove() --This should never happen, but if players (or the map?) delete this entity this stops the power from getting messed up.
	MelonWars.updatePopulation(self:GetNWInt("count", 0), self:GetNWInt("mw_melonTeam", -1))
end

function ENT:Explode()
	self.crashed = true

	MelonWars.playGlobalSound("HeadcrabCanister.Explosion", self:GetPos(), 140)

	timer.Simple( 25, function()
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata )

		self:Remove()
	end)
end