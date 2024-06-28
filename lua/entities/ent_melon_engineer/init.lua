AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_wasteland/light_spotlight01_lamp.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.damageDeal = 4
	self.maxHP = 45
	self.weight = 25

	self.speed = 60

	self.population = 1

	self.captureSpeed = 1

	self.shotSound = "EpicMetal.ImpactHard"

	self:Setup()
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:PhysicsUpdate()
	local inclination = self:Align(self:GetAngles():Forward()*-1, Vector(0,0,-1), 1000)
	local front = self:GetUp():Cross(self:GetRight())

	self.phys:SetAngleVelocity( front * 500 * inclination)

	self:DefaultPhysicsUpdate()
end


function ENT:SlowThink ( ent )
	local selfTbl = self:GetTable()

	if not selfTbl.targetEntity then
		local selfTeam = self:GetNWInt("mw_melonTeam", -1)
		local function validCheck(thisEnt, targEnt)
			local targEntTbl = targEnt:GetTable()
			return (targEntTbl.Base == "ent_melon_base" or targEntTbl.Base == "ent_melon_energy_base") and targEntTbl.spawned and not targEntTbl.canMove and targEntTbl.HP < targEntTbl.maxHP and not string.StartWith(targEnt:GetClass(), "ent_melon_main_" ) and MelonWars.sameTeam(selfTeam, targEnt:GetNWInt("mw_melonTeam", -1))
		end

		local foundEntities = MelonWars.FindTargets( self, true, validCheck )
		selfTbl.targetEntity = foundEntities[ math.random(1, #foundEntities) ]
	else
		local targEnt = selfTbl.targetEntity
		local pos = self:GetPos()

		if not IsValid(targEnt) or targEnt:GetPos():DistToSqr(pos) > selfTbl.range ^ 2 then
			selfTbl.targetEntity = nil
			selfTbl.nextSlowThink = CurTime() + 0.1
			return false
		end

		local tr = util.TraceLine( {
			start = pos,
			endpos = selfTbl.targetEntity:GetPos(),
			filter = function( foundEntity )
				return foundEntity:GetClass() == "prop_physics"
			end
		})
		if tr.Entity:IsValid() then
			selfTbl.targetEntity = nil
			selfTbl.nextSlowThink = CurTime() + 0.1
			return false
		end
	end

	local healed = false
	if selfTbl.targetEntity and selfTbl.targetEntity.HP < selfTbl.targetEntity.maxHP then
		healed = self:Shoot( selfTbl.targetEntity )
	end

	if not healed  then -- SELF HEAL
		selfTbl.HP = math.min(selfTbl.HP + 1, selfTbl.maxHP)
		self:SetNWFloat( "healthFrac", selfTbl.HP / selfTbl.maxHP )
	end
end

function ENT:Shoot ( ent )
	local selfTbl = self:GetTable()
	if not(selfTbl.ai or CurTime() > selfTbl.nextControlShoot) then return false end

	if selfTbl.targetEntity == self then selfTbl.targetEntity = nil end
	if not IsValid(selfTbl.targetEntity) then return false end
	local targetEnt = selfTbl.targetEntity
	local targetEntTbl = targetEnt:GetTable()

	if not self:SameTeam(targetEnt) then
		selfTbl.targetentity = nil
		return false
	end

	local heal = math.min(selfTbl.damageDeal, targetEntTbl.maxHP - targetEntTbl.HP)
	if heal >= selfTbl.HP then return false end

	targetEntTbl.HP =  targetEntTbl.HP + heal
	targetEnt:SetNWFloat("healthFrac", targetEntTbl.HP / targetEntTbl.maxHP)
	selfTbl.fired = true
	if targetEntTbl.HP == targetEntTbl.maxHP then
		selfTbl.targetEnt = nil
	end
	selfTbl.damage = heal


	local pos = self:GetPos() + selfTbl.shotOffset
	local targetPos = targetEnt:GetPos()
	if targetEntTbl.shotOffset then
		targetPos = targetPos + targetEntTbl.shotOffset
	end

	local effectdata = EffectData()
	effectdata:SetOrigin( targetPos + Vector(0,0,10) )
	for i = 1, 5, 1 do
		util.Effect( "inflator_magic", effectdata )
	end
	effectdata:SetOrigin( pos + Vector(0,0,10) )
	util.Effect( "inflator_magic", effectdata )
	sound.Play( selfTbl.shotSound, pos )

	selfTbl.nextControlShoot = CurTime() + selfTbl.slowThinkTimer
	return true
end


function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end