AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.birth = CurTime()

	self.modelString = "models/maxofs2d/hover_propeller.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.population = 0

	self:SetNWBool("done",false)

	self.delayedForce = 0

	self.damping = 1

	self.captureSpeed = 0

	self.maxHP = 25
	self.shotOffset = Vector(0,0,15)

	self:Setup()
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2, self:GetColor().g/2, self:GetColor().b/2, 255))
end

function ENT:SlowThink( ent )
end

function ENT:Shoot( ent )
end

function ENT:Update(ent)
end

function ENT:Think()
	local const = constraint.FindConstraints( self, "Weld" )
	if table.Count(const) == 0 then
		self:TakeDamage(5)
	end
end

function ENT:Actuate()
	for i, v in ipairs(ents.FindInSphere(self:GetPos(), 600 )) do
		if v:GetClass() == "ent_melon_propeller" then
			v:SetNWBool("done", true)
		end
	end
end

function ENT:DeathEffect( ent )
	MelonWars.defaultDeathEffect( ent )
end

function ENT:PhysicsUpdate() --TODO: Jetpack-esque slowfall
	if not self:GetNWBool("done",false) then return end

	local hoverdistance = 200
	local hoverforce = 80
	local force = 0

	local selfTbl = self:GetTable()
	local phys = self:GetPhysicsObject()
	local selfPos = self:GetPos()
	local tr = util.TraceLine( {
		start = selfPos,
		endpos = selfPos + Vector(0,0,-hoverdistance * 2),
		filter = function( ent )
			local ph = ent:GetPhysicsObject()
			return IsValid(ph) and not ph:IsMoveable()
		end,
		mask = MASK_WATER + MASK_SOLID
	} )

	local distance = (hoverdistance * 2) * tr.Fraction

	if (distance < hoverdistance) then
		force = -(distance-hoverdistance) * hoverforce
		local vel = phys:GetVelocity()
		vel.x, vel.y, vel.z = 0, 0, -vel.z * 8 --TODO: Make this relative to contraption mass(?)
		phys:ApplyForceCenter(vel)
	else
		force = 0
	end

	if (force > selfTbl.delayedForce) then
		selfTbl.delayedForce = (selfTbl.delayedForce * 2 + force) / 3
	else
		selfTbl.delayedForce = selfTbl.delayedForce * 0.5
	end

	local brakingForce = phys:GetVelocity() --Stop us from drifting forever
	brakingForce.x = math.Clamp(brakingForce.x * -1, -2.5, 2.5)
	brakingForce.y = math.Clamp(brakingForce.y * -1, -2.5, 2.5)
	brakingForce.z = selfTbl.delayedForce

	phys:ApplyForceCenter(brakingForce)

	self:DefaultPhysicsUpdate()

	self:Align(self:GetAngles():Up(), vector_up, 10000)
	self:StopAngularVelocity(0.3)
end