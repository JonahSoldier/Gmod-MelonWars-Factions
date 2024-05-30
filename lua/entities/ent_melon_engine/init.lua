AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')
function ENT:Initialize()
	MelonWars.defaults(self)
	self.modelString = "models/thrusters/jetpack.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 150
	self.thrustforce = 0.3
	self.maxHP = 25
	self.captureSpeed = 0
	self.population = 0
	self.damping = 0.01
	self.angularDamping = 1000

	self:Setup()

	self:GetPhysicsObject():SetMass(50)
	self.moving = true
end

function ENT:SlowThink(ent)
	--MelonWars.unitDefaultThink ( ent )
end

function ENT:Welded(ent, parent)
	local weld = constraint.Weld(ent, parent, 0, 0, 0, true, false)
	--ent.canMove = false
	ent.materialString = "models/shiny"
	ent.parent = parent
	--Resta su poblacion para luego sumar la nueva
	MelonWars.updatePopulation(-ent.population, mw_melonTeam)
	ent.population = math.ceil(ent.population / 2)
	MelonWars.updatePopulation(ent.population, mw_melonTeam)
end

function ENT:Update() --TODO: Rewrite. This is just copied from the (old) ent_melon_base
	if cvars.Bool("mw_admin_playing") then
		--Aplicar daño
		if self.damage > 0 then
			self.HP = self.HP - self.damage
			self:SetNWFloat("health", self.HP)
			self.damage = 0
			if self.HP <= 0 then MelonWars.die(self) end
		end

		self:SetNWVector("targetPos", self.targetPos)
		self:SetNWEntity("followEntity", self.followselfity)
		if self.canMove then
			local phys = self.phys
			local const = constraint.FindConstraints(self, "Weld")
			if table.Count(const) == 0 then self.damage = 5 end
			if IsValid(phys) then
				---------------------------------------------------------------------------Movimiento
				if self.moving then
					local moveVector = (self.targetPos - self:GetPos()):GetNormalized() * self.speed - self:GetVelocity()
					local force = Vector(moveVector.x, moveVector.y, 0)
					self.moveForce = force * self.thrustforce
				else
					local moveVector = -self:GetVelocity() * 0.2
					local force = Vector(moveVector.x, moveVector.y, 0)
					self.moveForce = force
				end
			end

			if Vector(self:GetPos().x, self:GetPos().y, 0):Distance(Vector(self.targetPos.x, self.targetPos.y, 0)) < 100 then
				self:FinishMovement()
				for k, v in pairs(constraint.GetAllConstrainedEntities(self)) do
					if v.Base == "ent_melon_base" then if v ~= self then v:FinishMovement() end end
				end
			end

			self:SetNWBool("moving", self.moving)
			self:NextThink(CurTime() + 0.01)
			return true
		end
	end
end

function ENT:PhysicsUpdate()
	self:Align(self:GetAngles():Forward(), Vector(0, 0, -1), 10000)
	local moveVector = (self.targetPos - self:GetPos()):GetNormalized()
	if self.moving then self:Align(self:GetAngles():Up(), -moveVector, 100000) end
	--local damp = -self:GetAngles():Up():Dot(moveVector)
	local damp = 0.8
	self:StopAngularVelocity(damp)
	self:DefaultPhysicsUpdate()
end

function ENT:Shoot(ent)
	--MelonWars.defaultShoot ( ent )
end

function ENT:DeathEffect(ent)
	MelonWars.defaultDeathEffect(ent)
end