include('shared.lua')

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side

	local state = self:GetNWInt("state", 0.5)/1000
    local s = 9
	cam.Start3D2D( self:GetPos()+Vector(0,0,40)+self:GetRight()*6+self:GetForward()*1, Angle(0,0,0), 1 )
		surface.SetDrawColor( Color( 50, 50, 50, 255 ) )
		surface.DrawRect( -s, -s, s*2, s*2 )
		surface.SetDrawColor( Color( 0, state*255, state*255, 255 ) )
		surface.DrawRect( -s+2, -s+2, s*2-4, s*2-4 )
	cam.End3D2D()
end


function ENT:AttackParticle()
	local emitter = ParticleEmitter( self:GetPos() + Vector(0,0,200) )

	local part = emitter:Add( "effects/ar2_altfire1", self:GetPos() + Vector(0,0,200)  )

	if ( part ) then
		part:SetDieTime( 13 ) 

		part:SetStartAlpha( 255 ) -- Starting alpha of the particle
		part:SetEndAlpha( 255 ) -- Particle size at the end if its lifetime

		part:SetStartSize( 20 ) -- Starting size
		part:SetEndSize( 20 ) -- Size when removed

		part:SetGravity( Vector( 0, 0, 0 ) ) -- Gravity of the particle
		part:SetVelocity(  Vector( 0, 0, 0 ) ) -- Initial velocity of the particle
	end
end

function ENT:Think() 

	if(self:GetNWBool("Fired", false)) then

		self:SetNWBool("Fired", false) 
		self:AttackParticle()
	end

	//self:NextThink(CurTime() + 0.2)
	//return true
end