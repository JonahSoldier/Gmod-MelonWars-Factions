AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

local mw_admin_playing_cv = GetConVar("mw_admin_playing")

function ENT:Initialize()
	MelonWars.defaults( self )

	self.maxHP = 15
	self.speed = 125

	self.modelString = "models/props_junk/watermelon01.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.population = 1

	self.height = self:GetPos().z
	self.delayedForce = 0

	self.dropdown = 0

	self.sphereRadius = 7

	self.captureSpeed = 2

	self:Setup()

	self:GetPhysicsObject():EnableGravity( false )
end

function ENT:SpecificThink()
	self.phys:Wake()
end

function ENT:ModifyColor()
	self:SetColor( Color( self:GetColor().r / 2, self:GetColor().g / 2, self:GetColor().b / 2, 255 ) )
end

function ENT:SlowThink( ent )
	if not mw_admin_playing_cv:GetBool() then return end
	MelonWars.unitDefaultThink( ent )
	self.dropdown = math.max(self.dropdown -1, 0)

	if ent:GetPos():Distance( ent.targetPos ) < 160 then
		self:FinishMovement()
	end
end

function ENT:Shoot( ent, forcedTargetPos )
	if not ent.ai or CurTime() > ent.nextControlShoot then return end
	MelonWars.defaultShoot( ent, forcedTargetPos )
	ent.nextControlShoot = CurTime() + ent.slowThinkTimer
end

function ENT:DeathEffect( ent )
	MelonWars.defaultDeathEffect( ent )
end

function ENT:Unstuck()
	if self.dropdown ~= 0 then return end
	self.dropdown = 2
end

function ENT:PhysicsUpdate()
	if not mw_admin_playing_cv:GetBool() then
		self.phys:Sleep()
		return
	end

	self:DefaultPhysicsUpdate()

	local hoverdistance = 150
	local hoverforce = 1

	local selfTbl = self:GetTable()
	local phys = selfTbl.phys
	local selfPos = self:GetPos()
	local tr = util.TraceLine( {
		start = selfPos,
		endpos = selfPos + Vector(0,0,-hoverdistance * 2),
		filter = function( ent )
			local ph = ent:GetPhysicsObject()
			return IsValid(ph) and not ph:IsMoveable()
		end,
		mask = bit.bor(MASK_SOLID,MASK_WATER)
	} )

	if not IsValid(tr.Entity) or not(tr.Entity.Base == "ent_melon_base" or tr.Entity.Base == "ent_melon_energy_base" or tr.Entity.Base == "ent_melon_prop_base") then
		selfTbl.height = tr.HitPos.z
	end

	local force = 0
	local distance = selfPos.z - selfTbl.height

	if selfTbl.dropdown > 0 then
		hoverdistance = 50
	end

	if distance < hoverdistance then
		force = -(distance-hoverdistance) * hoverforce
		local physVel = phys:GetVelocity()
		physVel.x, physVel.y, physVel.z = 0, 0, -physVel.z * 0.8
		phys:ApplyForceCenter(physVel)
	else
		force = -1
	end

	selfTbl.delayedForce = (selfTbl.delayedForce * 2 + force) / 3

	phys:ApplyForceCenter(Vector(0,0,selfTbl.delayedForce))
end