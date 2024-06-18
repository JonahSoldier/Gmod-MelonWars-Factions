AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/props_lab/teleplatform.mdl"
	self.moveType = MOVETYPE_NONE
	self.canMove = false
	self.canShoot = false
	self.maxHP = 75
	self.shotOffset = Vector(0,0,10)

	self.slowThinkTimer = 0.5

	self.population = 1

	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"
	self:SetNWBool("active", false)

	self:Setup()
end

function ENT:SlowThink(ent)
	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	local selfPos = self:GetPos()
	local closest = nil
	local closestDist = math.huge

	for i, v in ipairs(ents.FindByClass( "ent_melon_teleporter_receiver" )) do
		if selfTeam == v:GetNWInt("mw_melonTeam", -1) then
			local dist = selfPos:DistToSqr(v:GetPos())
			if dist < closestDist then
				closestDist = dist
				closest = v
			end
		end
	end

	local valid = IsValid(closest)
	self:SetNWBool("active", valid)
	if valid then
		local foundEnts = ents.FindInSphere(selfPos, 50)
		local closestPos = closest:GetPos() + Vector(0,0,35)
		local newTargetPos = closest.targetPos or vector_origin
		for i, v in ipairs(foundEnts) do
			if v.canMove and v.Base == "ent_melon_base" then
				local effectdata = EffectData()
				effectdata:SetScale(1)
				effectdata:SetMagnitude(1)
				effectdata:SetStart( v:GetPos())
				effectdata:SetOrigin( closestPos )
				util.Effect( "ToolTracer", effectdata )
				sound.Play( "NPC_CombineBall.Launch", selfPos )

				v:SetPos(closestPos + VectorRand(-25, 25))
				if IsValid(v.phys) then
					v.phys:Wake()
				end
				v:PhysicsUpdate()

				v.lastPosition = closestPos
				v:SetNWVector("targetPos", newTargetPos)
				v.targetPos = newTargetPos
				v.moving = true
				v.stuck = 0
				v.rallyPoints = table.Copy(closest.rallyPoints)
			end
		end
	end
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end