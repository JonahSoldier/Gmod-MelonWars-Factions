AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	--self:SetPos(self:GetPos()+Vector(0,0,-5))
	
	MW_Defaults ( self )

	self.modelString = "models/xqm/jetenginepropellerlarge.mdl"
	self.moveType = MOVETYPE_NONE
	--self.Angles = Angle(0,0,0)
	--self:SetPos(self:GetPos()+Vector(0,0,0))
	self.canMove = false
	self.canShoot = false
	self.maxHP = 100
	
	self.active = true
	
	self.slowThinkTimer = 1
	
	self.population = 1
	
	self.deathSound = "ambient/explosions/explode_9.wav"
	self.deathEffect = "Explosion"

	MW_Setup ( self )

end


function ENT:SlowThink(ent)
	local foundEnts = ents.FindInSphere(self:GetPos(), 150)
	
	for k, v in pairs(foundEnts) do 
		if(v:GetClass() == "ent_melon_fighter") then
			v:SetNWInt("fuel", v:GetNWInt("fuel", 0) + 1)
		end
	end
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end