AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.slowThinkTimer = 1
	self.modelString = "models/props_combine/CombineThumper002.mdl"
	self.shotOffset = Vector(0,-40,200)
	self.materialString = "models/shiny"
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"

	self.canMove = false

	self.maxHP = 1000
	self.dead = false
	self.range = 500
	self.damageDeal = 7

	self.population = 0

	self.moveType = MOVETYPE_NONE

	self:Setup()

	self.zone = ents.Create( "ent_melon_zone" )
		self.zone:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

		self.zone:Spawn()
		self.zone:SetPos(self:GetPos() + Vector(0,0,-12))
		self.zone:SetMoveType( MOVETYPE_NONE )

		self.zone:SetZoneTeam(mw_melonTeam)
		self.zone:SetZoneRadius(800)
		self.zone:SetNWInt("scale", 800)

		self.zone:SetNoDraw(true)
		self:DeleteOnRemove( self.zone )
end

local mw_admin_base_income_cv = GetConVar("mw_admin_base_income")
function ENT:SlowThink(ent)
	local selfTeam = self:GetNWInt("mw_melonTeam", 0)
	if selfTeam ~= 0 then
		MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam] + mw_admin_base_income_cv:GetInt()
		MelonWars.updateClientCredits(selfTeam)
	end
	MelonWars.unitDefaultThink ( ent )
end

function ENT:Shoot ( ent )
	if not IsValid(ent.targetEntity) then return end
	local pos = ent:GetPos() + ent.shotOffset

	ent.targetEntity:TakeDamage(self.damageDeal)
	local effectdata = EffectData()
	effectdata:SetScale(1)
	effectdata:SetMagnitude(1)
	effectdata:SetStart( pos )
	effectdata:SetOrigin( ent.targetEntity:GetPos() )
	effectdata:SetEntity( ent )
	util.Effect( "ToolTracer", effectdata )
	sound.Play( ent.shotSound, pos )
end

function ENT:_OnTakeDamage( damage )
	self:CreateAlert (self:GetPos() + Vector(0,0,150), self:GetNWInt("mw_melonTeam", 0))
	self:SetNWFloat("lastHit", CurTime())
end

function ENT:CreateAlert (pos, _team)
	self:PlayHudSound("ambient/alarms/doomsday_lift_alarm.wav", 0.2, 90, _team)
	local alert = ents.Create( "ent_melon_HUD_alert" )
	alert:SetPos(pos + Vector(0,0,100))
	alert:Spawn()
	alert:SetNWInt("drawTeam", _team)
end

function ENT:DeathEffect ( ent )
	if ent.dead then return end

	sound.Play( "ambient/explosions/explode_2.wav", ent:GetPos() )
	sound.Play( "ambient/explosions/citadel_end_explosion2.wav", ent:GetPos() )
	
	for i = 1, 10 do
		timer.Simple(i / 4, function()
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() + Vector(math.random(-100,100), math.random(-100,100), math.random(0,200)) )
			effectdata:SetScale( 100 )
			util.Effect( "Explosion", effectdata )
		end)
	end
	timer.Simple(11 / 4, function()
		for i = 1, 10 do
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() + Vector(0,0,20 * i) )
			effectdata:SetScale( 100 )
			util.Effect( "Explosion", effectdata )
		end

		for i, model in ipairs(MelonWars.debrisProps) do
			local debris = ents.Create( "prop_physics" )
			debris:SetModel(model)
			debris:Ignite( 60 )
			debris:SetPos( ent:GetPos() + VectorRand(-100, 100) )
			debris:Spawn()
			local debrisPhys = debris:GetPhysicsObject()
			debrisPhys:ApplyForceCenter(Vector(math.random(-10000,10000), math.random(-10000,10000), math.random(10000,70000)))
		end

		ent:Remove()
	end)

	ent.dead = true
end