AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:SetStats()
	self.speed = 300
	self.range = 400

	self.modelString = "models/props_phx/construct/metal_plate1_tri.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.population = 2
	self.damageDeal = 6
	self.maxHP = 20

	self.height = self:GetPos().z
	self.delayedForce = 0
	self.moveForceMultiplier = 0.05

	self.sphereRadius = 15

	self.startRecharging = CurTime()

	self.captureSpeed = 2
	self.exhaustedUntil = CurTime()

	self.slowThinkTimer = 1

	self.loiterRotation = 0
	self.loiterPos = self:GetPos()
	self.isLoitering = true

	self.isFlying = false
end

function ENT:Initialize()
	MelonWars.defaults ( self )

	self:SetStats()

	self:Setup()

	self:GetPhysicsObject():EnableGravity( false )

	util.SpriteTrail( self, 0, Color(255,255,255), false, 20, 0, 4, 0, "trails/laser" )

	self:SetNWInt("fuel", 100)
	self:SetNWInt("maxFuel", 300)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2, self:GetColor().g/2, self:GetColor().b/2, 255))
end

function ENT:SlowThink( ent )
	if not MelonWars.admin_playing then return end
	local selfTbl = self:GetTable()

	selfTbl.phys:Wake()
	if selfTbl.moving then
		selfTbl.isFlying = true
		if selfTbl.targetPos == self:GetNWVector("targetPos", vector_origin) then --Really dumb way of checking that our current movement isn't a result of loitering
			selfTbl.isLoitering = false
		end

		local fuel = self:GetNWInt("fuel", 50)
		local newfuel = math.max(fuel-2, 0)

		selfTbl.startRecharging = CurTime() + 10
		if newfuel <= 0 then
			selfTbl.startRecharging = CurTime() + 20
			selfTbl.exhaustedUntil = CurTime() + 20
			self:ClearOrders()
		end
		self:SetNWInt("fuel", newfuel)
	elseif selfTbl.startRecharging < CurTime() then
		local fuel = self:GetNWInt("fuel", 50)
		local maxFuel = self:GetNWInt("maxFuel", -1)
		self:SetNWInt("fuel", math.min(fuel + 0.5, maxFuel) )
	end

	MelonWars.unitDefaultThink ( ent )
end


function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) and ent.exhaustedUntil < CurTime() and ent.moving then
		MelonWars.defaultShoot ( ent, forcedTargetPos )
		ent.nextControlShoot = CurTime() + ent.slowThinkTimer
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:Unstuck()
end

function ENT:OnFinishMovement()
	local selfTbl = self:GetTable()
	if selfTbl.exhaustedUntil > CurTime() then
		self:ClearOrders()
		return
	end

	for i, v in ipairs(ents.FindInSphere(selfTbl.targetPos, 250)) do
		if v:GetClass() == "ent_melon_refuel" then
			self:ClearOrders()
			return
		end
	end

	if selfTbl.moving or not selfTbl.isFlying then return end --Don't start loitering if we're landing or going to our next rally point

	--Loiter at target destination
	if not selfTbl.isLoitering then
		selfTbl.isLoitering = true
		selfTbl.loiterPos = selfTbl.targetPos
	end

	selfTbl.moving = true
	selfTbl.loiterRotation = (selfTbl.loiterRotation + 0.25 * math.pi)
	local rot = selfTbl.loiterRotation

	local rotS = math.sin(rot)
	local rotC = math.cos(rot)
	selfTbl.targetPos = selfTbl.loiterPos + Vector(rotS * 100, rotC * 100, 0 )
end

function ENT:ClearOrders() --This is duplicate code so it's not ideal. The logic that's copied here hasn't been changed in like 10 years though (ignoring my optimizations) so it shouldn't cause any issues in the future.
	local selfTbl = self:GetTable()
	local selfPos = self:GetPos()
	selfTbl.targetPos = selfPos
	self:SetNWVector("targetPos", selfPos)
	selfTbl.moving = false
	self:SetNWBool("moving", false)
	selfTbl.chasing = false
	selfTbl.followEntity = v
	self:SetNWEntity("followEntity", self)
	self:RemoveRallyPoints()

	selfTbl.isLoitering = false
	selfTbl.isFlying = false
end

function ENT:PhysicsUpdate()
	if not MelonWars.admin_playing then
		self.phys:Sleep()
		return
	end

	self:DefaultPhysicsUpdate()

	local hoverdistance = 300

	local hoverforce = 1

	local selfTbl = self:GetTable()
	local phys = selfTbl.phys
	local selfPos = self:GetPos()
	local tr = util.TraceLine( {
		start = selfPos,
		endpos = selfPos + Vector(0,0,-hoverdistance * 2),
		filter = function( ent )
			local ph = ent:GetPhysicsObject()
			return IsValid(ph) and not ph:IsMoveable()
		end,
		mask = bit.bor(MASK_SOLID,MASK_WATER)
	} )

	if not IsValid(tr.Entity) or not(tr.Entity.Base == "ent_melon_base" or tr.Entity.Base == "ent_melon_energy_base" or tr.Entity.Base == "ent_melon_prop_base") then
		selfTbl.height = tr.HitPos.z
	end

	if not selfTbl.moving or selfTbl.exhaustedUntil > CurTime() then
		hoverdistance = 50
	end

	local force = 0
	local distance = self:GetPos().z - selfTbl.height

	if distance < hoverdistance then
		force = -(distance-hoverdistance) * hoverforce
		local physVel = phys:GetVelocity()
		physVel.x, physVel.y, physVel.z = 0, 0, -physVel.z * 0.5
		phys:ApplyForceCenter(physVel)
	else
		force = -5
	end

	selfTbl.delayedForce = (selfTbl.delayedForce * 2 + force) / 3
	selfTbl.delayedForce = math.Clamp(selfTbl.delayedForce, -100, 100) --Mitigate issues with rocketing into the sky

	phys:ApplyForceCenter(Vector(0,0,selfTbl.delayedForce))
end