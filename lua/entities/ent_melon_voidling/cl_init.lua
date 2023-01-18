include("shared.lua")

--function ENT:Draw()
	-- self.BaseClass.Draw(self) -- Overrides Draw
	-- self:DrawModel() -- Draws Model Client Side
--end

local function MW_VoidExplosion(ent, amount, sizeMul)
	-- if (CurTime()-ent:GetCreationTime() < 5) then return end
	local particleSize = math.random(12, 18)
	local fireworkSize = math.random(300, 400) * sizeMul
	local teamColor = ent:GetColor();
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 0, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand( 0.5, 1.0 ) * sizeMul ) -- How long the particle should "live"
			local c = math.Rand(0.8, 1.0)
			local _c = 1-c
			part:SetColor( teamColor.r * c + 255 * _c,teamColor.g * c + 255 * _c, teamColor.b * c + 255 * _c )
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( particleSize )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(50)
			local vec = AngleRand():Forward() * fireworkSize
			part:SetGravity( -vec * 3 ) -- Gravity of the particle
			part:SetVelocity( vec * 0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function ENT:OnRemove()
	MW_VoidExplosion(self, 50, 1)
end