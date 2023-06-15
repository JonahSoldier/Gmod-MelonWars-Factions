include("shared.lua")

function ENT:Initialize()
	self.nextParticle = 0
end

function ENT:Draw()
	-- self.BaseClass.Draw(self) -- Overrides Draw
	self:DrawModel() -- Draws Model Client Side
end

function ENT:Think()
	if (self.nextParticle < CurTime()) then
		MelonWars.drawSickEffect( self, 3 )
		self.nextParticle = CurTime() + 0.02
	end
end

local function MW_SickExplosion(ent, amount)
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 1, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(3.0, 5.0) ) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( math.random(20, 30) )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(250)
			local vec = AngleRand():Forward() * math.random(100, 5000)
			vec.z = math.abs(vec.z)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec * 0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function ENT:OnRemove()
	MW_SickExplosion(self, 300)
end