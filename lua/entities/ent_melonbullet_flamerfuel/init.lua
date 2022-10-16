AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/props_junk/GlassBottle01a.mdl")
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMaterial("Models/effects/vol_light001")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	
	self.careForFriendlyFire = false


	self.sphereRadius = 1
	self.speed = 12
	self.damageDeal = 2
	self.maxHP = 20
	self.random = Vector(math.random()/2-1/4, math.random()/2-1/4, math.random()/6+0.1)
	
	self.targetPos = Vector(0,0,0)
	self.distance = 0
	
	self:SetColor(Color(100,100,100, 0))
	timer.Simple(0.05, function() self:Ignite(10, 25) end)

	timer.Simple(0.05, function()
		local target = self:GetNWEntity("target", nil)
		if (target ~= nil and IsValid(target)) then
			self.targetPos = target:GetPos()
		end
	end)
end

function ENT:PhysicsCollide( colData, collider )
	self:Explode()
end

function ENT:Think()

	local foundEnts = ents.FindInSphere(self:GetPos(), 2 )
	for k, v in pairs( foundEnts ) do
		if (v.Base == "ent_melon_prop_base") then --si es una sandía
			if (v:GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0)) then-- si tienen distinto equipo
				self:Explode()
				return true
			end
		end
	end


	self.distance = self:GetPos():Distance(self.targetPos)
	if (self.targetPos == Vector(0,0,0)) then self:Remove() end
	local targetVec = self.targetPos+self.random*self.distance
	self:SetPos(self:GetPos()+(targetVec-self:GetPos()):GetNormalized()*self.speed)
	self:SetAngles( (targetVec-self:GetPos()):Angle() )
	self:NextThink(CurTime()+0.05)
	if (self.distance < self.speed*1.5) then
		if (self:IsValid()) then
			self:Explode()
		end
	end
	
	return true
end

function ENT:Explode()


	local entities = ents.FindInSphere( self:GetPos(), 1000 )
	local foundPuddle = false
	local puddle = nil

	for k, v in pairs(entities) do
		if (v:GetClass() == "ent_melon_firepuddle")  then
			if (self:GetPos():DistToSqr( v:GetPos() ) < (v.sizeMultiplier * v.sizeMultiplier * 46.95 * 46.95)) then
				foundPuddle = true
				puddle = v
			end
		end
	end

	if (foundPuddle == false) then
		local fire = ents.Create("ent_melon_firepuddle")
		fire:SetPos(self:GetPos()+Vector(0, 0, -4))
		fire:Spawn()
	else
		puddle.sizeMultiplier = puddle.sizeMultiplier + 0.1
	end


	self:Remove()
end