if engine.ActiveGamemode() ~= "sandbox" then return end

hook.Add( "InitPostEntity", "MelonWars_InitPlyVariables", function()
	LocalPlayer().spawnTimeMult = 1
end )

hook.Add("OnTextEntryGetFocus", "MelonWars_DisableKeyboard", function (panel)
	LocalPlayer().disableKeyboard = true
end)

hook.Add("OnTextEntryLoseFocus", "MelonWars_EnableKeyboard", function (panel)
	LocalPlayer().disableKeyboard = false
end)

local mw_buildalpha_multiplier_cv = GetConVar("mw_buildalpha_multiplier")
local mw_oldZones_cv = GetConVar("mw_oldbuildzones")
local outpostRingCol = Color(255, 255, 255, 50)
hook.Add("PostDrawTranslucentRenderables", "MelonWars_DrawOutpostZones", function(depth, skybox)
	local locPly = LocalPlayer()
	local activeWeapon = locPly:GetActiveWeapon()
	if not IsValid(activeWeapon) or activeWeapon:GetClass() ~= "gmod_tool" then return end
	local tool = locPly:GetTool()
	if not tool or tool.Mode ~= "melon_universal_tool" then return end

	local pTeam = locPly:GetInfoNum("mw_team", 0)
	local zoneAlpha = mw_buildalpha_multiplier_cv:GetFloat()

	if mw_oldZones_cv:GetBool() then
		render.SetColorMaterial()
		outpostRingCol.a = math.Clamp(10 * zoneAlpha, 0, 255)
		for i, v in ipairs(ents.FindByClass("ent_melon_zone")) do
			local zoneTeam = v:GetNWInt("zoneTeam", 0)
			if MelonWars.sameTeam(pTeam, zoneTeam) then
				local zoneRadius = v:GetNWInt( "scale" , 0 )
				local vPos = v:GetPos()
				render.DrawSphere(vPos, zoneRadius, 35, 12, outpostRingCol)
				render.DrawSphere(vPos, -zoneRadius, 35, 12, outpostRingCol)
			end
		end
	else
		render.StartWorldRings()
		for i, v in ipairs(ents.FindByClass("ent_melon_zone")) do
			local zoneTeam = v:GetNWInt("zoneTeam", 0)
			if MelonWars.sameTeam(pTeam, zoneTeam) then
				render.AddWorldRing(v:GetPos(), v:GetNWInt( "scale" , 0 ), 5, 20)
			end
		end

		outpostRingCol.a = math.Clamp(50 * zoneAlpha, 0, 255)
		render.FinishWorldRings(outpostRingCol)
	end
end)

hook.Add( "PostDrawTranslucentRenderables", "MelonWars_UnitSelectionCircles", function()
	local foundMelons = LocalPlayer().foundMelons

	if not istable( foundMelons ) then return end
	surface.SetDrawColor( 0, 255, 0, 255 )
	draw.NoTexture()
	for _, v in ipairs( foundMelons ) do
		if IsValid( v ) then
			local floorTrace = v.floorTrace
			if floorTrace ~= nil and floorTrace.Hit then
				local healthFrac = v:GetNWFloat("healthFrac", 1)
				local pos = v:GetPos() + v:OBBCenter()
				if v.circleSize ~= nil then
					local polySize = v.circleSize
					local poly = {
						{ x = polySize, y = 0 },
						{ x = polySize * 0.72, y = polySize * 0.72 },
						{ x = 0, y = polySize },
						{ x = -polySize * 0.72, y = polySize * 0.72 },
						{ x = -polySize, y = 0 },
						{ x = -polySize * 0.72, y = -polySize * 0.72 },
						{ x = 0, y = -polySize },
						{ x = polySize * 0.72, y = -polySize * 0.72 }
					}
					--surface.SetDrawColor( 255 * math.min( ( 1 - hp / maxhp ) * 2, 1 ), 255 * math.min( hp / maxhp * 2, 1 ), 0, 255 )
					surface.SetDrawColor( 255 * math.min( ( 1 - healthFrac ) * 2, 1 ), 255 * math.min( healthFrac * 2, 1 ), 0, 255 )
					--if hp <= 0 then
					if healthFrac <= 0 then
						surface.SetDrawColor( 255, 255, 255 )
					end
					cam.Start3D2D( Vector( pos.x, pos.y, floorTrace.HitPos.z + 1 ), floorTrace.HitNormal:Angle() + Angle( 90, 0, 0 ), 1 )
						surface.DrawPoly( poly )
					cam.End3D2D()
				end
			end
		else
			table.RemoveByValue( foundMelons, v )
		end
	end
end )

local function MWDrawSelectionCircle(startingPos, endingPos)
	surface.SetDrawColor( 0, 255, 0, 255 )

	local ply = LocalPlayer()
	local baseSize = 5000
	local center = (startingPos + endingPos) / 2
	local radius = (startingPos-endingPos):Length() / 2
	local oneTurn = math.pi * 2
	local pointCount = 12

	for i = 0, oneTurn, oneTurn / pointCount do
		local worldPos = center + Vector(radius * math.sin(i), radius * math.cos(i), 0)
		local screenPos = worldPos:ToScreen()
		local size = baseSize / (ply:EyePos() - worldPos):Length()
		surface.DrawRect( screenPos.x - size / 2, screenPos.y - size / 2, size, size )
	end

	local lineCount = 24

	local pointPos = center + Vector(radius, 0, 0)
	local increment = oneTurn / lineCount
	for i = 0, oneTurn, increment do
		local nextPos = center + Vector(radius * math.cos(i + increment), radius * math.sin(i + increment), 0)
		local startPoint = pointPos:ToScreen()
		local endPoint = nextPos:ToScreen()
		pointPos = nextPos
		surface.DrawLine( startPoint.x, startPoint.y, endPoint.x, endPoint.y)
	end

	local startSize = baseSize / (ply:EyePos() - startingPos):Length()
	local startScreenPos = startingPos:ToScreen()
	surface.DrawRect( startScreenPos.x - startSize, startScreenPos.y - startSize, startSize * 2, startSize * 2 )

	local endSize = baseSize / (ply:EyePos() - endingPos):Length()
	local endScreenPos = endingPos:ToScreen()
	surface.DrawRect( endScreenPos.x - endSize, endScreenPos.y - endSize, endSize * 2, endSize * 2 )

	local centerSize = (startSize + endSize) / 2
	local centerScreenPos = center:ToScreen()
	surface.DrawRect( centerScreenPos.x - centerSize / 2, centerScreenPos.y - centerSize / 2, centerSize, centerSize )
end

local function DrawMelonCross( pos, drawColor )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( pos.x - 2, pos.y - 10, 9, 25 )
	surface.DrawRect( pos.x - 10, pos.y - 2, 25, 9 )
	surface.SetDrawColor( drawColor )
	surface.DrawRect( pos.x, pos.y - 8, 5, 21 )
	surface.DrawRect( pos.x - 8, pos.y, 21, 5 )
end

hook.Add( "HUDPaint", "MelonWars_DrawHUD", function()
	local ply = LocalPlayer()
	local activeWeapon = ply:GetActiveWeapon()
	if not IsValid(activeWeapon) then return end
	if activeWeapon:GetClass() ~= "gmod_tool" then return end
	local tool = ply:GetTool()
	if tool == nil then return end
	if tool.Mode ~= "melon_universal_tool" then return end

	if ply.mw_selecting then
		MWDrawSelectionCircle(ply.mw_selectionStartingPoint, ply.mw_selectionEndingPoint)
	end

	local AlertIcons = ents.FindByClass( "ent_melon_HUD_alert" )
	local a = ply:GetInfoNum("mw_team", 0)
	for _, v in ipairs(AlertIcons) do
		if v:GetNWInt("drawTeam", 0) == a then
			local pos = v:GetPos():ToScreen()
			pos = Vector(pos.x, pos.y)
			local border = ScrH() / 3
			local center = Vector(ScrW() / 2, ScrH() / 2)
			if (pos - center):LengthSqr() > border * border then
				pos = center + (pos - center):GetNormalized() * border
			end
			surface.SetDrawColor( 255, 0, 0, 255 )
			surface.DrawRect( pos.x - 16, pos.y - 20, 32, 40 )
			surface.SetDrawColor( 150, 0, 0, 255 )
			surface.DrawRect( pos.x - 12, pos.y - 16, 24, 32 )
			surface.SetDrawColor( 255, 0, 0, 255 )
			surface.DrawRect( pos.x - 3, pos.y - 12, 6, 14 )
			surface.DrawRect( pos.x - 3, pos.y + 6, 6, 6 )
		end
	end

	local MainBases = ents.FindByClass( "ent_melon_main_building*" )

	for _, v in ipairs(MainBases) do
		local drw = false
	    if (ply:GetPos() - v:GetPos()):LengthSqr() < 800000 then
	    	drw = true
	    elseif CurTime() < v:GetNWFloat("lastHit", 0) + 5 then
	    	drw = true
	    end

	    if drw then
		    local pos = (v:GetPos() + Vector(0,0,v:OBBMaxs().z)):ToScreen()
			pos = Vector(pos.x, pos.y-100)

			local percent = v:GetNWInt( "healthFrac", 1)
			surface.SetDrawColor( 0, 0, 0, 255 )
		  	surface.DrawRect( pos.x - 15, pos.y - 55, 30, 160 )
			surface.SetDrawColor( 255, 0, 0, 255 )
		  	surface.DrawRect( pos.x - 10, pos.y + 100 - 150 * percent, 20, 150 * percent )
		end
	end

	if istable(ply.foundMelons) then
		local pos, fe, te
		for _, v in ipairs( ply.foundMelons ) do
			if v:IsValid() then
				fe = v:GetNWEntity("followEntity", nil)
				if (fe:IsValid() and fe ~= v) then
					pos = fe:WorldSpaceCenter():ToScreen()
					DrawMelonCross(pos, Color( 0, 150, 255, 255 ))
				elseif (v:GetNWBool("moving", false)) then
					pos = v:GetNWVector("targetPos"):ToScreen()
					DrawMelonCross(pos, Color( 0, 255, 0, 255 ))
				end

				te = v:GetNWEntity("targetEntity", nil)
				if (te:IsValid() and te ~= v) then
					pos = te:WorldSpaceCenter():ToScreen()
					DrawMelonCross(pos, Color( 255, 0, 0, 255 ))
				end
			end
		end
	end

	local points = ents.FindByClass( "ent_melon_cap_point" )
	table.Add(points, ents.FindByClass( "ent_melon_outpost_point" ))
	table.Add(points, ents.FindByClass( "ent_melon_mcguffin" ))
	table.Add(points, ents.FindByClass( "ent_melon_water_tank" ))
	table.Add(points, ents.FindByClass( "ent_melon_silo" ))

	for _, v in ipairs( points ) do
		if IsValid(v) and ply:GetPos():DistToSqr(v:GetPos()) < 800000 then
			local capture = v:GetNWInt( "captured", 0 )
			if capture > 0 then
				local vpos = v:WorldSpaceCenter() + Vector( 0, 0, 100 )
				local pos = vpos:ToScreen()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( pos.x - 8, pos.y - 123, 16, 106 )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawRect( pos.x - 5 , pos.y - 120, 10, 100 )
				surface.SetDrawColor( MelonWars.teamColors[v:GetNWInt("capTeam")] )
				surface.DrawRect( pos.x - 5 , pos.y - 20 - capture, 10 , capture )
			end
		end
	end

	if not IsValid( ply.controllingUnit ) then return end
	--[[
	local pos = ply.controlTrace.HitPos
	local spos = pos:ToScreen()
	local hit = ply.controlTrace.Hit
	if hit then
		DrawMelonCross( spos, color_white )
		local targetEntity = ply.controlTrace.Entity
		if IsValid( targetEntity ) and not targetEntity:IsWorld() then
			spos = targetEntity:GetPos():ToScreen()
			DrawMelonCross( spos, Color( 255, 200, 0, 255 ) )
		end
	else
		DrawMelonCross( spos, Color( 255, 0, 0, 255 ) )
	end
	--]]
end )

--*TODO: Bring back unit control (what this is)
--I removed it to reduce the number of networked variables per entity, as range is only used for this.
--We can probably bring it back without any downsides if I make it only set range when a unit is controlled.
--[[
hook.Add( "CalcView", "MelonWars_UnitControl_CalcView", function( ply, pos, angles, fov )
	if not IsValid(ply.controllingUnit) then return end
	local cUnit = ply.controllingUnit
	local view = {}

	view.origin = cUnit:GetPos() + Vector(0,0,15 + cUnit:OBBMaxs().z) - angles:Forward() * 50
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	local targetPos = util.QuickTrace( view.origin, angles:Forward() * 50000, cUnit ).HitPos
	--cUnit:GetNWFloat("range", 1000)  --This has been removed
	LocalPlayer().controlTrace = util.QuickTrace( cUnit:GetPos(), (targetPos - cUnit:GetPos()):GetNormalized() * cUnit:GetNWFloat("range", 1000), cUnit )
	return view
end )
--]]

hook.Add( "RenderScreenspaceEffects", "MelonWars_ColourMod", function()
	if not LocalPlayer().MWhasColourModifier then return end
	DrawColorModify( LocalPlayer().MWColourModifierTable )
end )