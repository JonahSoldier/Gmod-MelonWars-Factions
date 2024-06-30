AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_phx/construct/metal_plate1x2.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.canShoot = true
	self.speed = 200
	self.force = 100

	self.closedpos = self:GetPos()
	self.openedpos = self:GetPos()+Vector(0,0,80)

	self.maxHP = 50
	self.population = 0
	self.open = false
	self:SetNWBool("open", self.open)
	self.process = CurTime()

	self.damping = 4

	self:Setup()

	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2+50, self:GetColor().g/2+50, self:GetColor().b/2+50, 255))
end

function ENT:SlowThink ( ent )
end

function ENT:Actuate ()
	if (self.process <= CurTime()) then
		self.process = CurTime()+5
		self.open = not self.open
		self:SetNWBool("open", self.open)
	end
end

function ENT:Update()
	if (self.process >= CurTime()) then
		local percent = (self.process-CurTime())/5
		if not self.open then
			self:SetPos(self.openedpos*percent+self.closedpos*(1-percent))
		else
			self:SetPos(self.openedpos*(1-percent)+self.closedpos*(percent))
		end
	end
end

function ENT:Shoot ( ent )
	--MelonWars.defaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end