AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props_combine/headcrabcannister01a.mdl")
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self.deathSound = "ambient/explosions/explode_9.wav"

	self.careForFriendlyFire = false

	self.speed = 75
	self.damageDeal = 100
	self.maxHP = 20
	self.random = Vector(math.random()/2-1/4, math.random()/2-1/4, math.random()/6+0.1)
	self:SetNWInt("maxunits", 10)
	self:SetNWInt("count", 0)

	self.idsInside = {}


	self.targetPos = Vector(0,0,0)
	self.distance = 0

	self:SetColor(Color(100,100,100, 255))
	local trail = util.SpriteTrail(self, 0, Color(255,255,255), false, 10, 1, 2, 1/(15+1)*0.5, "effects/beam_generic01.vmt")

	for i=0, 9 do
		self:SetNWString("class"..i, "")
		self:SetNWFloat("hp"..i, 0)
		self:SetNWInt("energy"..i, 0)
		self:SetNWInt("value"..i, 0)
		self:SetNWInt("entindex"..i, 0)
	end

	self.launchTime = CurTime()
	self.incomingSoundPlayed = true
	self.crashed = false

	timer.Simple( 5, function()
		self.incomingSoundPlayed = false
	end)

	self.mwBulletIndestructible = true
end

function ENT:Think()

	if(self.crashed ~= true) then
		local targetOffset = Vector( 0, 0, 0)

		if(7.5+self.launchTime - CurTime() > 0) then
			targetOffset = Vector(0,0, 7.5+self.launchTime - CurTime() )
		else
			targetOffset = Vector(0,0,0)
		end

		local foundEnts = ents.FindInSphere(self:GetPos(), 2 )
		for k, v in pairs( foundEnts ) do
			if (v.Base == "ent_melon_prop_base") then --si es una sandía
				if (v:GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0)) then-- si tienen distinto equipo
					self:Explode()
					return true
				end
			end
		end

		local target = self:GetNWEntity("target", nil)
		if (self.targetPos == Vector(0,0,0) and target ~= nil and IsValid(target)) then
			self.targetPos = target:GetPos()
		end
		self.targetPos = self:GetNWVector("targetPos", nil)

		self.distance = self:GetPos():Distance(self.targetPos)
		if (self.targetPos == Vector(0,0,0)) then self:Remove() end
		local targetVec = self.targetPos+self.random+targetOffset*self.distance
		self:SetPos(self:GetPos()+(targetVec-self:GetPos()):GetNormalized()*self.speed )
		self:SetAngles( (targetVec-self:GetPos()):Angle() )
		self:NextThink(CurTime()+0.05)

		if(self.distance < self.speed*35 and not self.incomingSoundPlayed) then
			for k, v in pairs( player.GetAll() ) do
				sound.Play( "HeadcrabCanister.IncomingSound", v:GetPos() )
			end

			self.incomingSoundPlayed = true
		end

		if (self.distance < self.speed*3.0) then
			if (self:IsValid()) then

				self:GetPhysicsObject():EnableMotion(false)
				self:SetPos(self.targetPos)
				self:Explode()
			end
		end

		self.counter = self:GetNWInt("count", 0)
		return true
	else
		if (self:GetNWInt("count", 0)>0) then

			self.counter = self.counter-1
			self:FreeUnits(self.counter)
			sound.Play( "doors/door_metal_medium_open1.wav", self:GetPos() )
			self:NextThink(CurTime()+0.5)
			return true
		end
	end
end


function ENT:FreeUnits(i)
	if (self:GetNWInt("count", 0) > 0) then
		local count = i
		if (self:GetNWString("class"..i, "") ~= "") then
			--count = count+1

			local class = self:GetNWString("class"..i, "")
			local pos = self:GetPos()+Vector(0,0,50)+self:GetForward()*(count%3-1)*15+self:GetRight()*(40+count*5)

			--+Vector(math.random(-10,10),math.random(-10,10),count*10)

			local value = self:GetNWInt("value"..i, 0)
			local hp = self:GetNWInt("hp"..i, 0)
			local energy = self:GetNWInt("energy"..i, 0)
			local entIndex = self:GetNWInt("entindex"..i, 0)
			local _team = self:GetNWInt("mw_melonTeam", -1)

			local newMarine = ents.Create( class )
			if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail

			newMarine:SetPos(pos)

			mw_melonTeam = _team

			newMarine:Spawn()

			newMarine:Ini(_team, false)
			newMarine.fired = true

			local pl = self:GetOwner()

			pl.mw_melonTeam = _team

			newMarine:SetOwner(pl)

			newMarine.value = value
			newMarine:SetNWFloat("Health", hp)

			if (energy > 0) then
				newMarine:SetNWInt("mw_charge", energy)
			end

			undo.Create("Melon Marine")
			undo.AddEntity( newMarine )
			undo.SetPlayer( pl)
			undo.Finish()

			table.RemoveByValue(self.idsInside, entIndex)

			self:SetNWString("class"..i, "")
			self:SetNWInt("value"..i, 0)
			self:SetNWInt("hp"..i, 0)
			self:SetNWInt("energy"..i, 0)
			self:SetNWInt("entindex"..i, 0)
		end
		self:SetNWInt("count", self:GetNWInt("count", 0)-1)
	end
end

function ENT:Explode()
	self.crashed = true

	for k, v in pairs( player.GetAll() ) do
		sound.Play( "HeadcrabCanister.Explosion", v:GetPos(), 75, 100, 1 )
	end

	timer.Simple( 25, function()
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata )
		--local target = self:GetNWEntity("target", nil)
		/*if (target ~= nil and IsValid(target)) then
			target.damage = 100
		end*/

		self:Remove()
	end)
end