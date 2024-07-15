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
	self.shotOffset = Vector(0,0,25)

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

function ENT:SlowThink ( ent )
	local selfTbl = self:GetTable()
	local charge = self:GetNWInt("mw_charge", 0)
	if self:GetNWInt("mw_charge", 0) == 0 then
		selfTbl.slowThinkTimer = 1
	else
		selfTbl.slowThinkTimer = math.sqrt( (-1 * charge + 200 ) / 35 )
	end

	if selfTbl.nextRecharge < CurTime() then
		local maxCharge = self:GetNWInt("maxCharge", 0)

		self:SetNWInt("mw_charge", math.min(charge + 5, maxCharge))

		selfTbl.nextRecharge = selfTbl.nextRecharge + 5
	end

	MelonWars.unitDefaultThink ( ent )
end

function ENT:Shoot ( ent, forcedTargetPos )
	if not IsValid(self) then return end
	local selfTbl = self:GetTable()
	if not(selfTbl.ai or CurTime() > selfTbl.nextControlShoot) then return end

	selfTbl.nextControlShoot = CurTime() + selfTbl.slowThinkTimer
	local charge = ent:GetNWInt("mw_charge",0)
	if charge > selfTbl.energyCost then
		MelonWars.defaultShoot ( ent, forceTargetPos )
		ent:SetNWInt("mw_charge",charge - selfTbl.energyCost)
	end
end

function ENT:PhysicsUpdate()
	if not self:GetTable().canMove then return end
	self:AlignUpright( 20000, 100 )

	self:DefaultPhysicsUpdate()
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end