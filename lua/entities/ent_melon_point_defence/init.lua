AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_docks/channelmarker02a.mdl"
	self.moveType = MOVETYPE_NONE
	self.slowThinkTimer = 0.1
	self.canMove = false
	self.canShoot = false
	self.range = 300
	self.population = 3
	self.connection = nil
	--self.careForFriendlyFire = false
	--self.careForWalls = false
	--self.shotSound = ""
	self.nextShot = CurTime()

	--self:SetPos(self:GetPos()+Vector(0,0,-5))
	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,23.5)

	MW_Energy_Setup ( self )
end

function ENT:ModifyColor()
	--self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SlowThink ( ent )

	if(self.nextShot<CurTime()) then
		local chargeAmount = 75

		if (mw_electric_network[self.network].energy >= chargeAmount) then
			local entities = ents.FindInSphere( ent:GetPos()+Vector(0,0,200), ent.range )
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
						if ( foundEnt.Base == "ent_melon_base" or foundEnt:GetClass() == "prop_physics" or string.StartWith(v:GetClass(), "ent_melonbullet")) then--si hay un prop en el medio
							return false
						end
						return true
					end
				})
				if (tostring(tr.Entity) == '[NULL Entity]') then
					if (string.StartWith(v:GetClass(), "ent_melonbullet")) then 
						if((v:GetClass() ~= "ent_melonbullet_unit_shell") and (v:GetClass() ~= "ent_melonbullet_particlebeamtracer") and (v:GetClass() ~= "ent_melonbullet_flamerfuel")) then
							table.insert(foundEntities, v)
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
					self.nextShot = CurTime()+5
					if(v:GetClass() == "ent_melonbullet_longboy" or v:GetClass() == "ent_melonbullet_missile") then
						v:Explode()
					end
					v:Remove()
				end
			end
		end

		self:Energy_Set_State()
	end
end

function ENT:Shoot ( ent )
	--------------------------------------------------------Disparar
	if (ent.targetEntity == ent) then ent.targetEntity = nil end
	if (IsValid(ent.targetEntity)) then
		local pos = ent:GetPos()+ent.shotOffset
		local targetPos = ent.targetEntity:GetPos()
		if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
			targetPos = targetPos+ent.targetEntity:GetVar("shotOffset")
		end
		--ent:FireBullets(bullet)
		local effectdata = EffectData()
		effectdata:SetScale(3000)
		effectdata:SetMagnitude(3000)
		effectdata:SetStart( self:GetPos() + Vector(0,0,170)) 
		effectdata:SetOrigin( targetPos )
		util.Effect( "AirboatGunTracer", effectdata )
		sound.Play( "ambient.electrical_random_zap_1", ent:GetPos() )
		sound.Play( "NPC_Strider.Shoot", ent:GetPos() )


		local effectdata2 = EffectData()
		effectdata:SetOrigin( targetPos )
		util.Effect( "Explosion", effectdata )

		local chargeAmount = 100
		ent.fired = true
	else
		ent.targetentity = nil
	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end