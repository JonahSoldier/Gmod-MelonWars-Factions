AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:PhysicsInitSphere( 5, "default" )
	self.rotation = AngleRand():Forward()
	self:GetPhysicsObject():SetDamping(0,0)
	local time = 3.8
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

function ENT:PhysicsUpdate(colData, collider)
	local phys = self:GetPhysicsObject()
	phys:ApplyTorqueCenter( self.rotation * 50 )
	phys:ApplyForceCenter( vector_up * (phys:GetMass() * 5.6) )
end



function ENT:PhysicsCollide( colData, collider )
	local other = colData.HitEntity
	if (other.canMove == false or other.Base == "ent_melon_prop_base") then
		if (self:IsValid()) then
			if other.Base == "ent_melon_prop_base" then 
				local newHealth =  other:GetNWInt("health", 1) - 30
				other:SetNWInt( newHealth )
				if newHealth < 0 then
					other:PropDie()
				end
			else
				other.damage = 30
			end
			self:SetNWFloat( "health", HP )
			--util.BlastDamage( self, self, self:GetPos(), 30, 75 )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			util.Effect( "Explosion", effectdata )
			self:Remove()
		end
	end
end