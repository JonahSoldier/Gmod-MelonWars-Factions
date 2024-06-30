AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_transformer01d.mdl"
	self.moveType = MOVETYPE_NONE
	self.slowThinkTimer = 2.0
	self.canMove = false
	self.canShoot = false
	self.range = 250
	self.population = 3
	self.connection = nil
	self.careForFriendlyFire = false
	self.careForWalls = false
	self.shotSound = ""

	--self:SetPos(self:GetPos()+Vector(0,0,-5))
	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,15)

	MelonWars.energySetup ( self )
end

function ENT:ModifyColor()
	--self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SlowThink ( ent )
	if not self.unitspawned then
		local newMarine = ents.Create( "ent_melon_forcefield" )
		if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail
		local rotatedShotOffset = Vector(ent.shotOffset.x, ent.shotOffset.y, ent.shotOffset.z)
		rotatedShotOffset:Rotate(self:GetAngles())
		newMarine:SetPos( ent:GetPos() +  rotatedShotOffset)

		sound.Play( "d3_citadel.zapper_warmup", ent:GetPos(), 75, 150, 1 )

		mw_melonTeam = ent:GetNWInt("mw_melonTeam", 0)

		newMarine:SetParent(self)

		newMarine:Spawn()
		newMarine:SetNWInt("mw_melonTeam", ent:GetNWInt("mw_melonTeam", 0))
		newMarine:Ini(ent:GetNWInt("mw_melonTeam", 0))

		newMarine.value = 0

		self.unitspawned = true
	end

	local chargeAmount = 50

	if (MelonWars.electricNetwork[self.network].energy >= chargeAmount) then
		local entities = ents.FindInSphere( ent:GetPos(), ent.range )
		--------------------------------------------------------Disparar
		local targets = 0
		local maxtargets = 1

		local foundEntities = {}
		for k, v in pairs(entities) do
			local tr = util.TraceLine( {
				start = self:GetPos()+self:GetVar("shotOffset", Vector(0,0,0)),
				endpos = v:GetPos()+v:GetVar("shotOffset", Vector(0,0,0)),
				filter = function( foundEnt )
					if ( foundEnt == self) then--si hay un prop en el medio
						return false
					end
					if ( foundEnt.Base == "ent_melon_base" or foundEnt:GetClass() == "prop_physics") then--si hay un prop en el medio
						return false
					end
					return true
				end
			})
			if (tostring(tr.Entity) == '[NULL Entity]') then
				if ((v:GetClass() == "ent_melon_forcefield") and (ent:SameTeam(v) or v:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0))) then -- si no es un aliado
					if (v.spawned) then
						if (v:GetNWInt("mw_charge", -1) > -1) then
							if (v:GetNWInt("mw_charge", 0) < v:GetNWInt("maxCharge", 0)) then
								table.insert(foundEntities, v)
							end
						end
					end
				end
			end
		end

		local closestEntities = {}
		for i=1, maxtargets do
			local closestDistance = 0
			local closestEntity = nil
			for k, v in pairs(foundEntities) do
				if (closestEntity == nil or ent:GetPos():DistToSqr( v:GetPos() ) < closestDistance) then
					closestEntity = v
					closestDistance = ent:GetPos():DistToSqr( v:GetPos() )
				end
			end
			table.RemoveByValue(foundEntities, closestEntity)
			table.insert(closestEntities, closestEntity)
		end

		for k, v in pairs(closestEntities) do
			if (self:DrainPower(chargeAmount)) then
				ent.targetEntity = v
				ent:Shoot(ent)
			end
		end
	end

	self:Energy_Set_State()
end

function ENT:Shoot ( ent )
	--------------------------------------------------------Disparar
	if (ent.targetEntity == ent) then ent.targetEntity = nil end
	if (IsValid(ent.targetEntity)) then
		if (ent.targetEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or ent:SameTeam(ent.targetEntity)) then
			local pos = ent:GetPos()+ent.shotOffset
			local targetPos = ent.targetEntity:GetPos()
			if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
				targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
			end
			--ent:FireBullets(bullet)
			local effectdata = EffectData()
			effectdata:SetScale(3000)
			effectdata:SetMagnitude(3000)
			effectdata:SetStart( self:GetPos() + Vector(0,0,45))
			effectdata:SetOrigin( targetPos )
			util.Effect( "AirboatGunTracer", effectdata )
			sound.Play( ent.shotSound, ent:GetPos() )

			local chargeAmount = 100
			ent.targetEntity:SetNWInt("mw_charge",ent.targetEntity:GetNWInt("mw_charge",0)+chargeAmount)
			ent.fired = true
			if (ent.targetEntity:GetNWInt("mw_charge",0) >= ent.targetEntity:GetNWInt("maxCharge",0)) then
				ent.targetEntity:SetNWInt("mw_charge",ent.targetEntity:GetNWInt("maxCharge",0))
				ent.targetEntity = nil
			end
		else
			ent.targetentity = nil
		end
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end