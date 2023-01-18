include('shared.lua')

--Laser = Material( "vgui/wave.png", "noclamp smooth" )
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
    self:BarrackDraw(self, 20)
end


function ENT:Draw()
	self:DrawModel()
	if (cvars.Number("mw_team") == self:GetNWInt("mw_melonTeam", -1)) then
		render.SetMaterial( Material( "color" ) )
	    --render.DrawBeam( self:WorldSpaceCenter(), self:GetNWVector("targetPos"), 1, 1, 1, Color( 0, 255, 0, 100 ) )
	    local angle = LocalPlayer():EyeAngles()+Angle(-90,0,0)
	    local vpos = self:WorldSpaceCenter()+Vector(0,0,40)+Vector(0,0,offset)+angle:Forward()*10


	    local charge = self:GetNWInt("mw_charge", 0)
	    local maxCharge = self:GetNWInt("maxCharge", 1)

	    local width = 41


	    cam.Start3D2D( vpos, angle, 1 )
	    	surface.SetDrawColor( Color( 0,255,255, 255 ) )
	        surface.DrawRect( 0, -width/2+1, 5, width*charge/maxCharge )

	        surface.SetDrawColor( Color( 0,0,0, 255 ) )
	        surface.DrawOutlinedRect( 0, -width/2+1, 5, width )

		cam.End3D2D()
	end

	local time = self:GetNWFloat("spawnTime",0)
	if (CurTime() < time) then
	    local angle = LocalPlayer():EyeAngles()+Angle(0,0,90)
	    angle:RotateAroundAxis( LocalPlayer():EyeAngles():Up(), -90 )
	    local vpos = self:WorldSpaceCenter()--+angle:Forward()*10-angle:Right()*10/2
		cam.Start3D2D( vpos, angle, 0.5 )
			draw.SimpleText( tostring(math.ceil(time-CurTime())).."s", "Trebuchet24", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end