if engine.ActiveGamemode() ~= "sandbox" then return end

hook.Add( "Initialize", "MelonWars_StartPlyData", function()
	-- 90% of this code does nothing because this hook is called before the player is initialized lol
	CreateClientConVar( "mw_buildalpha_multiplier", "1", true, false, "Makes the sphere around outposts more/less transparent", 0, 10 )
	CreateClientConVar( "mw_player_ready", "0", false, true, "Is the player ready or not", 0, 1 )
	LocalPlayer().mw_selecting = false
	LocalPlayer().mw_selectionStartingPoint = Vector(0,0,0)
	LocalPlayer().mw_selectionEndingPoint = Vector(0,0,0)

	LocalPlayer().mw_toolCost = -1
	LocalPlayer().mw_hudColor = Color(10,10,10,20)
	
	LocalPlayer().mw_hover = 0
	LocalPlayer().mw_menu = 0
	LocalPlayer().mw_selectTimer = 0
	LocalPlayer().mw_selectionID = 0
	LocalPlayer().mw_spawnTimer = 0
	LocalPlayer().mw_cooldown = 0
	LocalPlayer().mw_frame = nil
	
	LocalPlayer().mw_units = 0
	LocalPlayer().mw_credits = 0

	LocalPlayer().foundMelons = {}
	LocalPlayer().controlTrace = {}
end )

hook.Add( "InitPostEntity", "MelonWars_InitPlyVariables", function()
	LocalPlayer().spawnTimeMult = 1
end )

mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
mw_team_colors[0] = Color(100,100,100,255)

hook.Add( "Think", "MelonWars_SelectingUpdate", function()	
	--[[if (LocalPlayer().mw_selecting) then
		LocalPlayer().mw_selEnd = LocalPlayer():GetEyeTrace().HitPos
	end]]
	local tr = LocalPlayer():GetEyeTrace()
	local ent = tr.Entity
	if ent:GetNWString( "message", "nope" ) ~= "nope" then
        AddWorldTip( nil, ent:GetNWString( "message", "nope" ), nil, Vector( 0, 0, 0 ), ent )
    end
end )
--[[
local function OnPlayerChat( ply, text, teamChat, isDead )
	if cvars.Bool( "mw_custom_chat" ) then
		local _team = cvars.Number( "mw_team" )
		chat.AddText( mw_team_colors[_team], ply:Nick(), Color(255,255,255), ": ", text )
		return true
	end
end
hook.Add( "OnPlayerChat", "MelonWars_OnPlyChat", OnPlayerChat )
]]
function MW_BeginSelection() -- Previously concommand.Add( "+mw_select", function( ply )
	local ply = LocalPlayer()
	ply.mw_selecting = true
	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() ~= "player" ) then return true end end,
		mask = MASK_SOLID+MASK_WATER
	} )

	ply.mw_selectionStartingPoint = trace.HitPos
	ply.mw_selectionEndingPoint = trace.HitPos
	sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 100, 1 )

	if ply:KeyDown( IN_SPEED ) then
	else 
		if istable( ply.foundMelons ) then
			table.Empty( ply.foundMelons )
		end
	end
end

function MWDrawSelectionCircle(startingPos, endingPos)
	surface.SetDrawColor( 0, 255, 0, 255 )

	local ply = LocalPlayer()
	local baseSize = 5000
	local pos
	local center = (startingPos+endingPos)/2
	local radius = (startingPos-endingPos):Length()/2
	local oneTurn = math.pi*2
	local pointCount = 12

	for i=0, oneTurn, oneTurn/pointCount do
		local worldPos = center + Vector(radius*math.sin(i), radius*math.cos(i), 0)
		local screenPos = worldPos:ToScreen()
		local size = baseSize/(ply:EyePos()-worldPos):Length()
		surface.DrawRect( screenPos.x-size/2, screenPos.y-size/2, size, size )
	end

	local lineCount = 24

	local pointPos = center + Vector(radius, 0, 0)
	local increment = oneTurn/lineCount
	for i=0, oneTurn, increment do
		local nextPos = center + Vector(radius*math.cos(i+increment), radius*math.sin(i+increment), 0)
		-- local size = baseSize/(ply:EyePos()-worldPos):Length()
		local startPoint = pointPos:ToScreen()
		local endPoint = nextPos:ToScreen()
		pointPos = nextPos
		surface.DrawLine( startPoint.x, startPoint.y, endPoint.x, endPoint.y)
	end

	local startSize = baseSize/(ply:EyePos()-startingPos):Length()
	local startScreenPos = startingPos:ToScreen()
	surface.DrawRect( startScreenPos.x-startSize, startScreenPos.y-startSize, startSize*2, startSize*2 )

	local endSize = baseSize/(ply:EyePos()-endingPos):Length()
	local endScreenPos = endingPos:ToScreen()
	surface.DrawRect( endScreenPos.x-endSize, endScreenPos.y-endSize, endSize*2, endSize*2 )

	-- surface.DrawLine( startScreenPos.x, startScreenPos.y, endScreenPos.x, endScreenPos.y)

	local centerSize = (startSize+endSize)/2
	local centerScreenPos = center:ToScreen()
	surface.DrawRect( centerScreenPos.x-centerSize/2, centerScreenPos.y-centerSize/2, centerSize, centerSize )
end

net.Receive( "MW_ReturnSelection", function( len, pl )
	local returnedSelectionID = net.ReadInt(20)

	if returnedSelectionID ~= LocalPlayer().mw_selectionID then return end
	local count = net.ReadUInt(16)
	-- local newTable = {}

	for i=0,count do
		local foundEntity = net.ReadEntity()
		if (not table.HasValue(LocalPlayer().foundMelons, foundEntity)) then
			table.insert(LocalPlayer().foundMelons, foundEntity)
			-- table.insert(newTable, foundEntity)
		end
	end
	-- LocalPlayer().foundMelons = newTable
end )
--[[
function DrawBuildRanges(zoneEntity, zoneRadius)
	if not (tostring(LocalPlayer().BuildZone) == "[NULL Entity]" or not IsValid(LocalPlayer().BuildZone)) then return end
	LocalPlayer().BuildZone = ents.CreateClientProp( "models/hunter/tubes/circle2x2.mdl" )
	LocalPlayer().BuildZone:SetMoveType( MOVETYPE_NONE )
	LocalPlayer().BuildZone:SetNotSolid( true );
	LocalPlayer().BuildZone:SetRenderMode( RENDERMODE_TRANSALPHA )
	LocalPlayer().BuildZone:SetMaterial("models/debug/debugwhite")
	LocalPlayer().BuildZone:SetColor( Color( 255, 255, 255, 255 ) )
	LocalPlayer().BuildZone:SetModelScale(0.021*zoneRadius)
	LocalPlayer().BuildZone:SetPos(zoneEntity:GetPos())
	LocalPlayer().BuildZone:Spawn()
	-- LocalPlayer().BuildZone:DeleteOnRemove( zoneEntity )
end
]]
function MW_UpdateGhostEntity (model, pos, offset, angle, newColor, ghostSphereRange, ghostSpherePos)
	if (newColor == nil) then
		newColor = Color(100,100,100)
	end
	if (tostring(LocalPlayer().GhostEntity) == "[NULL Entity]" or not IsValid(LocalPlayer().GhostEntity)) then
		LocalPlayer().GhostEntity = ents.CreateClientProp( model )
		LocalPlayer().GhostEntity:SetSolid( SOLID_VPHYSICS );
		LocalPlayer().GhostEntity:SetMoveType( MOVETYPE_NONE )
		LocalPlayer().GhostEntity:SetNotSolid( true );
		LocalPlayer().GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
		LocalPlayer().GhostEntity:SetRenderFX( kRenderFxPulseFast )
		LocalPlayer().GhostEntity:SetMaterial("models/debug/debugwhite")
		LocalPlayer().GhostEntity:SetColor( Color(newColor.r*1.5, newColor.g*1.5, newColor.b*1.5, 150) )
		LocalPlayer().GhostEntity:SetModel( model )
		LocalPlayer().GhostEntity:SetPos( pos + offset )
		LocalPlayer().GhostEntity:SetAngles( angle )
		LocalPlayer().GhostEntity:Spawn()
	else
		LocalPlayer().GhostEntity:SetModel( model )
		LocalPlayer().GhostEntity:SetPos( pos + offset )
		LocalPlayer().GhostEntity:SetAngles( angle )
		local obbmins = LocalPlayer().GhostEntity:OBBMins()
		local obbmaxs = LocalPlayer().GhostEntity:OBBMaxs()
		obbmins:Rotate(angle)
		obbmaxs:Rotate(angle)
		local mins = Vector(LocalPlayer().GhostEntity:GetPos().x+obbmins.x, LocalPlayer().GhostEntity:GetPos().y+obbmins.y, pos.z+5)
		local maxs = Vector(LocalPlayer().GhostEntity:GetPos().x+obbmaxs.x, LocalPlayer().GhostEntity:GetPos().y+obbmaxs.y, pos.z+20)
		local overlappingEntities = ents.FindInBox( mins, maxs)
		--[[
		local vPoint = LocalPlayer().GhostEntity:GetPos()+obbmins+Vector(0,0,1)
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		effectdata:SetScale(0)
		util.Effect( "MuzzleEffect", effectdata )

		vPoint = LocalPlayer().GhostEntity:GetPos()+obbmaxs
		effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		effectdata:SetScale(0)
		util.Effect( "MuzzleEffect", effectdata )
		]]
		LocalPlayer().canPlace = true
		if LocalPlayer().mw_action == 1 then
			if not mw_units[LocalPlayer():GetInfoNum("mw_chosen_unit", 0)].canOverlap then
				for k, v in pairs(overlappingEntities) do
					if (v.Base ~= nil) then
						if (string.StartWith( v.Base, "ent_melon_" )) then
							LocalPlayer().canPlace = false
						end
					end
				end
			end
		end
		if (LocalPlayer().canPlace) then
			LocalPlayer().GhostEntity:SetColor( Color(newColor.r, newColor.g, newColor.b, 150 ))
			LocalPlayer().GhostEntity:SetRenderFX( kRenderFxPulseSlow )
		else
			LocalPlayer().GhostEntity:SetColor( Color(150, 0, 0, 150 ))
			LocalPlayer().GhostEntity:SetRenderFX( kRenderFxDistort )
		end
	end

	if (tostring(LocalPlayer().GhostSphere) == "[NULL Entity]" or not IsValid(LocalPlayer().GhostSphere)) then
		if (LocalPlayer().mw_action == 1 and ghostSphereRange > 0) then
			LocalPlayer().GhostSphere = ents.CreateClientProp( "models/hunter/tubes/circle2x2.mdl" )
			LocalPlayer().GhostSphere:SetSolid( SOLID_VPHYSICS );
			LocalPlayer().GhostSphere:SetMoveType( MOVETYPE_NONE )
			LocalPlayer().GhostSphere:SetNotSolid( true );
			LocalPlayer().GhostSphere:SetRenderMode( RENDERMODE_TRANSALPHA )
			LocalPlayer().GhostSphere:SetRenderFX( kRenderFxPulseSlow )
			LocalPlayer().GhostSphere:SetMaterial("models/debug/debugwhite")
			LocalPlayer().GhostSphere:SetColor( Color(newColor.r*1.5, newColor.g*1.5, newColor.b*1.5, 50) )
			LocalPlayer().GhostSphere:SetModelScale(0.021*ghostSphereRange)
			LocalPlayer().GhostSphere:Spawn()
		end
	else
		if (LocalPlayer().mw_action == 1 and ghostSphereRange > 0) then
			local color = LocalPlayer().GhostSphere:GetColor()
			LocalPlayer().GhostSphere:SetColor( Color(color.r, color.g, color.b, 50) )
			LocalPlayer().GhostSphere:SetPos( Vector(pos.x, pos.y, ghostSpherePos.z ) )
			LocalPlayer().GhostSphere:SetModelScale(0.021*ghostSphereRange)
		else
			LocalPlayer().GhostSphere:Remove()
		end
	end
end

function MW_FinishSelection() -- Previously concommand.Add( "-mw_select", function( ply )
	sound.Play( "buttons/lightswitch2.wav", LocalPlayer():GetPos(), 50, 80, 1 )
	LocalPlayer().mw_selecting = false

	-- Finds all the entities in the selection sphere

	-- local foundEnts = ents.FindInSphere((ply.mw_selEnd+ply.mw_selStart)/2, ply.mw_selStart:Distance(ply.mw_selEnd)/2+0.1 )
	-- local selectEnts = table.Copy( foundEnts )
	-- if not ply:KeyDown(IN_SPEED) then ply.foundMelons = {} end
	--Busca de esas entidades cuales son sandias, y cuales son del equipo correcto

	--[[for k, v in pairs( selectEnts ) do
		if (v.moveType ~= MOVETYPE_NONE) then
			local tbl = constraint.GetAllConstrainedEntities( v )
			if (istable(tbl)) then
				for kk, vv in pairs (tbl) do
					if (not table.HasValue(selectEnts, vv)) then
						table.insert(foundEnts, vv)
					else
					end
				end
			end
		end
	end]]
	-- print("========== Selection:")
	-- for k, v in pairs( foundEnts ) do
	-- 	if (v.Base ~= nil) then
	-- 		if (v.Base == "ent_melon_base") then
	-- 			if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("mw_melonTeam", -1) == ply:GetInfoNum( "mw_team", -1 )) then
	-- 				-- if (v:GetNWInt("mw_melonTeam", 0) ~= 0) then
	-- 					table.insert(ply.foundMelons, v)
	-- 					-- print(k..": "..tostring(v)..", added succesfully")
	-- 					--"Added "..tostring(v).." succesfully"
	-- 				-- else
	-- 					-- print(k..": "..tostring(v).." !!! didnt add to the selection because the unit had no team ("..v:GetNWInt("mw_melonTeam", -1)..")")
	-- 				--"Didn't add "..tostring(v).." because it had no team"
	-- 				-- end
	-- 			else
	-- 				-- print(k..": "..tostring(v)..", didnt add to the selection because the unit was not in your team ("..v:GetNWInt("mw_melonTeam", -1)..")")
	-- 				if (v:GetNWInt("mw_melonTeam", -1) == -1) then
	-- 					error("Selected unit has team -1!")
	-- 				end
	-- 			--	"Didn't add "..tostring(v).." because it wasn't my team"
	-- 			end
	-- 		else
	-- 			-- print(k..": "..tostring(v)..", didnt add to the selection because the Base was not ent_melon_base ("..v.Base..")")
	-- 		--"Didn't add "..tostring(v).." because it was a base prop"
	-- 		end
	-- 	else
	-- 		-- print(k..": "..tostring(v)..", didnt add to the selection because Base was null")
	-- 	end
	-- end
	--Le envia al client la lista de sandias para que pueda dibujar los halos
	--[[
	net.Start("Selection")
		net.WriteInt(table.Count(ply.foundMelons),16)
		for k,v in pairs(ply.foundMelons) do
			net.WriteEntity(v)
		end
	net.Send(ply)
	]]--

	-- print("Sending my selection to the server. Total selected units: "..table.Count(ply.foundMelons))
	-- print("Entity im pointing at: "..tostring(ply:GetEyeTrace().Entity))
	-- print("Selection table,")
	-- PrintTable(ply.foundMelons)
	--[[net.Start("MW_SelectContraption")
		net.WriteUInt(table.Count(LocalPlayer().foundMelons)+1, 16)
		net.WriteEntity(ply:GetEyeTrace().Entity)
		for k, v in pairs(ply.foundMelons) do
			net.WriteEntity(v)
		end
	net.SendToServer()]]--

	-- sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 90, 1 )
	-- ply.mw_selEnd = Vector(0,0,0)
	-- ply.mw_selStart = Vector(0,0,0)
	-- ply:SetNWVector("mw_selStart", Vector(0,0,0))
	-- ply:SetNWBool("LocalPlayer().mw_selecting",  Vector(0,0,0))
end

net.Receive( "MW_SelectContraption", function( len, pl )
	local count = net.ReadUInt( 16 )
	-- print("Receiving extra selections from the server ("..count..")")
	local v, hasMelonBase, canMove, isFound
	for i = 0, count do
		v = net.ReadEntity()
		hasMelonBase = v.Base == "ent_melon_base"
		canMove = cvars.Bool( "mw_admin_move_any_team", false ) or ( pl == nil or v:GetNWInt( "mw_melonTeam", -1 ) == pl:GetInfoNum( "mw_team", -1 ) )
		isFound = LocalPlayer().foundMelons[v]
		if hasMelonBase and canMove and not isFound then
			table.insert( LocalPlayer().foundMelons, v )
		end
	end
end )
--[[
net.Receive( "Selection", function( len, pl ) -- Also tried function MW_DoSelection(foundMelons) without the net-related stuff too
	if (LocalPlayer().foundMelons == nil) then
		LocalPlayer().foundMelons = {}
	end
	if (LocalPlayer():KeyDown(IN_SPEED)) then
		else table.Empty(foundMelons) end
	local ammount = net.ReadInt(16)
	for i = 1,ammount do
        table.insert(foundMelons, net.ReadEntity())
    end
	LocalPlayer():SetNWVector("mw_selEnd", LocalPlayer():GetNWVector("mw_selStart", Vector(0,0,0)))
	LocalPlayer().mw_selEnd = Vector(0,0,0)
end )
]]
net.Receive( "RestartQueue", function( len, pl )
	LocalPlayer().mw_spawntime = CurTime()
end )

mrtsMessageReceivingEntity = nil
mrtsMessageReceivingState = "idle"
mrtsNetworkBuffer = ""

net.Receive( "BeginContraptionSaveClient", function( len, pl )
	mrtsMessageReceivingState = net.ReadString()
	mrtsMessageReceivingEntity = net.ReadEntity()
	mrtsNetworkBuffer = ""
end )

net.Receive( "ContraptionSaveClient", function ( len, pl )
	local last = net.ReadBool()
	local size = net.ReadUInt( 16 )
	local data = net.ReadData( size )
	mrtsNetworkBuffer = mrtsNetworkBuffer..data
	if not last then return end
	local text = util.Decompress( mrtsNetworkBuffer )
	file.CreateDir( "melonwars/contraptions" )
	file.Write( "melonwars/contraptions/" .. mrtsMessageReceivingState .. ".txt", text )
	mrtsMessageReceivingEntity = nil
	mrtsMessageReceivingState = "idle"
	mrtsNetworkBuffer = ""
end )

net.Receive("ContraptionValidateClient", function (len, pl)
	local contrapFiles = file.Find("melonwars/contraptions/*.txt", "DATA")
	
	for i=1, table.Count(contrapFiles) do 
		timer.Simple( i*0.1, function()	
			local name = string.gsub(contrapFiles[i], ".txt", "") -- Removes .txt from the name, because other parts of the code add it back in later

			local text =  file.Read("melonwars/contraptions/"..contrapFiles[i], "DATA" ) 
			local compressed_text = util.Compress(text)
			if not compressed_text then compressed_text = text end

			local len = string.len( compressed_text )
			local send_size = 60000
			local parts = math.ceil( len / send_size )
			local start = 0

			-- 29 contrap files aren't reaching the serverside function properly (Out of 52, my contraptions are being used for testing.)
			-- ^^ I had a corrupted contraption file. It was hitting that then failing to do anything after it

			for i = 1, parts do
				local endbyte = math.min( start + send_size, len )
				local size = endbyte - start
				local data = compressed_text:sub( start + 1, endbyte + 1 )
				net.Start( "ContraptionAutoValidate" )
					net.WriteBool( i == parts )
					net.WriteUInt( size, 16 )
					net.WriteData( data, size )
					net.WriteString(name)
				net.SendToServer()

				start = endbyte
			end
			print("Validated "..tostring(i).." contraption files")
		end)
	end
end)

hook.Add("OnTextEntryGetFocus", "MelonWars_DisableKeyboard", function (panel)
	LocalPlayer().disableKeyboard = true
end)

hook.Add("OnTextEntryLoseFocus", "MelonWars_EnableKeyboard", function (panel)
	LocalPlayer().disableKeyboard = false
end)
--[[
hook.Add( "OnContextMenuOpen", "MelonWars_AddHalos", function()
	LocalPlayer():ConCommand("mw_context_menu 1")
end )

hook.Add( "OnContextMenuClose", "MelonWars_AddHalos", function()
	LocalPlayer():ConCommand("mw_context_menu 0")
end )
]]
hook.Add( "PostDrawTranslucentRenderables", "MelonWars_AddHalos", function()
	--[[if (istable(foundMelons)) then
		-- halo.Add( foundMelons, Color( 255, 255, 100 ), 2, 2, 1, true, true )
	end]]
	local activeWeapon = LocalPlayer():GetActiveWeapon()
	if not IsValid(activeWeapon) then return end
	if activeWeapon:GetClass() ~= "gmod_tool" then return end
	local tool = LocalPlayer():GetTool()
	if tool == nil then return end
	if tool.Mode ~= "melon_universal_tool" then return end

	local entityTable = {}
	if LocalPlayer():KeyDown( IN_WALK ) then
		table.Empty(entityTable)
		local tr = LocalPlayer():GetEyeTrace()
		if tr then
			local eyeEntity = tr.Entity
			if (tostring( eyeEntity ~= "Entity [0][worldspawn]")) then
				table.insert(entityTable, eyeEntity)
				--[[ if (istable(entityTable)) then
					-- halo.Add( entityTable, Color( 255, 100, 100 ), 2, 2, 1, true, true )
				end ]]
			end
		end
	end

	local zoneTable = ents.FindByClass( "ent_melon_zone" )
	local a = LocalPlayer():GetInfoNum("mw_team", 0)

	for i = table.Count(zoneTable), 1, -1 do
		local remove = false
		if (teamgrid == nil or teamgrid[zoneTable[i]:GetNWInt("zoneTeam", 0)] == nil or teamgrid[zoneTable[i]:GetNWInt("zoneTeam", 0)][a] == nil) then
			if (zoneTable[i]:GetNWInt("zoneTeam", 0) ~= a) then
				table.remove(zoneTable, i)
			end
		elseif ((zoneTable[i]:GetNWInt("zoneTeam", 0) ~= a and not teamgrid[zoneTable[i]:GetNWInt("zoneTeam", 0)][a]) or (zoneTable[i]:GetPos()-LocalPlayer():GetPos()):LengthSqr() > 7500000) then
			table.remove(zoneTable, i)
		end
	end

	for i = table.Count(zoneTable), 1, -1 do
		local alphaMultiplier = GetConVar("mw_buildalpha_multiplier"):GetFloat()
		zoneRadius = zoneTable[i]:GetNWInt( "scale" , 0 )

		render.SetColorMaterial()	
		render.DrawSphere( zoneTable[i]:GetPos(), zoneRadius, 35, 12, Color( 255, 255, 255, 10*alphaMultiplier ) ) -- pos, radius, qualitylongitude, qualitylatitude, colour
		render.DrawSphere( zoneTable[i]:GetPos(), -zoneRadius, 35, 12, Color( 255, 255, 255, 10*alphaMultiplier ) ) -- pos, radius, qualitylongitude, qualitylatitude, colour
	end 

	render.SetStencilEnable(false)
	-- halo.Add( zoneTable, Color(200,200,200,255), 0, 3, 1, true, true )
end )

hook.Add( "PostDrawTranslucentRenderables", "MelonWars_UnitSelectionCircles", function()
	local angle = LocalPlayer():EyeAngles() + Angle( -90, 0, 0 )
	local foundMelons = LocalPlayer().foundMelons

	if not istable( foundMelons ) then return end
	surface.SetDrawColor(Color( 0, 255, 0, 255 ))
	draw.NoTexture()
	for _, v in pairs( foundMelons ) do
		if (v:IsValid()) then
			local floorTrace = v.floorTrace
			if (floorTrace ~= nil) then
				if (floorTrace.Hit) then
					local hp = v:GetNWFloat("health", 0)
					-- if (hp > 0) then
					local maxhp = v:GetNWFloat("maxhealth", 1)
					local pos = v:GetPos()+v:OBBCenter()
					if (v.circleSize ~= nil) then
						local polySize = v.circleSize
						local poly = {
							{ x = polySize, y = 0 },
							{ x = polySize*0.72, y = polySize*0.72 },
							{ x = 0, y = polySize },
							{ x = -polySize*0.72, y = polySize*0.72 },
							{ x = -polySize, y = 0 },
							{ x = -polySize*0.72, y = -polySize*0.72 },
							{ x = 0, y = -polySize },
							{ x = polySize*0.72, y = -polySize*0.72 }
						}
						surface.SetDrawColor(Color( 255*math.min((1-hp/maxhp)*2,1), 255*math.min(hp/maxhp*2,1), 0, 255 ))
						if (hp <= 0) then
							surface.SetDrawColor(Color(255,255,255))
						end
						cam.Start3D2D(Vector(pos.x, pos.y, floorTrace.HitPos.z+1), floorTrace.HitNormal:Angle()+Angle(90,0,0), 1 )
							surface.DrawPoly( poly )
						cam.End3D2D()
					end
					-- end
				end
			end
		else
			table.RemoveByValue( foundMelons, v )
		end
	end
end )

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
			local border = ScrH()/3
			local center = Vector(ScrW()/2, ScrH()/2)
			if (pos-center):LengthSqr() > border*border then
				pos = center+(pos-center):GetNormalized()*border
			end
			surface.SetDrawColor(Color(255,0,0,255))
		  	surface.DrawRect( pos.x - 16, pos.y - 20, 32, 40 )
			surface.SetDrawColor(Color(150,0,0,255))
		  	surface.DrawRect( pos.x - 12, pos.y - 16, 24, 32 )
		  	surface.SetDrawColor(Color(255,0,0,255))
		  	surface.DrawRect( pos.x - 3, pos.y - 12, 6, 14 )
		  	surface.DrawRect( pos.x - 3, pos.y + 6, 6, 6 )
		  end
	end

	local MainBases = ents.FindByClass( "ent_melon_main_building*" )

	for _, v in ipairs(MainBases) do
		local drw = false
	    if (ply:GetPos()-v:GetPos()):LengthSqr() < 800000 then
	    	drw = true
	    elseif (CurTime() < v:GetNWFloat("lastHit", 0)+5) then
	    	drw = true
	    end

	    if (drw) then
		    local pos = (v:GetPos()+Vector(0,0,v:OBBMaxs().z)):ToScreen()
			pos = Vector(pos.x, pos.y-100)
			--local border = ScrH()/2
			--local center = Vector(ScrW()/2, ScrH()/2)
			--if ((pos-center):LengthSqr() > border*border) then
			--	pos = center+(pos-center):GetNormalized()*border
			--end
			local percent = v:GetNWInt("health", 3)/v:GetNWInt("maxhealth", 10)
			surface.SetDrawColor(color_black)
		  	surface.DrawRect( pos.x - 15, pos.y - 55, 30, 160 )
			surface.SetDrawColor(Color(255,0,0,255))
		  	surface.DrawRect( pos.x - 10, pos.y + 100 -150*(percent), 20, 150*(percent) )
		end
	end

	if istable(ply.foundMelons) then
		for _, v in ipairs( ply.foundMelons ) do
			if v:IsValid() then
				--[[local hp = v:GetNWFloat("health", 0)
				local maxhp = v:GetNWFloat("maxhealth", 1)
				if (hp > 0) then
					local pos = v:GetPos():ToScreen()
					local clampedBar = math.max(15, math.min(100, hp))
					surface.SetDrawColor(Color( 0, 0, 0, 100 ))
					surface.DrawOutlinedRect( pos.x - clampedBar/2 -1, pos.y - 61, clampedBar +2, 13 )
					surface.SetDrawColor(Color( 255*math.min((1-hp/maxhp)*2,1), 255*math.min(hp/maxhp*2,1), 0, 100 ))
					surface.DrawRect( pos.x - clampedBar/2, pos.y - 60, clampedBar, 11 )
					surface.SetFont( "Trebuchet18" )
					surface.SetTextColor( 0, 0, 0, 255 )
					surface.SetTextPos( pos.x - 6, pos.y - 63 )
					surface.DrawText( math.Round(hp))]]

					local fe = v:GetNWEntity("followEntity", nil)
					if (fe:IsValid() and fe ~= v) then
						pos = fe:WorldSpaceCenter():ToScreen()
						DrawMelonCross(pos, Color( 0, 150, 255, 255 ))
					elseif (v:GetNWBool("moving", false)) then
						pos = v:GetNWVector("targetPos"):ToScreen()
						DrawMelonCross(pos, Color( 0, 255, 0, 255 ))
					end

					local te = v:GetNWEntity("targetEntity", nil)
					if (te:IsValid() and te ~= v) then
						pos = te:WorldSpaceCenter():ToScreen()
						DrawMelonCross(pos, Color( 255, 0, 0, 255 ))
					end
				--end
			end
		end
	end

	local points = ents.FindByClass( "ent_melon_cap_point" )
	table.Add(points, ents.FindByClass( "ent_melon_outpost_point" ))
	table.Add(points, ents.FindByClass( "ent_melon_mcguffin" ))
	table.Add(points, ents.FindByClass( "ent_melon_water_tank" ))
	table.Add(points, ents.FindByClass( "ent_melon_silo" ))
	if (istable(points)) then
		for _, v in RandomPairs( points ) do
			if (IsValid(v)) then
				if ((ply:GetPos()-v:GetPos()):LengthSqr() < 800000) then
					local captured = {0,0,0,0,0,0,0,0}
					local capturing = 0
					for i=1, 8 do
						if (v:GetNWInt("captured"..tostring(i), 0) > 0) then
							local vpos = v:WorldSpaceCenter()+Vector(0,0,100)
							local pos = vpos:ToScreen()
							surface.SetDrawColor( color_black )
							surface.DrawRect( pos.x - 5 -3, pos.y - 123, 10 +6, 106 )
							surface.SetDrawColor( color_white )
							surface.DrawRect( pos.x - 5 , pos.y - 120, 10, 100 )
							surface.SetDrawColor(mw_team_colors[i])
							local capture = v:GetNWInt("captured"..tostring(i), 0)
							surface.DrawRect( pos.x - 5 , pos.y - 20 - capture, 10 , capture )
						end
					end
				end
			end
		end
	end

	if not IsValid( ply.controllingUnit ) then return end
	local pos = ply.controlTrace.HitPos
	local spos = pos:ToScreen()
	local hit = ply.controlTrace.Hit
	if hit then
		DrawMelonCross( spos, color_white )
		targetEntity = ply.controlTrace.Entity
		if IsValid( targetEntity ) and not targetEntity:IsWorld() then
			spos = targetEntity:GetPos():ToScreen()
			DrawMelonCross( spos, Color( 255, 200, 0, 255 ) )
		end
	else
		DrawMelonCross( spos, Color( 255, 0, 0, 255 ) )
	end
end )

function DrawMelonCross ( pos, drawColor )
	surface.SetDrawColor( color_black )
	surface.DrawRect( pos.x - 2, pos.y - 10, 9, 25 )
	surface.DrawRect( pos.x - 10, pos.y - 2, 25, 9 )
	surface.SetDrawColor( drawColor )
	surface.DrawRect( pos.x, pos.y - 8, 5, 21 )
	surface.DrawRect( pos.x - 8, pos.y, 21, 5 )
end

net.Receive( "MW_TeamCredits", function( len, pl )
	local previousCredits = LocalPlayer().mw_credits
	LocalPlayer().mw_credits = net.ReadInt( 32 )
	local newCredits = LocalPlayer().mw_credits
	if previousCredits == nil then return end
	local difference = newCredits - previousCredits
	if difference == 0 then return end
	ResourcesChanged( difference )
end )

function ResourcesChanged( dif )
	local tool = LocalPlayer():GetTool()
	if tool == nil then return end
	if tool.Mode ~= "melon_universal_tool" then return end
	tool:IndicateIncome( dif )
end

net.Receive( "MW_TeamUnits", function( len, pl )
	LocalPlayer().mw_units = net.ReadInt(16)
end )

net.Receive( "ChatTimer", function( len, pl )
	LocalPlayer().chatTimer = 1000
end )

net.Receive( "RequestContraptionLoadToClient", function( len, pl )
	local _file = net.ReadString()
	local ent = net.ReadEntity()

	local text = file.Read(_file)
	local compressed_text = util.Compress( text )
	if not compressed_text then compressed_text = text end
	local len = string.len( compressed_text )
	local send_size = 60000
	local parts = math.ceil( len / send_size )
	local start = 0
	net.Start( "BeginContraptionLoad" )
		net.WriteEntity(ent)
	net.SendToServer()
	for i = 1, parts do
		local endbyte = math.min( start + send_size, len )
		local size = endbyte - start
		local data = compressed_text:sub( start + 1, endbyte + 1 )
		net.Start( "ContraptionLoad" )
			net.WriteBool( i == parts )
			net.WriteUInt( size, 16 )
			net.WriteData( data, size )
		net.SendToServer()
		start = endbyte
	end
	--[[net.Start("ContraptionLoad")
		net.WriteString(file.Read( _file ))
		net.WriteEntity(ent)
	net.SendToServer()]]
end )

net.Receive( "EditorSetTeam", function( len, pl )
	local ent = net.ReadEntity()
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 160
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set team")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	for i=1, 8 do
		button = vgui.Create("DButton", frame)
		button:SetSize(29,100)
		button:SetPos(5+30*(i-1),50)
		button:SetText("")
		function button:DoClick()
			net.Start("ServerSetTeam")
				net.WriteEntity(ent)
				net.WriteInt(i, 4)
			net.SendToServer()
			ent:SetColor(mw_team_colors[i])
			ent.mw_melonTeam = i
			frame:Remove()
			frame = nil
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(30,30,30,255) )
			draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
		end
	end
end )

net.Receive( "EditorSetStage", function( len, pl )
	local ent = net.ReadEntity()
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 100
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set Stage")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	local wang = vgui.Create("DNumberWang", frame)
	wang:SetPos(20,50)
	button = vgui.Create("DButton", frame)
	button:SetSize(100,50)
	button:SetPos(120,35)
	button:SetText("Done")
	function button:DoClick()
		net.Start("ServerSetStage")
			net.WriteEntity(ent)
			net.WriteInt(wang:GetValue(), 8)
		net.SendToServer()
		ent.stage = wang:GetValue()
		frame:Remove()
		frame = nil
	end
end )

net.Receive( "DrawWireframeBox", function( len, pl )
	local pos = net.ReadVector()
	local min = net.ReadVector()
	local max = net.ReadVector()
	render.DrawWireframeBox( pos, Angle(0,0,0), min, max, Color(255,255,255,255), false )
end )

net.Receive( "EditorSetWaypoint", function( len, pl )
	local ent = net.ReadEntity()
	local waypoint = net.ReadInt(4)
	local path = net.ReadInt(4)
	local frame = vgui.Create("DFrame")
	local w = 250
	local h = 110
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
	frame:SetTitle("Set Waypoint")
	frame:MakePopup()
	frame:ShowCloseButton()
	local button = vgui.Create("DButton", frame)
	button:SetSize(50,18)
	button:SetPos(w-53,3)
	button:SetText("x")
	function button:DoClick()
		frame:Remove()
		frame = nil
	end
	local label = vgui.Create("DLabel", frame)
	label:SetPos(20,20)
	label:SetText("Waypoint")
	local waypointwang = vgui.Create("DNumberWang", frame)
	waypointwang:SetPos(20,35)
	if (ent.waypoint == nil) then ent.waypoint = 1 end
	waypointwang:SetValue(ent.waypoint)
	label = vgui.Create("DLabel", frame)
	label:SetPos(20,55)
	label:SetText("Path")
	local pathwang = vgui.Create("DNumberWang", frame)
	pathwang:SetPos(20,70)
	if (ent.path == nil) then ent.path = 1 end
	pathwang:SetValue(ent.path)
	button = vgui.Create("DButton", frame)
	button:SetSize(100,50)
	button:SetPos(120,35)
	button:SetText("Done")
	function button:DoClick()
		net.Start("ServerSetWaypoint")
			net.WriteEntity(ent)
			net.WriteInt(waypointwang:GetValue(), 8)
			net.WriteInt(pathwang:GetValue(), 8)
		net.SendToServer()
		ent.waypoint = waypointwang:GetValue()
		ent.path = pathwang:GetValue()
		frame:Remove()
		frame = nil
	end
end )

function MW_VoidExplosion(ent, amount, sizeMul)
	-- if (CurTime()-ent:GetCreationTime() < 5) then return end
	local particleSize = math.random(12, 18)
	local fireworkSize = math.random(300, 400)*sizeMul
	local teamColor = ent:GetColor();
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 0, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(0.5, 1.0)*sizeMul ) -- How long the particle should "live"
			local c = math.Rand(0.8, 1.0)
			local _c = 1-c
			part:SetColor(teamColor.r*c+255*_c,teamColor.g*c+255*_c,teamColor.b*c+255*_c)
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( particleSize )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(50)
			local vec = AngleRand():Forward()*fireworkSize
			part:SetGravity( -vec*3 ) -- Gravity of the particle
			part:SetVelocity( vec*0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function MW_SickEffect(ent, amount)
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 1, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(1.0, 2.0) ) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( math.random(12, 18) )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(50)
			local vec = AngleRand():Forward()*math.random(10, 50)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec*0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function MW_SickExplosion(ent, amount)
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
			local vec = AngleRand():Forward()*math.random(100, 5000)
			vec.z = math.abs(vec.z)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec*0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function MW_SiloSmoke(ent, amount)
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 1, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos()+Vector(math.random(-30, 30), math.random(-30, 30), 0) ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(1.0, 2.0) ) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( math.random(10, 20) )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(50)
			local vec = Vector(0,0,math.random(100, 500))
			vec.z = math.abs(vec.z)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end
--[[
-- New Year
function MW_Firework(ent, amount, sizeMul)
	if (CurTime()-ent:GetCreationTime() < 5) then return end

	local grounded = false
	local tr = util.QuickTrace( ent:GetPos(), Vector(0,0,-20), ent )
	if (tr.Hit) then
		grounded = true
	end
	local particleSize = math.random(12, 18)
	local fireworkSize = math.random(300, 400)*sizeMul
	local teamColor = ent:GetColor();
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 0, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(1.0, 4.0)*sizeMul ) -- How long the particle should "live"
			local c = math.Rand(0.0, 1.0)
			local _c = 1-c
			part:SetColor(teamColor.r*c+255*_c,teamColor.g*c+255*_c,teamColor.b*c+255*_c)
			part:SetStartAlpha( 255 ) -- Starting alpha of the particle
			part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime
			part:SetStartSize( particleSize ) -- Starting size
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(300)
			part:SetGravity( Vector( 0, 0, -20 ) ) -- Gravity of the particle
			local vec = AngleRand():Forward()*fireworkSize
			if (grounded and vec.z < 0) then vec.z = -vec.z end
			part:SetVelocity( vec ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end
]]
local function MyCalcView( ply, pos, angles, fov )
	if not IsValid(ply.controllingUnit) then return end
	local cUnit = ply.controllingUnit
	local view = {}

	view.origin = cUnit:GetPos()+Vector(0,0,15+cUnit:OBBMaxs().z)-angles:Forward()*50
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	local targetPos = util.QuickTrace( view.origin, angles:Forward()*50000, cUnit ).HitPos
	LocalPlayer().controlTrace = util.QuickTrace( cUnit:GetPos(), (targetPos-cUnit:GetPos()):GetNormalized()*cUnit:GetNWFloat("range", 1000), cUnit )
	return view
end
hook.Add( "CalcView", "MelonWars_MyCalcView", MyCalcView )

local function MW_Move( ply, mv )
	if not IsValid( ply.controllingUnit ) then return end
	return true
end
hook.Add( "Move", "MelonWars_MoveUnit", MW_Move )

net.Receive( "MWControlUnit" , function(len, pl)
	local u = net.ReadEntity()
	LocalPlayer().controllingUnit = u
end)

net.Receive( "MW_UnitDecoration", function(len, pl)
	local entity = net.ReadEntity()
	local tbl = net.ReadTable()

	local prop = ClientsideModel( tbl.prop )
	prop:SetPos(entity:GetPos()+VectorRand(-3, 3))
	prop:SetAngles(AngleRand())
	prop:SetModelScale(tbl.scale)
	prop:SetMoveParent(entity)
	local cdata = EffectData()
	cdata:SetEntity(prop)
	util.Effect("propspawn", cdata)
end)

net.Receive( "MWColourMod", function(len, pl)
	LocalPlayer().MWhasColourModifier = net.ReadBool()
	LocalPlayer().MWColourModifierTable = net.ReadTable()
	DrawColorModify(LocalPlayer().MWColourModifierTable)
end)

hook.Add( "RenderScreenspaceEffects", "MelonWars_ColourMod", function()
	if not LocalPlayer().MWhasColourModifier then return end
	DrawColorModify( LocalPlayer().MWColourModifierTable )
end )

net.Receive( "MelonWars_ClientModifySpawnTime", function( len, pl )
	local spawnTimeChange = net.ReadFloat()
	-- LocalPlayer().mw_spawntime = LocalPlayer().mw_spawntime + spawnTimeChange
	LocalPlayer().spawnTimeMult = ( 1 + spawnTimeChange )
end )