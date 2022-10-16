AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	//self:SetPos(self:GetPos()+Vector(0,0,-5))
	
	MW_Defaults ( self )

	self.modelString = "models/props_lab/teleplatform.mdl"
	self.moveType = MOVETYPE_NONE
	//self.Angles = Angle(0,0,0)
	//self:SetPos(self:GetPos()+Vector(0,0,0))
	self.canMove = false
	self.canShoot = false
	self.maxHP = 75
	self.shotOffset = Vector(0,0,10)

	self.active = true
	
	self.slowThinkTimer = 0.5
	
	self.population = 1
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	self.melons = {}

	self:SetNWEntity("transport", nil)

	MW_Setup ( self )
end

function ENT:SlowThink(ent)
	local foundReceivers = ents.FindByClass( "ent_melon_teleporter_receiver" )
	local range = 99999
	local closest = nil
	local distSqr = range*range
	local found = false
	for k, v in pairs( foundReceivers ) do
		if (v:GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", -1)) then
			local thisDistSqr = v:GetPos():DistToSqr(self:GetPos())
			if (thisDistSqr < distSqr) and (v.spawned) then
				closest = v
				distSqr = thisDistSqr
				found = true
			end
		end
	end
	self:SetNWBool("hasTransport", found)
	
	if (found) then
		self:SetNWEntity("transport", closest)
		local foundEnts = ents.FindInSphere( ent:GetPos()+Vector(0,0,0), 50 )
		for k, v in pairs( foundEnts ) do
			if (v.Base == "ent_melon_base") then
				if (v.canMove) then
					local phys = v:GetPhysicsObject()
					if (IsValid(phys)) then
						local effectdata = EffectData()
						effectdata:SetScale(1)
						effectdata:SetMagnitude(1)
						effectdata:SetStart( v:GetPos()) 
						effectdata:SetOrigin( closest:GetPos() )
						util.Effect( "ToolTracer", effectdata )
						sound.Play( "EnergyBall.Launch", self:GetPos() )

						v:SetPos(closest:GetPos() + Vector(0,0,25))	
						v:PhysicsUpdate() //Makes them actually move when they're teleported, 
								  //so they don't just stack up on the teleport point until they're ordered

						//Also: It'd be nice to have the teleporter's move orders put onto the units it teleports,
						//but I can't figure out how to get that to work for the moment.
					end
				end
			end
		end
	end
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end