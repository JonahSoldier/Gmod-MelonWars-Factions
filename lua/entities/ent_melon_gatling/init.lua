AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_phx/wheels/magnetic_large_base.mdl" --Physical model, doesn't get shown in this case
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 100
	self.spread = 10
	self.damageDeal = 2
	self.maxHP = 45
	self.range = 250


	--showing the actual model part
	self.visualmodel = ents.Create( "prop_physics" )
	if not IsValid( self.visualmodel ) then return end

	self.visualmodel:SetModel("models/Mechanics/gears/gear12x24.mdl")
	self.visualmodel:SetMaterial(self.materialString)
	self.visualmodel:SetParent(self)

	self.visualmodel:SetLocalAngles(Angle(0,0,0))
	self.visualmodel:SetLocalPos(Vector(0,0,0))
	self.visualmodel:SetColor( self.color )

	self.visualmodel:Spawn()

	self.visualmodel:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	--self:SetNoDraw( 1 ) -- Makes the actual *real* model invisible, so it just shows the gear thingy

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

	self:Setup()

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self.visualmodel:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )

	if self:GetNWInt("mw_charge", 0)==0 then
		self.slowThinkTimer = 1
	else
		--self.shotDelay = math.sqrt(((self:GetNWInt("mw_charge", 0)*-1)+200)/35)
		self.slowThinkTimer = math.sqrt(((self:GetNWInt("mw_charge", 0)*-1)+200)/35)
	end

	if(self.nextRecharge < CurTime()) then --This is slightly dumb but I can't be bothered to re-organize the code around here. It's set to 2.5 because that's higher than the max slowthinktimer given by the other equation. - Jonah
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

	local inclination = self:Align(self:GetAngles():Up(), Vector(0,0,1), 10000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination*100))

	self:DefaultPhysicsUpdate()
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end