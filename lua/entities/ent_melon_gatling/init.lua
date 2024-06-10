AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/Mechanics/gears/gear12x24.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 100
	self.spread = 10
	self.damageDeal = 2
	self.maxHP = 45
	self.range = 250

	self.weight = 25
	self.shotOffset = Vector(0,0,5)

	self.population = 2
	self.buildingDamageMultiplier = 0.8

	self.shotSound = "weapons/smg1/smg1_fire1.wav"
	self.tracer = "AR2Tracer"

	self.slowThinkTimer = 1

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 200)
	self.energyCost = 5

	self.nextRecharge = CurTime()

	self.useBBoxPhys = true
	self:Setup()

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent ) --TODO: Look at this

	if self:GetNWInt("mw_charge", 0)==0 then
		self.slowThinkTimer = 1
	else
		self.slowThinkTimer = math.sqrt(((self:GetNWInt("mw_charge", 0)*-1)+200)/35)
	end

	if(self.nextRecharge < CurTime()) then
		if( self:GetNWInt("mw_charge", 0) + 5 < 200) then
			self:SetNWInt("mw_charge", self:GetNWInt("mw_charge", 0)+5)
		else
			self:SetNWInt("mw_charge", 200)
		end

		self.nextRecharge = self.nextRecharge + 5
	end


	MelonWars.unitDefaultThink ( ent )
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		ent.nextControlShoot = CurTime()+ent.slowThinkTimer
		if (IsValid(ent)) then
			if ent:GetNWInt("mw_charge",0)>self.energyCost then
				MelonWars.defaultShoot ( ent, forceTargetPos )
				ent:SetNWInt("mw_charge",ent:GetNWInt("mw_charge",0)-self.energyCost)
			end
		end
	end
end

function ENT:PhysicsUpdate()
	self:AlignUpright( 10000, 100 )

	self:DefaultPhysicsUpdate()
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end