AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:PhysicsInitSphere( 5, "default" )
	self.rotation = AngleRand():Forward()
	self:GetPhysicsObject():SetDamping(0,0)
	local time = 10
	self:Ignite( time, 0.1 )
	timer.Simple( time, function()
		if (self:IsValid()) then
			util.BlastDamage( self, self, self:GetPos(), 30, 75 )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			util.Effect( "Explosion", effectdata )
			self:Remove()
		end
	end	)
end

function ENT:PhysicsUpdate()
	local phys = self:GetPhysicsObject()
	phys:ApplyTorqueCenter( self.rotation*50 )
	phys:ApplyForceCenter(Vector(0,0,5.6)*phys:GetMass())
end


function ENT:PhysicsCollide( colData, collider )
	local vel = self:GetVelocity():Length()
	if (self.exploded == false) then
		local other = colData.HitEntity
		local otherhealth = other:GetNWFloat("health", 0)
		if (otherhealth ~= 0) then
			self.exploded = true

			util.BlastDamage( self, self, self:GetPos(), 50, 50 )

			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			util.Effect( "HelicopterMegaBomb", effectdata )
			local newHealth = otherhealth-100
			other:SetNWFloat("health", newHealth)
			if (other:GetNWFloat("health", 1) <= 0) then
				MelonWars.die(other)
			end
		end
		self:GetPhysicsObject():SetVelocity(Vector(0,0,-1000))

		if (self:IsValid()) then
			util.BlastDamage( self, self, self:GetPos(), 70, 50 )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			util.Effect( "Explosion", effectdata )
			self:Remove()
		end
	end
end