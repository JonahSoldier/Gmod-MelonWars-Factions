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

function ENT:SlowThink ( ent )
	local energyCost = 15
	local selfTbl = self:GetTable()
	if (MelonWars.electricNetwork[selfTbl.network].energy >= energyCost) then
		local maxtargets = 3

		local foundEntities = MelonWars.FindTargets( self, false )

		local selfPos = self:GetPos()
		table.sort(foundEntities, function(a, b)
			return selfPos:DistToSqr(a:GetPos()) < selfPos:DistToSqr(b:GetPos())
		end)

		for i = 1, maxtargets, 1 do
			local v = foundEntities[i]
			if v and self:DrainPower(energyCost) then
				local effectdata = EffectData()
				effectdata:SetScale(3000)
				effectdata:SetMagnitude(3000)
				effectdata:SetStart( self:GetPos() + Vector(0,0,45))
				effectdata:SetOrigin( v:GetPos() )
				util.Effect( "AirboatGunTracer", effectdata )
				sound.Play( ent.shotSound, ent:GetPos() )
				v:TakeDamage( selfTbl.damageDeal, self, self)
			end
		end
	end
end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end