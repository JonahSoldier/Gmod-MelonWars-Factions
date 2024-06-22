AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_c17/substation_transformer01d.mdl"

	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 2.5

	self.canMove = false
	self.canShoot = false

	self.range = 250

	self.population = 1

	self.shotSound = "weapons/stunstick/stunstick_impact1.wav"

	self.connection = nil
	self.careForFriendlyFire = false
	self.careForWalls = false

	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,15)

	MelonWars.energySetup ( self )
end

function ENT:ModifyColor()
end

function ENT:SlowThink ( ent )
	local networkEnergy = MelonWars.electricNetwork[self.network].energy
	if networkEnergy > 0 then
		local maxtargets = 5

		local selfTeam = self:GetNWInt("mw_melonTeam", -1)
		local function validCheck(thisEnt, tEnt)
			local tEntTbl = tEnt:GetTable()
			return (tEntTbl.Base == "ent_melon_base" or tEntTbl.Base == "ent_melon_energy_base") and tEntTbl.spawned and MelonWars.sameTeam(selfTeam, tEnt:GetNWInt("mw_melonTeam", -1)) and tEnt:GetNWInt("mw_charge", -1) < tEnt:GetNWInt("maxCharge", -1)
		end

		local foundEntities = MelonWars.FindTargets( self, false, validCheck )

		local selfPos = self:GetPos()
		table.sort(foundEntities, function(a, b)
			return selfPos:DistToSqr(a:GetPos()) < selfPos:DistToSqr(b:GetPos())
		end)

		for i = 1, maxtargets, 1 do
			local v = foundEntities[i]
			if v then
				local tMaxCharge = v:GetNWInt("maxCharge", -1)
				local tCharge = v:GetNWInt("mw_charge", -1)

				local chargeAmount = math.min( tMaxCharge - tCharge, 100, networkEnergy)

				if self:DrainPower( math.ceil(chargeAmount / 2) ) then
					self.targetEntity = v
					self:Shoot( self, tCharge + chargeAmount )
				end
			end
		end
	end
end

function ENT:Shoot ( ent, newCharge )
	if self.targetEntity == self then self.targetEntity = nil end

	if not IsValid(self.targetEntity) then return end --ent.targetEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 0) or
	if  not self:SameTeam(self.targetEntity) then
		self.targetentity = nil
		return
	end

	local pos = self:GetPos() + self.shotOffset
	local targetPos = self.targetEntity:GetPos()
	if self.targetEntity.shotOffset then
		targetPos = targetPos + self.targetEntity.shotOffset
	end

	local effectdata = EffectData()
	effectdata:SetScale( 3000 )
	effectdata:SetMagnitude( 3000 )
	effectdata:SetStart( pos )
	effectdata:SetOrigin( targetPos )
	util.Effect( "AirboatGunTracer", effectdata )
	sound.Play( self.shotSound, pos )

	self.fired = true
	self.targetEntity:SetNWInt("mw_charge", newCharge)
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end