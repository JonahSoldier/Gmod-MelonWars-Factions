AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

local unit_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
local mw_admin_playing_cv = GetConVar( "mw_admin_playing" )

function MelonWars.defaults( ent )
	ent.maxHP = 20
	ent.HP = 1
	ent:SetNWFloat( "healthFrac" , 1)
	ent.speed = 100
	ent.range = 250
	ent.spread = 1
	ent.damageDeal = 3
	ent.buildingDamageMultiplier = 1
	ent.canMove = true
	ent.canBeSelected = true
	ent.sphereRadius = 0
	ent.careForFriendlyFire = true
	ent.careForWalls = true
	ent.targetPos = ent:GetPos()

	ent.moveForceMultiplier = 1

	ent.captureSpeed = 4

	--ent.dootChance = 0

	local z = Vector(0,0,0)
	ent.rallyPoints = {z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z}

	ent.targetable = true

	ent.minRange = 0

	ent.population = 1

	ent.ai_chases = true
	ent.chasing = false

	ent.value = 0

	ent.damage = 0

	ent.fired = false
	ent.gotHit = false

	ent.changeAngles = true
	ent.changeModel = true

	ent.nextJump = 0

	ent.spawned = false

	if (ent.shotOffset == nil) then ent.shotOffset = Vector(0,0,0) end
	ent.modelString = "models/props_junk/watermelon01.mdl"
	ent.materialString = "models/debug/debugwhite"

	ent.deathSound = "phx/eggcrack.wav"
	ent.shotSound = "weapons/alyx_gun/alyx_gun_fire6.wav"

	ent.tracer = "AR2Tracer"
	ent.onFire = false

	ent.deathEffect = "cball_explode"

	ent.canShoot = true

	ent.slowThinkTimer = 2

	ent.lastPosition = Vector(0,0,0)
	ent.stuck = 0

	if (ent.Angles == nil) then ent.Angles = Angle(0,0,0) end
	ent:SetMaterial( "Models/effects/comball_sphere" )

	ent:SetColor( unit_colors[mw_melonTeam] )

	ent.damping = 1.5
	ent.angularDamping = -1

	ent.nextSlowThink = 0
	ent.nextControlShoot = 0

	ent.carryingMelonium = false

	--Bot variables-
	ent.holdGroundPosition = ent:GetPos()
	ent.chaseStance = false
	ent.maxChaseDistance = 800
	ent.barrier = nil
	ent.ai = true
	ent.meleeAi = false
	----------------

	ent.posOffset = Vector(0,0,0)
end

function ENT:Ini( teamnumber, affectPopulation )
	self:SetNWInt( "mw_melonTeam", teamnumber )
	self:SetNWInt( "mw_sick", 0 )
	self:MelonSetColor( teamnumber )
	self.nextSlowThink = CurTime() + 1
	if affectPopulation ~= false then
		MelonWars.updatePopulation( self.population, teamnumber )
	end
	if teamnumber == 0 then
		self.chaseStance = true
	end

	self.mw_melonTeam = teamnumber

	if teamnumber == -1 then
		error( "Unit " .. tostring( self ) .. " spawned with team -1!" )
	end
end

function ENT:SkinMaterial(newMaterial)
	self.materialString = newMaterial
	if (self.spawned) then
		self:SetMaterial(self.materialString)
	end
end

function ENT:MelonSetColor( teamnumber )
	local newColor
	if teamnumber == 0 then
		newColor = Color( 50, 50, 50, 255 )
	else
		newColor = unit_colors[teamnumber]
	end
	self:SetColor( newColor )
	self:ModifyColor()
end

function ENT:ModifyColor() -- Meant to be overridden by certain units if necessary
end

local function MW_Spawn( ent )
	if not SERVER then return end
	ent:SetMoveType( ent.moveType )   -- after all, gmod is a physics
	ent:SetMaterial(ent.materialString)
	ent.spawned = true

	ent.HP = ent.maxHP
	--ent:SetNWFloat( "maxhealth", ent.maxHP )
	--ent:SetNWFloat( "health", ent.HP )
	ent:SetNWFloat( "healthFrac", ent.HP / ent.maxHP )

	local baseSize
	if (ent.sphereRadius ~= 0) then
		baseSize = ent.sphereRadius
	else
		local mins = ent.phys:GetAABB()
		baseSize = (-mins.x-mins.y) * 0.6
	end
	ent:SetNWFloat( "baseSize", baseSize + 5 ) --TODO: See if this can be done without networking

	hook.Run("MelonWarsEntitySpawned", ent)
end

function ENT:Setup()
	self.targetEntity = nil
	self.followEntity = nil
	self.forcedTargetEntity = nil
	self:SetNWEntity( "targetEntity", self.targetEntity )
	self:SetNWEntity( "followEntity", self.followEntity )
	self:SetNWBool( "moving", false )
	--self:SetNWFloat( "range", self.range )

	self.moving = false
	self.damage = 0

	self.moveForce = Vector( 0, 0, 0 )

	--self:SetPos(self:GetPos()+self.posOffset)

	if self.changeModel then
		self:SetModel( self.modelString )
	end

	if self.sphereRadius > 0 then
		self:PhysicsInitSphere( self.sphereRadius, "slime" )
	elseif self.useBBoxPhys then
		self:PhysicsInit( SOLID_VPHYSICS )
		local mins, maxs = self:GetPhysicsObject():GetAABB()
		self:PhysicsInitBox( mins, maxs, "slime" )
	else
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics
		self:SetSolid( SOLID_VPHYSICS )
	end

	self.phys = self:GetPhysicsObject()

	if self.moveType == 0 then
		local weld = constraint.Weld( self, game.GetWorld(), 0, 0, 0, true , false )
		self.canMove = false
		self.phys:EnableMotion( false )
	end

	if IsValid( self.phys ) then
		self.phys:Wake()
		if self.angularDamping == -1 then
			self.angularDamping = self.damping
		end
		self.phys:SetDamping( self.damping, self.angularDamping )
	end

	if self.changeAngles then
		self:SetAngles( self:GetAngles() + self.Angles )
	end

	self:SetNWEntity( "targetEntity", self.targetEntity )

	if cvars.Number( "mw_admin_spawn_time" ) == 1 and self.mw_spawntime ~= nil then
		timer.Simple( self.mw_spawntime - CurTime(), function()
			if IsValid( self ) then
				MW_Spawn( self )
			end
		end )
	else
		MW_Spawn( self )
	end
end

function ENT:Welded( ent, parent )
	--script a ejecutar si se spawnea weldeada
	local weld = constraint.Weld( ent, parent, 0, 0, 0, true , false )
	ent.canMove = false
	ent.materialString = "models/shiny"

	ent.parent = parent

	ent.phys:SetDamping(0,0)

	ent:SetCollisionGroup(2)
	--Resta su poblacion para luego sumar la nueva
	--MelonWars.updatePopulation(-ent.population, mw_melonTeam)
	ent.population = math.ceil(ent.population/2)
	--MelonWars.updatePopulation(ent.population, mw_melonTeam)
end

function ENT:Think()
	local selfTbl = self:GetTable()
	if selfTbl.carryingMelonium then
		self:SetNWFloat( "mw_sick", 30 )
	end

	local sick = self:GetNWFloat( "mw_sick", 0 )
	if sick > 0 then
		self:SetNWFloat( "mw_sick", sick - 0.2 )
		selfTbl.damage = selfTbl.damage + 0.12
	end

	local phys = selfTbl.phys
	if not phys:IsAsleep() then
		if selfTbl.moving == false and selfTbl.canMove then -- NOTE: Is the commented-out code in this section actually necessary? If not having it breaks something, add it back in.
			--local tr = util.QuickTrace( self:GetPos(), Vector( 0, 0, -self.sphereRadius + 15 ), self )
			--if tr.Entity ~= nil then
				--self.phys:SetDamping(self.damping*5,self.damping*5)
				local velocity = self:GetVelocity()
				local stoppingForce = phys:GetMass() * -velocity * 0.5
				stoppingForce.z = 0
				phys:ApplyForceCenter( stoppingForce )
				if velocity:LengthSqr() < 800 then
					phys:Sleep()
				end
			--end
		--else
			--phys:SetDamping( self.damping, self.damping )
		end
	end

	if selfTbl.spawned then
		self:Update()
	end

	if not selfTbl.canMove and self:GetClass() ~= ( "ent_melon_unit_transport" or "ent_melon_main_unit" ) and self:GetMoveType() ~= MOVETYPE_NONE then
		local const = constraint.FindConstraints( self, "Weld" )
		table.Add( const, constraint.FindConstraints( self, "Axis" ) )
		if table.Count( const ) == 0 then
			selfTbl.damage = 5
		end
	end

	if not ( IsValid( selfTbl.parent ) or selfTbl.parent == nil or selfTbl.parent:IsWorld() ) then
		selfTbl.damage = 5
	end
end

function ENT:Update()
	if not mw_admin_playing_cv:GetBool() then return end
	local selfTbl = self:GetTable()
	if CurTime() > selfTbl.nextSlowThink then
		selfTbl.nextSlowThink = CurTime() + selfTbl.slowThinkTimer
		self:SlowThink( self )
	end

	if selfTbl.damage > 0 then -- Apply damage
		selfTbl.gotHit = true
		selfTbl.HP = selfTbl.HP - selfTbl.damage
		--self:SetNWFloat( "health", selfTbl.HP )
		self:SetNWFloat( "healthFrac", selfTbl.HP / selfTbl.maxHP )
		selfTbl.damage = 0
		if selfTbl.HP <= 0 then
			MelonWars.die( self )
		end
	end

	--TODO: Find where target/follow entities are set, and see if this can be moved out. Doing it in update is expensive.
	self:SetNWEntity( "targetEntity", selfTbl.targetEntity )
	self:SetNWEntity( "followEntity", selfTbl.followEntity )

	local entPos = self:GetPos()
	local followEntityPos = vector_origin
	if IsValid( selfTbl.followEntity ) then
		followEntityPos = selfTbl.followEntity:GetPos()
	end
	local targetEntityPos = vector_origin
	if IsValid( selfTbl.targetEntity ) then
		targetEntityPos = selfTbl.targetEntity:GetPos()
	end

	if not selfTbl.canMove then return end
	if selfTbl.followEntity ~= self then
		if IsValid( selfTbl.followEntity ) then
			if (followEntityPos-entPos):LengthSqr() > selfTbl.range*selfTbl.range then
				selfTbl.targetPos = followEntityPos+(entPos-followEntityPos):GetNormalized()*selfTbl.range*0.5
				selfTbl.moving = true
			end
		end
	else
		if selfTbl.chasing then
			if IsValid(selfTbl.targetEntity) then
				if (targetEntityPos-entPos):LengthSqr() > selfTbl.range*selfTbl.range then
					local chanceDistMul = 0.9
					if selfTbl.meleeAi then
						chanceDistMul = 0.2
					end
					selfTbl.targetPos = targetEntityPos+(entPos-targetEntityPos):GetNormalized()*selfTbl.range*chanceDistMul
					selfTbl.moving = true
				end
			end
		end
	end

	local phys = selfTbl.phys

	if IsValid(phys) then
		---------------------------------------------------------------------------Movimiento
		if selfTbl.moving then
			--if (self.chaseStance == false or self.targetEntity == nil) then
			local moveVector = (selfTbl.targetPos-entPos):GetNormalized()*selfTbl.speed-self:GetVelocity()*0.5
			local force = Vector(moveVector.x, moveVector.y, 0)
			-- OLD MOVEMENT, MOVE IN THINK. NEW MOVEMENT IN PHYSICS UPDATE
			--phys:ApplyForceCenter (force*phys:GetMass())
			-- new:
			selfTbl.phys:Wake()
			selfTbl.moveForce = force*0.5*selfTbl.moveForceMultiplier
			--end
		end

		if selfTbl.moving and selfTbl.ai then
			local distanceToLastPosition = (selfTbl.lastPosition-entPos):LengthSqr()

			if selfTbl.lastPosition ~= vector_origin and distanceToLastPosition > 500000 then --Stop moving if distance from lastposition is ridiculous (teleported)
				self:FinishMovement()
				selfTbl.lastPosition = vector_origin
			elseif distanceToLastPosition < (selfTbl.speed/2)*(selfTbl.speed/2)then
				selfTbl.stuck = selfTbl.stuck+1
			else
				selfTbl.lastPosition = entPos
				selfTbl.stuck = 0
			end

			if selfTbl.stuck % 8 == 7 then
				if selfTbl.stuck > 40 then
					if not selfTbl.chaseStance then
						selfTbl.targetEntity = nil
						self:FinishMovement()
						selfTbl.stuck = 0
					end
				else
					if not selfTbl.chaseStance or (selfTbl.chaseStance and not IsValid(selfTbl.targetEntity)) then
						self:Unstuck()
					end
				end
			end
		end
	end

	local flattenedTargetPos = Vector(selfTbl.targetPos.x, selfTbl.targetPos.y, entPos.z)
	if selfTbl.ai then
		if (flattenedTargetPos-entPos):LengthSqr() < 900 then
			self:FinishMovement()
		end
	else
		if (flattenedTargetPos-entPos):LengthSqr() < 100 then
			self:FinishMovement()
		end
	end

	--TODO: Ditto of other todo in this function
	self:SetNWBool("moving", selfTbl.moving)

	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:Unstuck()
	local phys = self.phys
	if CurTime() <= self.nextJump then return end
	phys:ApplyForceCenter (Vector(0,0,self.speed*2.5)*phys:GetMass())
	self.nextJump = CurTime()+1
end

function ENT:FinishMovement()
	local selfTbl = self:GetTable()
	if (selfTbl.rallyPoints[1] == vector_origin) then
		selfTbl.moving = false
		selfTbl.stuck = 0
	else
		selfTbl.targetPos = selfTbl.rallyPoints[1]
		self:SetNWVector("targetPos", selfTbl.rallyPoints[1])
		selfTbl.moving = true
		for i=1, 30 do
			selfTbl.rallyPoints[i] = selfTbl.rallyPoints[i+1]
		end
		selfTbl.rallyPoints[30] = vector_origin
	end
	self:OnFinishMovement()
end

function ENT:OnFinishMovement()
end

function ENT:RemoveRallyPoints()
	for i=1, 30 do
		self.rallyPoints[i] = vector_origin
	end
end

function ENT:SameTeam(ent)
	local myTeam = self:GetNWInt("mw_melonTeam", 0)
	local otherTeam = ent:GetNWInt("mw_melonTeam", 0)
	if (myTeam == otherTeam) then
		return true
	end
	if (myTeam == 0 or otherTeam == 0) then
		return false
	end
	return MelonWars.teamGrid[myTeam][otherTeam];
end

function ENT:AlignUpright( strength, incMult )
	local selfTbl = self:GetTable()
	local inclination = selfTbl.Align(self, self:GetAngles():Up(), vector_up, strength)
	selfTbl.phys:ApplyForceCenter( Vector(0,0,inclination * incMult))
end

function ENT:Align( reference, target, multiplier )
	local cross = reference:Cross(target)
	local torque = cross * multiplier

	self:GetTable().ApplyTorque(self, torque)

	return cross:LengthSqr()
end

function ENT:StopAngularVelocity( percent )
	local phys = self.phys
	phys:AddAngleVelocity( -phys:GetAngleVelocity() * percent )
end

function ENT:ApplyTorque( torque )
	local forceOffset = torque:Angle():Right()
	local forceDirection = torque:Cross(forceOffset)

	local phys = self:GetTable().phys
	local pos = self:GetPos()

	phys:ApplyForceOffset( forceDirection, pos + forceOffset )
	pos:Sub(forceOffset) --vector optimization
	forceDirection:Negate()
	phys:ApplyForceOffset( forceDirection, pos )
end

function MelonWars.unitDefaultThink( ent ) --TODO: Optimize
	local pos = ent:GetPos()
	if not util.IsInWorld( pos ) then ent:Remove() end
	local entTbl = ent:GetTable()
	if not ( entTbl.canShoot and entTbl.ai ) then return end

	if ( not(IsValid(entTbl.targetEntity)) or entTbl.targetEntity.Base == "ent_melon_prop_base" or entTbl.targetEntity:GetNWInt("propHP",-1) ~= -1) then
		----------------------------------------------------------------------Buscar target
		local foundEnts = ents.FindInSphere(pos, entTbl.range )

		local ourTeam = ent:GetNWInt("mw_melonTeam", 0)
		for _, v in ipairs( foundEnts ) do
			local vTbl = v:GetTable()
			if vTbl.Base == "ent_melon_base" and vTbl.targetable and not MelonWars.sameTeam(ourTeam, v:GetNWInt("mw_melonTeam", 0)) and ( not vTbl.AOETargetableOnly or entTbl.isAOE) then
				if (entTbl.careForWalls) then
					local tr = util.TraceLine( {
						start = pos,
						endpos = v:GetPos() + (vTbl.shotOffset or vector_origin),
						filter = function( foundEnt )
							if foundEnt:GetClass() == "prop_physics" then--si hay un prop en el medio
								return true
							end
							if entTbl.careForFriendlyFire then --No dispara si hay un compañero en el camino
								if foundEnt.Base == "ent_melon_base" and foundEnt:GetNWInt("mw_melonTeam", -1) == ourTeam and foundEnt ~= ent then
									return true
								end
							end
						end
						})
					if not tr.Entity:IsValid() then
						entTbl.targetEntity = v
						break
					end
				else
					entTbl.targetEntity = v
					break
				end
			end
		end

		-------------------------------------------------Si aun asi no encontró target
		--not 100% sure what the point of having this second loop here is. -j
		if (entTbl.targetEntity == nil) then
			for _, v in ipairs( foundEnts ) do
				local vClass = v:GetClass()
				local vTeam = v:GetNWInt("mw_melonTeam", ourTeam)
				if not( ourTeam == vTeam or MelonWars.sameTeam(ourTeam, vTeam) or string.StartWith( vClass, "ent_melonbullet_" )) and (not v.AOETargetableOnly or entTbl.isAOE) then --si es de otro equipo
					if (entTbl.chaseStance) then
						if (vClass == "ent_melon_wall") then
							if (entTbl.stuck > 15) then
								if (IsValid(entTbl.barrier)) then
									entTbl.targetEntity = entTbl.barrier
								else
									entTbl.targetEntity = v
									break
								end
							end
						else
							entTbl.targetEntity = v
							break
						end
					else
						entTbl.targetEntity = v
						break
					end
				end
			end
		end
	end

	if (entTbl.targetEntity ~= nil) then
		----------------------------------------------------------------------Perder target
		----------------------------------------porque no existe
		if not IsValid(entTbl.targetEntity) then
			entTbl.stuck = 0
			return ent:LoseTarget()
		----------------------------------------por que esta en el 0,0,0
		elseif (entTbl.targetEntity:GetPos() == vector_origin) then
			return ent:LoseTarget()
		end
		----------------------------------------porque es intargeteable
		if (not entTbl.targetable) then
			return ent:LoseTarget()
		end
		----------------------------------------porque es el mismo
		if (entTbl.targetEntity == ent or entTbl.forcedTargetEntity == ent) then
			return ent:LoseTarget()
		end
		----------------------------------------porque es un aliado
		if ent:SameTeam(entTbl.targetEntity) then
			return ent:LoseTarget()
		end
		----------------------------------------porque está lejos (o muy cerca)
		local targetDist = entTbl.targetEntity:GetPos():Distance(pos)
		if (IsValid(entTbl.targetEntity) and (targetDist > entTbl.range + entTbl.targetEntity:GetNWFloat( "baseSize", 0) or targetDist < entTbl.minRange)) then
			if (entTbl.chaseStance and entTbl.ai_chases) then
				if (not entTbl.chasing) then
					entTbl.holdGroundPosition = pos
					entTbl.chasing = true
				end
				local tepos = entTbl.targetEntity:GetPos()
				entTbl.targetPos = tepos
				ent:SetNWVector("targetPos", tepos)
				entTbl.moving = true
				entTbl.followEntity = ent
				ent:SetNWEntity("followEntity", ent)
				if ((tepos-entTbl.holdGroundPosition):LengthSqr() > entTbl.maxChaseDistance*entTbl.maxChaseDistance) then
					ent:LoseTarget()
				end
			else
				ent:LoseTarget()
			end
			return false
		end
		----------------------------------------------objetivo forzado
		if (IsValid(entTbl.forcedTargetEntity)) then
			entTbl.targetEntity = entTbl.forcedTargetEntity
		else
			entTbl.forcedTargetEntity = nil
		end

		local ourTeam = ent:GetNWInt("mw_melonTeam", 0)
		local tr = util.TraceLine( {
			start = pos,
			endpos = entTbl.targetEntity:GetPos()+entTbl.targetEntity:GetVar("shotOffset", vector_origin),
				filter = function( foundEntity ) 
					if (foundEntity.Base ~= "ent_melon_base" and foundEntity.Base ~= "ent_melon_energy_base" and foundEntity:GetNWInt("mw_melonTeam", -1) == ourTeam or foundEntity:GetClass() == "prop_physics" and foundEntity ~= entTbl.targetEntity) then
						 return true
					end
				end
			})
		----------------------------------------por que hay algo en el medio

		if (entTbl.careForWalls) then
			if (tostring(tr.Entity) ~= "[NULL Entity]") then
				return ent:LoseTarget()
			end

			if (tostring(tr.Entity) == "Entity [0][worldspawn]") then
				return ent:LoseTarget()
			end
		end
	end

	if (entTbl.targetEntity ~= nil) then
		local distSqr = entTbl.targetEntity:GetPos():DistToSqr(pos)
		if distSqr < (entTbl.range + entTbl.targetEntity:GetNWFloat( "baseSize", 0)) ^ 2 and distSqr > entTbl.minRange ^ 2 then
			if (entTbl.targetEntity:GetNWInt("mw_melonTeam", 0) ~= ent:GetNWInt("mw_melonTeam", 0)) then --TODO: maybe re-structure to get our team earlier and recycle it here too.
				ent:Shoot( ent )
			end
		end
	end
end

function ENT:LoseTarget()
	self.targetEntity = nil
	self:SetNWEntity("targetEntity", nil)
	self.forcedTargetEntity = nil
	self.nextSlowThink = CurTime()+0.5
	if (self.chaseStance) then
		self:SetVar("targetPos", self.holdGroundPosition)
		self:SetNWVector("targetPos", self.holdGroundPosition)
		self:SetVar("moving", true)
		self:SetVar("chasing", false)
		self:SetVar("followEntity", self)
		self:SetNWEntity("followEntity", self)
	end

	return false
end

function ENT:PhysicsCollide( colData, physObject )
	local other = colData.HitEntity
	if not IsValid(other) then return end

	local selfTbl = self:GetTable()
	local otherTbl = other:GetTable()

	local otherTargetPos = otherTbl.targetPos
	if (otherTargetPos == selfTbl.targetPos and not otherTbl.moving) or selfTbl.rallyPoints[1] == otherTargetPos then
		self:FinishMovement()
	end
	local otherSick = other:GetNWFloat("mw_sick", 0)
	if otherSick > 0 and otherSick > self:GetNWFloat("mw_sick", 0) then --Slightly less efficient when the target is sick, but slightly more-so when they aren't (which is more common).
		self:SetNWFloat("mw_sick", otherSick)
	end
	if other:GetClass() == "ent_melon_wall" then
		selfTbl.barrier = other
	end
end

function MelonWars.defaultShoot( ent, forceTargetPos ) --TODO: Optimize
	local pos = ent:GetPos()+ent.shotOffset
	--------------------------------------------------------Disparar
	if (forceTargetPos ~= nil or IsValid(ent.targetEntity)) then
		local dir = nil
		if (IsValid(ent.targetEntity)) then
			local targetPos = ent.targetEntity:GetPos()-ent.targetEntity:OBBCenter()
			if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
				if ent.targetEntity:GetVar("shotOffset") ~= vector_origin then
					targetPos = ent.targetEntity:GetPos()+ent.targetEntity:GetVar("shotOffset")
				end
			end
			dir = (targetPos-pos):GetNormalized()
		else
			dir = (forceTargetPos-pos):GetNormalized()
		end

		MelonWars.bullet(ent, pos, dir, ent.range, ent, nil, 0)

		local effectdata = EffectData()
		effectdata:SetScale(1)
		effectdata:SetAngles( dir:Angle())
		effectdata:SetOrigin( pos + dir:GetNormalized() * 10 )
		util.Effect( "MuzzleEffect", effectdata )
		sound.Play( ent.shotSound, pos )
	end
end

function MelonWars.bullet(ent, startingPos, direction, distance, ignore, callback, depth)
	local damage = ent.damageDeal
	local spread = Angle(math.random(-ent.spread/4, ent.spread/4),math.random(-ent.spread/4, ent.spread/4),0)
	ent.fired = true
	local effectdata = EffectData()
	local angle = direction:Angle()
	local hitpos = startingPos + direction * distance
	---------------------------------------------------------------------Esto va hacer que se aplique el daño le pegue o no
	if (forceTargetPos == nil and ent.targetEntity.Base == "ent_melon_prop_base") then
		ent.targetEntity:SetNWFloat( "health", ent.targetEntity:GetNWFloat( "health", 1)-ent.damageDeal)
		if (ent.targetEntity:GetNWFloat( "health", 1) <= 0) then
			ent.targetEntity:PropDie()
		end
	elseif (forceTargetPos == nil and ent.targetEntity:GetClass() == "prop_physics") then
		ent.targetEntity:TakeDamage( ent.damageDeal, ent, ent )
		local php = ent:GetNWInt("propHP", -1)
		if (php ~= -1) then
			ent:SetNWInt("propHP", php-ent.damageDeal)
		end
	else
		-- New Laser shooting
		direction:Rotate(spread)
		local tr = util.QuickTrace( startingPos, direction*distance, function(hitEnt)
			local cl = hitEnt:GetClass()
			if (cl == "ent_melon_wheel" or cl == "ent_melon_propeller" or cl == "ent_melon_hover") then
				return true
			end
			if (hitEnt == ent or ent:SameTeam(hitEnt)) then
				return false
			end
			return true
		end)

		hitpos = tr.HitPos

		--local angle = (tr.HitPos-startingPos):Angle()

		local effectdata = EffectData()
		if ((tr.HitPos-startingPos):LengthSqr() < 130*130) then
			effectdata:SetOrigin(startingPos+direction*130)
		else
			effectdata:SetOrigin(tr.HitPos)
		end

		if (IsValid(tr.Entity)) then
			tr.Entity:TakeDamage( damage, ent, ent )
			if (callback ~= nil) then
				callback(ent,tr.Entity)
			end
		end
	end
	effectdata:SetStart(startingPos)
	effectdata:SetScale(2000)
	effectdata:SetAngles(angle)
	util.Effect( "AR2Tracer", effectdata )
	effectdata:SetOrigin(hitpos)
	effectdata:SetScale(3)
	effectdata:SetNormal(direction)
	util.Effect( "AR2Impact", effectdata )
	------------
end

function MelonWars.defaultDeathEffect( ent )
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	util.Effect( ent.deathEffect, effectdata )
	sound.Play( ent.deathSound, ent:GetPos() )
	ent:Remove()
end

function ENT:DeathEffect( ent )
	MelonWars.defaultDeathEffect(ent)
end

function MelonWars.die( ent )
	if not IsValid(ent) then return end
	if cvars.Bool("mw_admin_immortality") then return end
	if ent.DeathEffect == nil then return end
	-- ent:SpawnDoot()
	ent:DeathEffect ( ent )
end

function ENT:PhysicsUpdate()
	self:DefaultPhysicsUpdate()
end

function ENT:DefaultPhysicsUpdate()
	if mw_admin_playing_cv:GetBool() then
		local selfTbl = self:GetTable()
		if (selfTbl.moving) then
			local vel = self:GetVelocity()
			if (vel:LengthSqr() < selfTbl.speed ^ 2) then
				local phys = selfTbl.phys
				phys:ApplyForceCenter (selfTbl.moveForce * phys:GetMass())
			else
				vel[3] = 0
				vel:Mul( -0.02 * selfTbl.phys:GetMass())
				selfTbl.phys:ApplyForceCenter (vel)
			end
		else
			selfTbl.moveForce = vector_origin
		end
	else
		self.phys:Sleep()
	end
end

function ENT:OnTakeDamage( damage )
	local attacker = damage:GetAttacker()
	if (attacker:GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0) or not attacker:GetVar('careForFriendlyFire')) and not attacker:IsPlayer() then
		local selfTbl = self:GetTable()
		local damageDone = damage:GetDamage()

		if not selfTbl.canMove then
			local mul = attacker.buildingDamageMultiplier
			damageDone = damageDone * (mul or 1)
		end
		if damage:GetDamageType() == DMG_BURN then
			damageDone = damageDone * 0.5
		end
		if self:SameTeam(attacker) then --TODO: Alliance check. I've accidentally wiped a teammate's squad with bombs on at least one occasion.
			damageDone = damageDone / 10
		end

		selfTbl.HP = selfTbl.HP - damageDone
		selfTbl.gotHit = selfTbl.gotHit or damageDone > 0
		self:SetNWFloat( "healthFrac", selfTbl.HP / selfTbl.maxHP )

		if selfTbl.HP <= 0 then
			MelonWars.die (self)
		end
	end
end

function ENT:OnRemove()
	if self:GetTable().carryingMelonium then
		local melonium = ents.Create("ent_melonium")
		melonium:SetPos(self:GetPos() + Vector(0,0,10))
		melonium:Spawn()
		melonium:GetPhysicsObject():ApplyForceCenter(Vector(0,0,100))
	end

	self:DefaultOnRemove()
end

function ENT:DefaultOnRemove()
	if not SERVER then return end
	if not IsValid(self) then return end
	local selfTbl = self:GetTable()
	local selfTeam = self:GetNWInt("mw_melonTeam", 0)
	MelonWars.updatePopulation(-selfTbl.population, selfTeam)
	if not selfTbl.gotHit and CurTime() - self:GetCreationTime() < 30 and not selfTbl.fired then
		if MelonWars.teamCredits[selfTeam] then
			MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam] + selfTbl.value
		end
		for _, v in ipairs( player.GetAll() ) do
			if v:GetInfoNum("mw_team", -1) == selfTeam and selfTeam ~= 0 then
				net.Start("MW_TeamCredits")
					net.WriteInt(MelonWars.teamCredits[selfTeam] ,32)
				net.Send(v)
			end
		end
	end
end

function MelonWars.updatePopulation( amount, teamID )
	if amount ~= 0 and teamID and teamID ~= 0 then
		MelonWars.teamUnits[teamID] = MelonWars.teamUnits[teamID] + amount

		for i, v in ipairs(player.GetAll()) do
			if v:GetInfoNum("mw_team", -1) == teamID then
				net.Start( "MW_TeamUnits" )
					net.WriteInt( MelonWars.teamUnits[teamID], 16 )
				net.Send( v )
			end
		end
	end
end

function ENT:BarrackInitialize ()
	self.moveType = MOVETYPE_NONE

	self.canMove = false
	self.canShoot = false

	self:SetNWBool("active", true)
	self.unitspawned = true
	self:SetNWInt("count", 0)

	self:SetNWFloat("overdrive", 0)

	self:SetNWBool("spawned", self.unitspawned)
	self.slowThinkTimer = 3

	local rotatedSpawnOffset = Vector(150,0,0)
	rotatedSpawnOffset:Rotate(self:GetAngles())
	self:SetVar("targetPos", self:GetPos() + rotatedSpawnOffset)
	self:SetNWVector("targetPos", self:GetPos() + rotatedSpawnOffset)

	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self.melons = {}

	self.population = 5

	if (self.unit ~= nil) then
		self.slowThinkTimer = MelonWars.units[self.unit].spawn_time * 3
		self.unit_class = MelonWars.units[self.unit].class
		self.unit_cost = MelonWars.units[self.unit].cost / 2
	end

	self:SetNWFloat("slowThinkTimer", self.slowThinkTimer)
	self:SetNWFloat("nextSlowThink", CurTime())
end

local function EnoughPower(_team)
	if _team > 0 then
		return MelonWars.teamUnits[_team] < cvars.Number("mw_admin_max_units")
	end
	return true
end

function ENT:BarrackSlowThink() --TODO: Optimize
	local ent = self

	if (not (IsValid(self.parent) or self.parent == nil or self.parent:IsWorld())) then
		self.gotHit = true
		self.HP = self.HP-50
		self:SetNWFloat( "healthFrac", selfTbl.HP / selfTbl.maxHP )
		self.damage = 0
		if (self.HP <= 0) then
			MelonWars.die( self )
		end
	end

	if self.spawned == false then return end
	if not mw_admin_playing_cv:GetBool() then return end
	if not self.unitspawned then
		if (self:GetNWFloat("nextSlowThink") < CurTime()+self:GetNWFloat("overdrive", 0)) then
			if (EnoughPower(ent:GetNWInt("mw_melonTeam", 0))) then
				self:SetNWFloat("overdrive", 0)
				local newMarine = ents.Create( self.unit_class )
				if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail
				local rotatedShotOffset = Vector(ent.shotOffset.x, ent.shotOffset.y, ent.shotOffset.z)
				rotatedShotOffset:Rotate(self:GetAngles())
				newMarine:SetPos( ent:GetPos() + Vector(0,0,20) + rotatedShotOffset)

				sound.Play( "doors/door_latch1.wav", ent:GetPos(), 75, 150, 1 )

				mw_melonTeam = ent:GetNWInt("mw_melonTeam", 0)

				newMarine:Spawn()
				newMarine:SetNWInt("mw_melonTeam", ent:GetNWInt("mw_melonTeam", 0))
				newMarine:Ini(ent:GetNWInt("mw_melonTeam", 0))

				for i=1, 30 do
					newMarine.rallyPoints[i] = self.rallyPoints[i]
				end

				if (cvars.Bool("mw_admin_credit_cost")) then
					newMarine.value = self.unit_cost
				else
					newMarine.value = 0
				end

				if (ent.targetPos == ent:GetPos()) then
					newMarine:SetVar('targetPos', ent:GetPos()+Vector(100,0,0))
					newMarine:SetNWVector('targetPos', ent:GetPos()+Vector(100,0,0))
				else
					newMarine:SetVar('targetPos', ent.targetPos+Vector(0,0,1))
					newMarine:SetNWVector('targetPos', ent.targetPos+Vector(0,0,1))
				end
				newMarine:SetVar('moving', true)

				if (IsValid(self:GetOwner())) then
					if (self:GetOwner():GetInfo( "mw_enable_skin" ) == "1") then
						local _skin = MelonWars.specialSteamSkins[self:GetOwner():SteamID()]
						if (_skin ~= nil) then
							if (_skin.material ~= nil) then
								newMarine:SkinMaterial(_skin.material)
							end
							--if (_skin.trail ~= nil) then
							--	local color = Color(newMarine:GetColor().r*_skin.teamcolor+255*(1-_skin.teamcolor), newMarine:GetColor().g*_skin.teamcolor+255*(1-_skin.teamcolor), newMarine:GetColor().b*_skin.teamcolor+255*(1-_skin.teamcolor))
							--	util.SpriteTrail( newMarine, 0, color, false, _skin.startSize, _skin.endSize, _skin.length, 1 / _skin.startSize * 0.5, _skin.trail )
							--end
						end
					end
				end

				table.insert(ent.melons, newMarine)
				undo.Create("Melon Marine")
					undo.AddEntity( newMarine )
					undo.SetPlayer( ent:GetOwner())
				undo.Finish()

				if (self:GetNWBool("active", false)) then
					self.nextSlowThink = CurTime()+self.slowThinkTimer
					self:SetNWFloat("nextSlowThink", self.nextSlowThink)
				end
				self.unitspawned = true
				self:SetNWBool("spawned", self.unitspawned)
			end
		end
	end

	self:SetNWInt("count", 0)
	for k, v in pairs( ent.melons ) do
		if (IsValid(v)) then
			self:SetNWInt("count", self:GetNWInt("count", 0)+1)
		else
			table.remove(ent.melons, k)
		end
	end

	if (self:GetNWBool("active", false)) then
		if self.unitspawned == false then return end
		if (self:GetNWInt("count", 0) < self:GetNWInt("maxunits", 0) and EnoughPower(self:GetNWInt("mw_melonTeam", -1))) then
			if not (MelonWars.teamCredits[ent:GetNWInt("mw_melonTeam", 0)] >= self.unit_cost or not cvars.Bool("mw_admin_credit_cost")) then return end
			-- Start Production
			--self:SetNWBool("spawned", false)

			if (cvars.Bool("mw_admin_credit_cost")) then
				MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)]-self.unit_cost
				for k, v in pairs( player.GetAll() ) do
					if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
						net.Start("MW_TeamCredits")
							net.WriteInt(MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
						net.Send(v)
					end
				end
			end

			self.nextSlowThink = CurTime()+self.slowThinkTimer
			self:SetNWFloat("nextSlowThink", self.nextSlowThink)
			self.unitspawned = false
			self:SetNWBool("spawned", self.unitspawned)
		else
			self.unitspawned = true
			self:SetNWBool("spawned", self.unitspawned)
		end
	--else
	--	self.nextSlowThink = CurTime()+1
	--	self:SetNWFloat("nextSlowThink", self.nextSlowThink)
	--	self.unitspawned = false
	--	self:SetNWBool("spawned", self.unitspawned)
	end
end

function ENT:PlayHudSound(sndFile, volume, pitch, _team)
	local toAll = false
	if _team == nil then
		toAll = true
	end
	for _, v in ipairs( player.GetAll() ) do
		if toAll or v:GetInfoNum("mw_team", 0) == _team then
			local snd = CreateSound( v, sndFile )
			snd:PlayEx( volume, pitch )
		end
	end
end