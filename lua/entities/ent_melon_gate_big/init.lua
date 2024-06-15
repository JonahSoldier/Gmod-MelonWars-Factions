AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_phx/construct/metal_plate2x4.mdl"--"models/props_c17/TrapPropeller_Engine.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 200
	self.force = 100

	self.closedpos = self:GetPos()
	self.openedpos = self:GetPos() + Vector(0,0,150)

	self.maxHP = 250

	self.open = false
	self:SetNWBool("open", self.open)
	self.process = 0
	self.population = 0

	self.capacity = 0
	self:SetNWVector("energyPos", vector_origin)

	self.damping = 4

	MelonWars.energySetup ( self )

	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2+50, self:GetColor().g/2+50, self:GetColor().b/2+50, 255))
end

function ENT:SlowThink ( ent )
	--MelonWars.unitDefaultThink ( ent )
end

function ENT:Actuate ()
	self.process = 5-self.process
	self.open = not self.open
	self:SetNWBool("open", self.open)
end

function ENT:Update()
	local selfTbl = self:GetTable()
	if selfTbl.process > 0 and self:DrainPower(1) then
		selfTbl.process = math.max(selfTbl.process - 0.2, 0)

		local percent = selfTbl.process / 5
		if not selfTbl.open then
			self:SetPos(selfTbl.openedpos * percent + selfTbl.closedpos * (1-percent))
		else
			self:SetPos(selfTbl.openedpos * (1-percent) + selfTbl.closedpos * percent)
		end
	end
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end