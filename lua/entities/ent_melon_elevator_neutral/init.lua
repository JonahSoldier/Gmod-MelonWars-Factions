AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/tubes/circle2x2.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self.canMove = false
	self.canShoot = false

	self.active = true

	self.melons = {}
end

function ENT:Think()
	local foundEnts = ents.FindInSphere( self:GetPos()+Vector(0,0,0), 45 )
	local newFoundEnts = ents.FindInSphere( self:GetPos()+Vector(0,0,60), 45 )
	table.Add(foundEnts, newFoundEnts)
	newFoundEnts = ents.FindInSphere( self:GetPos()+Vector(0,0,120), 45 )
	table.Add(foundEnts, newFoundEnts)
	newFoundEnts = ents.FindInSphere( self:GetPos()+Vector(0,0,180), 45 )
	table.Add(foundEnts, newFoundEnts)
	newFoundEnts = ents.FindInSphere( self:GetPos()+Vector(0,0,240), 45 )
	table.Add(foundEnts, newFoundEnts)
	for _, v in ipairs( foundEnts ) do
		if v.Base == "ent_melon_base" then
			if v.canMove then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(Vector(0,0,150))
				end
			end
		end
	end

	self:NextThink( CurTime() + 1.5 )
end

function ENT:DeathEffect( ent )
	MelonWars.defaultDeathEffect( ent )
end