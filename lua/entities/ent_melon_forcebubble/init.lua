AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/hunter/misc/shell2x2.mdl"
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self.shotSound = "weapons/stunstick/stunstick_impact2.wav"
	
	self.maxHP = 250
	self.speed = 0
	self.energyCost=10
	self.sphereRadius = 0
	self.slowThinkTimer = 0.1
	self.fireDelay = 999
	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 500)

	self.captureSpeed = 0

	self.population = 0

	--print("My Initialization")

	MW_Setup ( self )
	
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.canBeSelected = false
	self:SetMaterial("models/effects/comball_tape")
end

function ENT:SkinMaterial()

end

function ENT:SlowThink ( ent )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	if self.HP<self.maxHP then
		if ent:GetNWInt("mw_charge",0)>0 then
			self.HP=self.HP+self.energyCost
			ent:SetNWInt("mw_charge",ent:GetNWInt("mw_charge",0)-self.energyCost*2)
		else 

			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) -- Makes the thing unshootable when it has no charge, I need to somehow make units stop targeting it too.
			
		end
	end
end



function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end