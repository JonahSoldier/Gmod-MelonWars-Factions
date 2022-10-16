AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

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

	self.alternate = true
end

function ENT:Initialize()

	MW_Defaults ( self )

	self:SetStats()

	MW_Setup ( self )

	self:GetPhysicsObject():EnableGravity( false )

	util.SpriteTrail( self, 0, Color(255,255,255), false, 20, 0, 4, 0, "trails/laser" )

	self:SetNWInt("fuel", 100)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2, self:GetColor().g/2, self:GetColor().b/2, 255))
end

function ENT:SlowThink ( ent )
	if (cvars.Bool("mw_admin_playing") ) then
		MW_UnitDefaultThink ( ent )
		if ((ent:GetPos():Distance(ent.targetPos)) < 160) then
			self:FinishMovement()
		end
	end
end

function ENT:Shoot ( ent, forcedTargetPos )
	if ((ent.ai or CurTime() > ent.nextControlShoot) and ent.exhaustedUntil < CurTime() and ent.moving) then
		MW_DefaultShoot ( ent, forcedTargetPos )
		ent.nextControlShoot = CurTime()+ent.slowThinkTimer
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

function ENT:Unstuck()

end

function ENT:FinishMovement ()
	if (self.rallyPoints[1] == Vector(0,0,0)) then
		if!(self.exhaustedUntil > CurTime()) then
			if(self.moving == true) then
				self.alternate = !self.alternate 
				if(self.alternate) then
					self.rallyPoints[1] = self.targetPos + Vector(50, 50,0)
				else
					self.rallyPoints[1] = self.targetPos - Vector(50, 50,0)
				end
			end
		else
			self.moving = false
			self.stuck = 0
		end
	else
		self.targetPos = self.rallyPoints[1]
		self:SetNWVector("targetPos", self.rallyPoints[1])
		self.moving = true
		for i=1, 30 do
			self.rallyPoints[i] = self.rallyPoints[i+1]
		end
		self.rallyPoints[30] = Vector(0,0,0)
	end



	self:OnFinishMovement()
end

function ENT:SpecificThink()
	self.phys:Wake()
	if (self.moving) then
		local fuel = self:GetNWInt("fuel", 50)
		local newfuel = fuel-2
		self.startRecharging = CurTime()+10
		if (newfuel <= 0) then
			newfuel = 0
			self.startRecharging = CurTime()+20
			self.exhaustedUntil = CurTime()+20
			self:RemoveRallyPoints()
			self:FinishMovement()
		end
		self:SetNWInt("fuel", newfuel)
	else
		if (self.startRecharging < CurTime()) then
			local fuel = self:GetNWInt("fuel", 50)
			local newfuel = fuel+0.5
			if (newfuel > 500) then
				newfuel = 500
			end
			self:SetNWInt("fuel", newfuel)
		end
	end
end

function ENT:PhysicsUpdate()
	
	if (cvars.Bool("mw_admin_playing") ) then
	--if (self.moving == true) then

		self:DefaultPhysicsUpdate()

		local hoverdistance = 300

		local hoverforce = 1
		local phys = self.phys
		local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos()+Vector(0,0,-hoverdistance*2),
		filter = function( ent )
			local ph = ent:GetPhysicsObject()
			if (IsValid(ph)) then
				if ( not ent:GetPhysicsObject():IsMoveable() ) then
					return true
				end
			end
		end,
		mask = bit.bor(MASK_SOLID,MASK_WATER)
		} )

		if (not IsValid(tr.Entity) or not string.StartWith( tr.Entity:GetClass(),  "ent_melon" )) then
			self.height = tr.HitPos.z
		end

		if (not self.moving or self.exhaustedUntil > CurTime()) then
			hoverdistance = 50
		end

		local force = 0
		local distance = self:GetPos().z - self.height

		if (distance < hoverdistance) then
			force = -(distance-hoverdistance)*hoverforce
			phys:ApplyForceCenter(Vector(0,0,-phys:GetVelocity().z*0.8))
		else
			force = -5
		end
		
		//if (force > self.delayedForce) then
			self.delayedForce = (self.delayedForce*2+force)/3
		//else
			//self.delayedForce = self.delayedForce*0.7
		//end

		phys:ApplyForceCenter(Vector(0,0,self.delayedForce))
	--end
	else
		self.phys:Sleep()
	end
end