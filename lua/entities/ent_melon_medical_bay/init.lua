AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_phx/wheels/747wheel.mdl"

	self.moveType = MOVETYPE_NONE

	self.slowThinkTimer = 2.5

	self.canMove = false
	self.canShoot = false

	self.range = 750

	self.population = 1

	self.shotSound = "items/medshot4.wav"

	self.connection = nil
	self.careForFriendlyFire = false
	self.careForWalls = false

	self:SetNWVector("energyPos", Vector(0,0,20))

	self.shotOffset = Vector(0,0,15)

	MelonWars.energySetup ( self )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r+120, self:GetColor().g+120, self:GetColor().b+120, 255))
end

function ENT:SlowThink ( ent )
	local selfTbl = self:GetTable()
	if selfTbl.HP < selfTbl.maxHP then
		selfTbl.HP = math.min(selfTbl.HP + 1, selfTbl.maxHP)
		ent:SetNWFloat( "healthFrac", selfTbl.HP / selfTbl.maxHP )
	end

	local energyCost = 10

	if MelonWars.electricNetwork[selfTbl.network].energy < energyCost then return end

	local maxtargets = 10

	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	local function validCheck(thisEnt, targEnt)
		local targEntTbl = targEnt:GetTable()
		return (targEntTbl.Base == "ent_melon_base" or targEntTbl.Base == "ent_melon_energy_base") and targEntTbl.spawned and targEntTbl.HP < targEntTbl.maxHP and MelonWars.sameTeam(selfTeam, targEnt:GetNWInt("mw_melonTeam", -1))
	end

	local foundEntities = MelonWars.FindTargets( self, false, validCheck )

	local entPos = ent:GetPos()
	table.sort(foundEntities, function(a, b)
		return entPos:DistToSqr(a:GetPos()) < entPos:DistToSqr(b:GetPos())
	end)

	for i = 1, maxtargets, 1 do
		if foundEntities[i] and self:DrainPower(energyCost) then
			selfTbl.targetEntity = foundEntities[i]
			ent:Shoot(ent)
		end
	end
end

local effectOffset = Vector(0,0,10)
function ENT:Shoot ( ent )
	local targetEnt = ent.targetEntity
	if targetEnt == ent then targetEnt = nil end
	if not IsValid(targetEnt) then return end

	if not ent:SameTeam(targetEnt) then
		targetEnt = nil
		return
	end

	local pos = ent:GetPos() + ent.shotOffset
	local targetPos = targetEnt:GetPos()
	if targetEnt.shotOffset then
		targetPos = targetPos + targetEnt.shotOffset
	end

	local effectdata = EffectData()
	effectdata:SetOrigin( targetPos + effectOffset )
	for i = 1, 5, 1 do
		util.Effect( "inflator_magic", effectdata )
	end
	effectdata:SetOrigin( pos + effectOffset )
	util.Effect( "inflator_magic", effectdata )
	sound.Play( ent.shotSound, pos )

	local heal = math.min(targetEnt.HP + ent.damageDeal, targetEnt.maxHP)
	targetEnt.HP = heal
	targetEnt:SetNWFloat("healthFrac", heal / targetEnt.maxHP)
	ent.fired = true
	if targetEnt.HP == targetEnt.maxHP then
		targetEnt = nil
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end