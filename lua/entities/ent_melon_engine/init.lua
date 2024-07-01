AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.

include("shared.lua")

function ENT:Initialize()
	MelonWars.defaults(self)
	self.modelString = "models/thrusters/jetpack.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 150
	self.thrustforce = 0.4
	self.maxHP = 25
	self.captureSpeed = 0
	self.population = 0
	self.damping = 0.01
	self.angularDamping = 1000

	self:Setup()

	self:GetPhysicsObject():SetMass(50)
	self.moving = true
	self.isContraptionPart = true
end

function ENT:SlowThink(ent)
end

function ENT:Welded(ent, parent)
	constraint.Weld(ent, parent, 0, 0, 0, true, false)
	ent.materialString = "models/shiny"
	ent.parent = parent
end

local mw_admin_playing_cv = GetConVar( "mw_admin_playing" )
function ENT:Update()
	if not mw_admin_playing_cv:GetBool() then return end
	local selfTbl = self:GetTable()

	local const = constraint.FindConstraints( self, "Weld" )
	if table.Count(const) == 0 then
		self:TakeDamage(5)
	end

	self:SetNWVector("targetPos", selfTbl.targetPos)
	self:SetNWEntity("followEntity", selfTbl.followEntity)

	local phys = selfTbl.phys
	if IsValid(phys) then
		if selfTbl.moving then
			local moveVector = (selfTbl.targetPos - self:GetPos()):GetNormalized() * selfTbl.speed - self:GetVelocity()
			moveVector.z = 0
			selfTbl.moveForce = moveVector * selfTbl.thrustforce
		else
			local moveVector = -self:GetVelocity() * 0.2
			moveVector.z = 0
			selfTbl.moveForce = moveVector
		end
	end

	if selfTbl.moving and self:GetPos():Distance2DSqr(selfTbl.targetPos) < 100^2 then
		for k, v in pairs(constraint.GetAllConstrainedEntities(self)) do
			if v:GetTable().Base == "ent_melon_base" then
				v:FinishMovement()
			end
		end
	end

	self:SetNWBool("moving", selfTbl.moving)
end

function ENT:PhysicsUpdate()
	local selfAng = self:GetAngles()
	local selfTbl = self:GetTable()

	if selfTbl.moving then
		local moveVector = (selfTbl.targetPos - self:GetPos()):GetNormalized()
		self:Align(selfAng:Up(), -moveVector, 75000)
	end

	local damp = 0.8
	self:StopAngularVelocity(damp)
	self:DefaultPhysicsUpdate()
end

function ENT:Shoot(ent)
end

function ENT:DeathEffect(ent)
	MelonWars.defaultDeathEffect(ent)
end