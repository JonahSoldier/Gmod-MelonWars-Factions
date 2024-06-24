AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_c17/trappropeller_engine.mdl"--"models/props_c17/TrapPropeller_Engine.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 60
	self.thrustforce = 1

	self.maxHP = 200

	self.captureSpeed = 0

	self.population = 0

	self.damping = 1
	self.angularDamping = 10000

	self:Setup()

	self:GetPhysicsObject():SetMass(150)

	self.moving = true
	self.isContraptionPart = true
end

function ENT:SlowThink ( ent )
	--MelonWars.unitDefaultThink ( ent )
end

function ENT:Welded( ent, parent )
	local weld = constraint.Weld( ent, parent, 0, 0, 0, true , false )

	--ent.canMove = false
	ent.materialString = "models/shiny"

	ent.parent = parent

	--Resta su poblacion para luego sumar la nueva
	MelonWars.updatePopulation(-ent.population, mw_melonTeam)
	ent.population = math.ceil(ent.population/2)
	MelonWars.updatePopulation(ent.population, mw_melonTeam)
end

function ENT:Update( ent ) --TODO: Refactor
	----[[
	if (cvars.Bool("mw_admin_playing") ) then

		local const = constraint.FindConstraints( self, "Weld" )
		if table.Count(const) == 0 then
			self:TakeDamage(5)
		end

		self:SetNWVector( "targetPos", self.targetPos )

		self:SetNWEntity( "followEntity", self.followEntity )

		if (self.canMove) then
			local phys = self.phys

			if (IsValid(phys)) then
				---------------------------------------------------------------------------Movimiento
				if (self.moving) then
					local moveVector = (self.targetPos-self:GetPos()):GetNormalized()*self.speed-self:GetVelocity()
					local force = Vector(moveVector.x, moveVector.y, 0)
					--Takes the average between the prev moveforce and the desired new moveforce, prevents it from shaking violently without any noticeable effect on its ability to move
					self.moveForce = (self.moveForce + force*self.thrustforce)/2

				else
					local moveVector = -self:GetVelocity()*0.2
					local force = Vector(moveVector.x, moveVector.y, 0)
					self.moveForce = force
				end
			end

			if (Vector(self:GetPos().x, self:GetPos().y, 0):Distance(Vector(self.targetPos.x, self.targetPos.y, 0)) < 100) then
				self:FinishMovement()
				for k, v in pairs(constraint.GetAllConstrainedEntities( self )) do
					if (v.Base == "ent_melon_base") then
						if (v ~= self) then
							v:FinishMovement()
						end
					end
				end
			end

			self:SetNWBool("moving", self.moving)
			self:NextThink(CurTime() + 0.01)
			return true
		end
	end
	--]]--
end

function ENT:PhysicsUpdate()
	self:Align(self:GetAngles():Forward(), Vector(0,0,-1), 1000)

	local moveVector = (self.targetPos-self:GetPos())
	if (self.moving) then
		self:Align(self:GetAngles():Up(), -moveVector:GetNormalized(), 100000)
	end

	self:StopAngularVelocity(0.8)

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end