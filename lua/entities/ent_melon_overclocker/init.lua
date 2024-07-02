AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_combine/combine_light001a.mdl"
	self.maxHP = 100
	self.Angles = Angle(0,0,0)
	self.canMove = false
	self.moveType = MOVETYPE_NONE
	self.connections = {}

	self.range = 50

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", vector_origin)
	self.population = 0
	self.canBeSelected = false

	MelonWars.energySetup ( self )

	self.connection = nil

	self:SetNWBool("active", true)
	self:SetNWFloat("overdrive", 0)

	self:GetPhysicsObject():EnableMotion(false)

	self:NextThink(CurTime() + 1)
	timer.Simple(0.1, function () self:ConnectToBarrack() end)
end

function ENT:ConnectToBarrack()
	local selfTeam = self:GetNWInt("mw_melonTeam", 0)
	local selfPos = self:GetPos()

	local closestEntity = nil
	local closestDistance = math.huge

	for i, v in ipairs(ents.FindInSphere( selfPos, self.range )) do
		if v.isBarracks and v:GetNWInt("mw_melonTeam", 0) == selfTeam then
			local distSqr = selfPos:DistToSqr( v:GetPos() )
			if distSqr < closestDistance then
				closestEntity = v
				closestDistance = distSqr
			end
		end
	end

	if closestEntity then
		self.connection = closestEntity
		self.slowThinkTimer = closestEntity.slowThinkTimer / 10
		constraint.Rope( self, closestEntity, 0, 0, Vector(0,0,10), Vector(0,0,5), selfPos:Distance(closestEntity:GetPos()), 0, 0, 10, "cable/physbeam", false )
	else
		MelonWars.broadcastTeamMessage(selfTeam, "== Over-Clockers must be spawned next to Barracks! ==")
		self:Remove()
	end
end

function ENT:SlowThink(ent)
	local selfTbl = self:GetTable()
	if not IsValid(selfTbl.connection) then
		self:DeathEffect( self )
		return
	end

	local barracks = selfTbl.connection
	if self:GetNWBool("active", true) and (not barracks:GetNWBool("spawned", false) or barracks:GetClass() == "ent_melon_contraption_assembler") and barracks:GetNWBool("active", false) then
		if self:DrainPower(selfTbl.slowThinkTimer * 10) then
			barracks:SetNWFloat("overdrive", barracks:GetNWFloat("overdrive", 0) + selfTbl.slowThinkTimer / 2)
		end
	end
end


function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:BarrackSlowThink()
end