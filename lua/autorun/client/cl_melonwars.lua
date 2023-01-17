if engine.ActiveGamemode() ~= "sandbox" then return end

mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
mw_team_colors[0] = Color(100,100,100,255)

function MW_BeginSelection() -- Previously concommand.Add( "+mw_select", function( ply )
	local ply = LocalPlayer()
	ply.mw_selecting = true
	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ( ent:GetClass() ~= "player" ) then return true end end,
		mask = MASK_SOLID + MASK_WATER
	} )

	ply.mw_selectionStartingPoint = trace.HitPos
	ply.mw_selectionEndingPoint = trace.HitPos
	sound.Play( "buttons/lightswitch2.wav", ply:GetPos(), 75, 100, 1 )

	if ply:KeyDown( IN_SPEED ) then return end
	if not istable( ply.foundMelons ) then return end

	table.Empty( ply.foundMelons )
end

net.Receive( "MW_ReturnSelection", function( len, pl )
	local returnedSelectionID = net.ReadInt(20)

	if returnedSelectionID ~= LocalPlayer().mw_selectionID then return end
	local count = net.ReadUInt(16)
	-- local newTable = {}

	for i = 0, count do
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
function MW_UpdateGhostEntity(model, pos, offset, angle, newColor, ghostSphereRange, ghostSpherePos)
	if (newColor == nil) then
		newColor = Color(100,100,100)
	end
	if (tostring( LocalPlayer().GhostEntity ) == "[NULL Entity]" or not IsValid( LocalPlayer().GhostEntity )) then
		LocalPlayer().GhostEntity = ents.CreateClientProp( model )
		LocalPlayer().GhostEntity:SetSolid( SOLID_VPHYSICS );
		LocalPlayer().GhostEntity:SetMoveType( MOVETYPE_NONE )
		LocalPlayer().GhostEntity:SetNotSolid( true );
		LocalPlayer().GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
		LocalPlayer().GhostEntity:SetRenderFX( kRenderFxPulseFast )
		LocalPlayer().GhostEntity:SetMaterial( "models/debug/debugwhite" )
		LocalPlayer().GhostEntity:SetColor( Color( newColor.r * 1.5, newColor.g * 1.5, newColor.b * 1.5, 150 ) )
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
		obbmins:Rotate( angle )
		obbmaxs:Rotate( angle )
		local mins = Vector( LocalPlayer().GhostEntity:GetPos().x + obbmins.x, LocalPlayer().GhostEntity:GetPos().y + obbmins.y, pos.z + 5 )
		local maxs = Vector( LocalPlayer().GhostEntity:GetPos().x + obbmaxs.x, LocalPlayer().GhostEntity:GetPos().y + obbmaxs.y, pos.z + 20 )
		local overlappingEntities = ents.FindInBox( mins, maxs )
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
		if LocalPlayer().mw_action == 1 and not mw_units[LocalPlayer():GetInfoNum( "mw_chosen_unit", 0 )].canOverlap then
			for k, v in pairs( overlappingEntities ) do
				if v.Base ~= nil and string.StartWith( v.Base, "ent_melon_" ) then
					LocalPlayer().canPlace = false
				end
			end
		end
		if LocalPlayer().canPlace then
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
			LocalPlayer().GhostSphere:SetColor( Color( newColor.r * 1.5, newColor.g * 1.5, newColor.b * 1.5, 50 ) )
			LocalPlayer().GhostSphere:SetModelScale( 0.021 * ghostSphereRange )
			LocalPlayer().GhostSphere:Spawn()
		end
	else
		if (LocalPlayer().mw_action == 1 and ghostSphereRange > 0) then
			local color = LocalPlayer().GhostSphere:GetColor()
			LocalPlayer().GhostSphere:SetColor( Color(color.r, color.g, color.b, 50) )
			LocalPlayer().GhostSphere:SetPos( Vector(pos.x, pos.y, ghostSpherePos.z ) )
			LocalPlayer().GhostSphere:SetModelScale( 0.021 * ghostSphereRange )
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
	mrtsNetworkBuffer = mrtsNetworkBuffer .. data
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

	for i = 1, table.Count(contrapFiles) do
		timer.Simple( i * 0.1, function()
			local name = string.gsub(contrapFiles[i], ".txt", "") -- Removes .txt from the name, because other parts of the code add it back in later

			local text =  file.Read( "melonwars/contraptions/" .. contrapFiles[i], "DATA" )
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
			print("Validated " .. tostring(i) .. " contraption files")
		end)
	end
end)

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
	frame:SetPos( ScrW() / 2 - w / 2 + 150, ScrH() / 2 - h / 3 )
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
	for i = 1, 8 do
		button = vgui.Create("DButton", frame)
		button:SetSize(29,100)
		button:SetPos( 5 + 30 * ( i - 1 ), 50 )
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
	frame:SetPos( ScrW() / 2 - w / 2 + 150, ScrH() / 2 - h / 3 )
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
	frame:SetPos( ScrW() / 2 - w / 2 + 150, ScrH() / 2 - h / 3 )
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
			local vec = AngleRand():Forward() * math.random(10, 50)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec * 0.8 ) -- Initial velocity of the particle
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
			local vec = AngleRand():Forward() * math.random(100, 5000)
			vec.z = math.abs(vec.z)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec * 0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function MW_SiloSmoke(ent, amount)
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 1, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() + Vector(math.random(-30, 30), math.random(-30, 30), 0) ) -- Create a new particle at pos
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

net.Receive( "MWControlUnit" , function(len, pl)
	local u = net.ReadEntity()
	LocalPlayer().controllingUnit = u
end)

net.Receive( "MW_UnitDecoration", function(len, pl)
	local entity = net.ReadEntity()
	local tbl = net.ReadTable()

	local prop = ClientsideModel( tbl.prop )
	prop:SetPos( entity:GetPos() + VectorRand( -3, 3 ) )
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

net.Receive( "MelonWars_ClientModifySpawnTime", function( len, pl )
	local spawnTimeChange = net.ReadFloat()
	-- LocalPlayer().mw_spawntime = LocalPlayer().mw_spawntime + spawnTimeChange
	LocalPlayer().spawnTimeMult = ( 1 + spawnTimeChange )
end )