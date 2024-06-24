AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/XQM/airplanewheel1.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = false
	self.canShoot = false
	self.speed = 600
	self.thrustforce = 0.003

	self.population = 0

	self.materialString = ""

	self.captureSpeed = 0

	self.maxHP = 80

	self.damping = 0.05
	self.angularDamping = 10000

	self:Setup()

	self:GetPhysicsObject():SetMass(30)

	self.moving = false

	self.isContraptionPart = true
end

function ENT:SlowThink ( ent )
end

function ENT:Welded( ent, parent )
	ent.phys:SetMaterial("rubber")

	local LPos1 = vector_origin
	local LVector = Vector(1,0,0)
	constraint.Axis(self, parent, 0, 0, LPos1, LPos1, 0, 0, 0, 1, LVector, false)

	self.parent = parent
end

function ENT:PostEntityPaste( ply, ent, dupeEnts )
	timer.Simple(0, function()
		local axis = constraint.FindConstraint( self, "Axis" )
		if not axis then return end
		self.parent = (axis.Ent1 ~= self and axis.Ent1) or axis.Ent2
	end)
end

function ENT:OnFinishMovement(parent)
	local selfTbl = self:GetTable()
	if not selfTbl.weld then
		selfTbl.phys:SetMaterial("rubber")
		selfTbl.weld = constraint.Weld( self, selfTbl.parent, 0, 0, 0, true , false )
	end
end

function ENT:Shoot ( ent )
end

function ENT:PhysicsUpdate() --TODO: Wheel behaviour is generally kinda fucked even with welds working correctly.
	--[[
	local phys = self:GetTable().phys
	local vel = phys:GetVelocity()
	local forward = self:GetAngles():Forward()
	local dot = vel:GetNormalized():Dot(forward)
	phys:ApplyForceCenter(-forward * dot * phys:GetMass() * vel:Length() * 0.1)
	--]]
end

function ENT:Update (ent)
	local selfTbl = self:GetTable()
	if selfTbl.moving and selfTbl.weld ~= nil then
		constraint.RemoveConstraints( self, "Weld" )
		selfTbl.weld = nil
		selfTbl.phys:SetMaterial("slime")
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end