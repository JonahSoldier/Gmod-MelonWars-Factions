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
	local chargeAmount = 50

	if MelonWars.electricNetwork[self.network].energy >= chargeAmount then
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
			if v and self:DrainPower(chargeAmount) then --TODO: Wastes energy. Fix that. It makes low-energy units like gatlings difficult to use effectively.
				self.targetEntity = v
				self:Shoot( self )
			end
		end
	end
end

function ENT:Shoot ( ent ) --TODO: Refactor
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