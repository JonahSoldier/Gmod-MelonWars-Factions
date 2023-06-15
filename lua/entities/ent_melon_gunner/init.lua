AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/Roller.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.speed = 70
	self.spread = 10
	self.damageDeal = 2
	self.maxHP = 54
	self.range = 250

	self.population = 2
	self.buildingDamageMultiplier = 0.8

	self.sphereRadius = 9

	self.shotSound = "weapons/ar1/ar1_dist2.wav"
	self.tracer = "AR2Tracer"

	self.slowThinkTimer = 1
	self.spinup = 3
	self.maxspinup = 4
	self.minspinup = 1

	self:Setup()
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	self.slowThinkTimer = self.spinup
	if (self.spinup < self.maxspinup) then
		self.spinup = self.spinup + 0.2
		if (self.spinup > self.maxspinup) then
			self.spinup = self.maxspinup
		end
	end
	MelonWars.unitDefaultThink ( ent )
end

function ENT:Shoot ( ent, forcedTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		MelonWars.defaultShoot ( ent, forcedTargetPos )
		ent.nextControlShoot = CurTime()+ent.slowThinkTimer
		for i = 1, 2 do
			timer.Simple( i*self.spinup/3, function()
				if (IsValid(ent)) then
					MelonWars.defaultShoot ( ent, forcedTargetPos )
				end
			end)
		end
		local target = ent.targetEntity
		if (target.Base == "ent_melon_base" or target.Base == "ent_melon_energy_base" or target:GetClass() == "ent_melon_wall") then
			if (self.spinup > self.minspinup) then
				self.spinup = self.spinup - 0.6
				if (self.spinup < self.minspinup) then
					self.spinup = self.minspinup
				end
			end
		end
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end