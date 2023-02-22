AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_c17/trappropeller_engine.mdl"--"models/props_c17/TrapPropeller_Engine.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 60
	self.thrustforce = 1

	/*self:SetAngles(self:GetAngles()+Angle(90,180,0))

	local offset = Vector(0,-0.8,0)
	offset:Rotate(self:GetAngles())
	self:SetPos(self:GetPos()+offset)*/

	self.maxHP = 200

	self.captureSpeed = 0

	self.population = 0

	self.damping = 1
	self.angularDamping = 10000

	MW_Setup ( self )

	self:GetPhysicsObject():SetMass(150)

	self.moving = true;
end

function ENT:SlowThink ( ent )
	--MW_UnitDefaultThink ( ent )
end

function ENT:Welded( ent, parent )
	local weld = constraint.Weld( ent, parent, 0, 0, 0, true , false )

	--ent.canMove = false
	ent.materialString = "models/shiny"

	ent.parent = parent

	--Resta su poblacion para luego sumar la nueva
	MW_UpdatePopulation(-ent.population, mw_melonTeam)
	ent.population = math.ceil(ent.population/2)
	MW_UpdatePopulation(ent.population, mw_melonTeam)
end

function ENT:Update( ent )
	----[[
	if (cvars.Bool("mw_admin_playing") ) then

		--Aplicar daño
		if (ent.damage > 0) then
			ent.HP = ent.HP-ent.damage
			ent:SetNWFloat( "health", ent.HP )
			ent.damage = 0
			if (ent.HP <= 0) then
				MW_Die( ent )
			end
		end

		ent:SetNWVector( "targetPos", ent.targetPos )

		ent:SetNWEntity( "followEntity", ent.followEntity )

		if (ent.canMove) then
			local phys = self.phys

			local const = constraint.FindConstraints( self, "Weld" )
			if (table.Count(const) == 0) then
				self.damage = 5
			end

			if (IsValid(phys)) then
				---------------------------------------------------------------------------Movimiento
				if (ent.moving) then
					local moveVector = (ent.targetPos-ent:GetPos()):GetNormalized()*self.speed-self:GetVelocity()
					local force = Vector(moveVector.x, moveVector.y, 0)
					--Takes the average between the prev moveforce and the desired new moveforce, prevents it from shaking violently without any noticeable effect on its ability to move
					ent.moveForce = (ent.moveForce + force*self.thrustforce)/2

				else
					local moveVector = -ent:GetVelocity()*0.2
					local force = Vector(moveVector.x, moveVector.y, 0)
					ent.moveForce = force
				end
			end

			if (Vector(ent:GetPos().x, ent:GetPos().y, 0):Distance(Vector(ent.targetPos.x, ent.targetPos.y, 0)) < 100) then
				ent:FinishMovement()
				for k, v in pairs(constraint.GetAllConstrainedEntities( self )) do
					if (v.Base == "ent_melon_base") then
						if (v ~= ent) then
							v:FinishMovement()
						end
					end
				end
			end

			ent:SetNWBool("moving", ent.moving)
			ent:NextThink(CurTime() + 0.01)
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
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end