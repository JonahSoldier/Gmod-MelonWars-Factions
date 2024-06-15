AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/FurnitureBoiler001a.mdl"
	self.speed = 80
	self.spread = 10
	self.damageDeal = 4
	self.maxHP = 100
	self.range = 400
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"
	self.shotOffset = Vector(0,0,30)

	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 0.5
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))

	MelonWars.energySetup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:SlowThink ( ent ) --TODO: Refactor
	local energyCost = 15
	if (MelonWars.electricNetwork[self.network].energy >= energyCost) then
		local entities = ents.FindInSphere( ent:GetPos(), ent.range )
		--------------------------------------------------------Disparar
		local maxtargets = 3

		local foundEntities = {}
		for k, v in pairs(entities) do
			local tr = util.TraceLine( {
				start = self:GetPos()+self:GetVar("shotOffset", Vector(0,0,0)),
				endpos = v:GetPos()+v:GetVar("shotOffset", Vector(0,0,0)),
				filter = function( foundEnt )
					if ( foundEnt == self ) then return false end
					if ( foundEnt.Base == "ent_melon_base" or v.Base == "ent_melon_energy_base" or v.Base == "ent_melon_prop_base" or foundEnt:GetClass() == "prop_physics") then--si hay un prop en el medio
						return false
					end
					return true
				end
			})
			if tostring(tr.Entity) == '[NULL Entity]' then
				if ((v.Base == "ent_melon_base" or v.Base == "ent_melon_energy_base" or v.Base == "ent_melon_prop_base" or v:GetClass() == "prop_physics" )and not ent:SameTeam(v)) then -- si no es un aliado
					table.insert(foundEntities, v)
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
			if (self:DrainPower(energyCost)) then
			----------------------------------------------------------Encontró target

				if (v:GetClass() == "prop_physics" or v.Base == "ent_melon_prop_base") then
					v:TakeDamage( self.damageDeal, self, self )
					local php = v:GetNWInt("propHP", -1)
					if (php ~= -1) then
						v:SetNWInt("propHP", php-self.damageDeal)
					end
				else
					v.damage = v.damage+self.damageDeal
				end
				local effectdata = EffectData()
				effectdata:SetScale(3000)
				effectdata:SetMagnitude(3000)
				effectdata:SetStart( self:GetPos() + Vector(0,0,45))
				effectdata:SetOrigin( v:GetPos() )
				util.Effect( "AirboatGunTracer", effectdata )
				sound.Play( ent.shotSound, ent:GetPos() )
				v:TakeDamage( self.damageDeal, self, self)
			end
		end
	end
	--self:Energy_Set_State()
end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end