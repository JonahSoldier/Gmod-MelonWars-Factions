AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_lab/teleportbulkeli.mdl"
	self.maxHP = 1250

	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", true)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))
	self.shotOffset = Vector(0,0,30)

	MelonWars.energySetup ( self )
end

function ENT:Think(ent)
	local selfTbl = self:GetTable()
	if not(selfTbl.spawned and self:GetNWBool("active", false)) then
		self:NextThink( CurTime() + 1 )
		return
	end

	if self:GivePower(250) then
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() + Vector(0,0,55))
		util.Effect( "ManhackSparks", effectdata )
	end

	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:SlowThink(ent)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	timer.Simple( 0.02, function()
		if not IsValid(ent) then return end

		util.BlastDamage( ent, ent, ent:GetPos(), 600, 800 )
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		util.Effect( "VortDispel", effectdata )

		effectdata:SetOrigin( ent:GetPos() + Vector(0,0,300))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(0,300,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(300,0,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(0,-300,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(-300,0,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(150,150,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(-150,150,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(150,-150,0))
		util.Effect( "Explosion", effectdata )
		effectdata:SetOrigin( ent:GetPos() + Vector(-150,-150,0))
		util.Effect( "Explosion", effectdata )

		local pos1 = ent:GetPos() -- Set worldpos 1. Add to the hitpos the world normal.
		local pos2 = ent:GetPos() + Vector(0,0,-20) -- Set worldpos 2. Subtract from the hitpos the world normal.
		ent.fired = true
		ent:Remove()

		util.Decal("Scorch",pos1,pos2)
	end)
end