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

	self.speed = 100
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

	--[[
	for i = 0, 9 do
		self:SetNWString("class"..i, "")
		self:SetNWFloat("hp"..i, 0)
		self:SetNWInt("energy"..i, 0)
		self:SetNWInt("value"..i, 0)
		self:SetNWInt("entindex"..i, 0)
	end
	--]]
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

		if(17.5+self.launchTime - CurTime() > 0) then
			targetOffset = Vector(0,0, 17.5+self.launchTime - CurTime() )
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

		if(self.distance < self.speed*135 and not self.incomingSoundPlayed) then
			for k, v in pairs( player.GetAll() ) do
				sound.Play( "d3_citadel.timestop_buildup", v:GetPos() )
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
			self:NextThink(CurTime()+1)
			return true
		end
	end
end

function ENT:Explode()
	self.crashed = true

	for k, v in pairs( player.GetAll() ) do

		sound.Play( "d3_citadel.timestop_explosion_2", v:GetPos(), 75, 100, 1 )

		v:SetHealth( 100 )
		v:SetArmor( 100 )
		util.BlastDamage( self, self, v:GetPos(), 25, 50 ) --ghetto way of making ears ring
		--EmitSound( "d3_citadel.timestop_winddown", v:GetPos(), v:EntIndex(), 8, 1, 75, 0, 100, 0 )
		v:SetHealth( 100 )
		v:SetArmor( 100 )

		local MWhasColourModifier = true
		local MWColourModifierTable = {
			[ "$pp_colour_addr" ] = 0.0,
			[ "$pp_colour_addg" ] = 0.0,
			[ "$pp_colour_addb" ] = 0.0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 1,
			[ "$pp_colour_colour" ] = 1,
			[ "$pp_colour_mulr" ] = 0.5,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}

		for i=1, 100 do
			timer.Simple( i/20, function()
				MWColourModifierTable = {
					[ "$pp_colour_addr" ] = 0.0,
					[ "$pp_colour_addg" ] = 0.0,
					[ "$pp_colour_addb" ] = 0.0,
					[ "$pp_colour_brightness" ] = 0,
					[ "$pp_colour_contrast" ] = 1,
					[ "$pp_colour_colour" ] = 1,
					[ "$pp_colour_mulr" ] = 10-i/10,
					[ "$pp_colour_mulg" ] = 10-i/10,
					[ "$pp_colour_mulb" ] = 10-i/10
				}
				net.Start("MWColourMod")
					net.WriteBool(true) --hasColourModifier
					net.WriteTable(MWColourModifierTable)
				net.Send(v)
			end)
		end

		timer.Simple( 5, function()
			net.Start("MWColourMod")
				net.WriteBool(false) --hasColourModifier
			net.Send(v)
		end)
	end

	timer.Simple( 0.1, function()
		if (self:IsValid()) then
			util.BlastDamage( self, self, self:GetPos(), 650, 250)

			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(0,0,150))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(0,150,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(150,0,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(0,-150,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(-150,0,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(110,110,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(-110,110,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(110,-110,0))
			util.Effect( "Explosion", effectdata )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(-110,-110,0))
			util.Effect( "Explosion", effectdata )

			local target = self:GetNWEntity("target", nil)
			for k, v in pairs( player.GetAll() ) do
				sound.Play( "k_lab2.Barney_Explosion", v:GetPos(), 75, 100, 1 )
			end
			self:Remove()
			end
		end	)
end
