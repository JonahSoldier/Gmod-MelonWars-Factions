AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	self:PhysicsInitSphere( 5, "default" )
	self.rotation = AngleRand():Forward()
	self:GetPhysicsObject():SetDamping(0,0)
	local time = 3.7
	self:Ignite( time, 0.1 )
	timer.Simple( time, function()
		if self:IsValid() then
			self:Explode()
		end
	end	)
end

function ENT:PhysicsUpdate(colData, collider)
	local phys = self:GetPhysicsObject()
	phys:ApplyTorqueCenter( self:GetTable().rotation * 50 )
	phys:ApplyForceCenter( vector_up * (phys:GetMass() * 5.6) )
end

function ENT:Explode()
	util.BlastDamage( self, self, self:GetPos(), 30, 75 )
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "Explosion", effectdata )
	self:Remove()
end

function ENT:PhysicsCollide( colData, collider )
	local other = colData.HitEntity
	if not self:IsValid() or not other:IsValid() then return end

	if ((other.Base == "ent_melon_base" or other.Base == "ent_melon_energy_base") and not other.canMove) or other.Base == "ent_melon_prop_base" then
		other:TakeDamage(30, self, self)

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata )
		self:Remove()
	elseif other.Base == "ent_melon_base" then 
		self:Explode()
	end
end