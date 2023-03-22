AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_rooftop/antennaclusters01a.mdl"
	self.spread = 10
	self.damageDeal = 2
	self.maxHP = 35
	self.range = 80
	self.sphereRadius = 0
	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"
	self.shotOffset = Vector(0,0,50.25) --Originally 30, increased to spite mortars.

	self.canMove = false
	self.canBeSelected = false
	self.moveType = MOVETYPE_NONE

	self.population = 0

	self.slowThinkTimer = 0.75

	self:Setup()

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)
	self:SetNotSolid(true)
end


function ENT:SlowThink ( ent )

	local entities = ents.FindInSphere( ent:GetPos(), ent.range )
	--------------------------------------------------------Disparar
	local targets = 0
	local maxtargets = 15

	local foundEntities = {}
	for k, v in pairs(entities) do
		local tr = util.TraceLine( {
			start = self:GetPos()+self:GetVar("shotOffset", Vector(0,0,0)),
			endpos = v:GetPos()+v:GetVar("shotOffset", Vector(0,0,0)),
			filter = function( foundEnt )
				if ( foundEnt == self ) then return false end
				if ( foundEnt.Base == "ent_melon_base" or foundEnt:GetClass() == "prop_physics") then--si hay un prop en el medio
					return false
				end
				return true
			end
		})
		if (tostring(tr.Entity) == '[NULL Entity]') then
			if (v.Base == "ent_melon_base" and not ent:SameTeam(v)) then -- si no es un aliado
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
		----------------------------------------------------------Encontró target
		v.damage = v.damage+self.damageDeal
		/*local effectdata = EffectData()
		effectdata:SetScale(3000)
		effectdata:SetMagnitude(3000)
		effectdata:SetStart( self:GetPos() + Vector(0,0,45))
		effectdata:SetOrigin( v:GetPos() )
		util.Effect( "AirboatGunTracer", effectdata )*/
		sound.Play( ent.shotSound, ent:GetPos() )
		self:DischargeEffect()
	end
end

function ENT:DischargeEffect()
	--print("test")

	local discharge = ents.Create("point_tesla")

	discharge:SetPos(self:GetPos() + Vector(math.Rand( -25, 25 ), math.Rand( -25, 25 ), math.Rand( -10, 10 )))
	discharge:SetKeyValue("texture", "trails/laser.vmt")
	discharge:SetKeyValue("m_Color", "255 255 255")
	discharge:SetKeyValue("m_flRadius", tostring(self.range*1.2))
	discharge:SetKeyValue("interval_min", tostring(0))
	discharge:SetKeyValue("interval_max", tostring(1))
	discharge:SetKeyValue("beamcount_min", tostring(1))
	discharge:SetKeyValue("beamcount_max", tostring(3))
	discharge:SetKeyValue("thick_min", tostring(3))
	discharge:SetKeyValue("thick_max", tostring(5))
	discharge:SetKeyValue("lifetime_min", tostring(0.1))
	discharge:SetKeyValue("lifetime_max", tostring(0.15))

	discharge:Spawn()
	discharge:Activate()

	discharge:Fire("DoSpark", "", 0)
	discharge:Fire("TurnOn", "", 0)

	timer.Simple(0.1, function() discharge:Remove()  end)
end


function ENT:Shoot ( ent )
end
--[[
function MW_CleanUp_Network() --This unit is still being counted as an energy unit for some reason so I have to do this for it to reduce power/not cause script errors when removed
end
]]
function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end