AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	//self:SetPos(self:GetPos()+Vector(0,0,-5))
	
	MW_Defaults ( self )

	self.modelString = "models/props_rooftop/roof_vent004.mdl"
	self.moveType = MOVETYPE_NONE
	//self.Angles = Angle(0,0,0)
	//self:SetPos(self:GetPos()+Vector(0,0,0))
	self.canMove = false
	self.canShoot = false
	self.maxHP = 100
	
	self.active = true
	
	self.slowThinkTimer = 0.1
	
	self.population = 1
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	MW_Setup ( self )

	
	self.zone = ents.Create( "ent_melon_zone" )
	self.zone:SetModel("models/hunter/tubes/tube4x4x025.mdl")
	self.zone:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	self.zone:SetParent(self)
	self.zone:SetPos(self:GetPos()+Vector(0,0,-50))
	self.zone:Spawn()
	self.zone:SetMoveType( MOVETYPE_NONE )
	self.zone:SetModelScale( 2.1, 0 ) //half size
	self.zone:SetMaterial( "models/ihvtest/eyeball_l" )
	self.zone:SetNWInt("zoneTeam", mw_melonTeam)
	self.zone:SetNWInt("scale", 250)

	self:DeleteOnRemove( self.zone )

	
	timer.Simple(0.1, function () self:snapToGround() end) 
	// this doesn't seem like a super great way to do this but this seems to be what marum did so it's good enough for me
end



function ENT:snapToGround()

	local pos = self:GetPos()

	local trace = util.TraceLine( {
	start = pos+Vector(0,0,150),
	endpos = pos-Vector(0,0,250), 
	filter = function(foundEnt) if foundEnt.Base == "ent_melon_base" or foundEnt:GetClass() == "ent_melon_wall" then return false else return true end end
	})
	 
	if(trace.Hit) then
		self:SetPos(trace.HitPos)		
	else
		self:Remove()
		for k, v in pairs(player.GetAll()) do
			if (v:GetInfoNum("mw_team", 0) == self:GetNWInt("mw_melonTeam", 0)) then
				v:PrintMessage( HUD_PRINTTALK, "///// Stations must be spawned on the ground." )
			end
		end
	end	
end



function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end