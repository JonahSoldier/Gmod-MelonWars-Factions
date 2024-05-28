if engine.ActiveGamemode() ~= "sandbox" then return end

-- Some lines from the cl_spawnmenu.lua in the sandbox GM
-- function GM:Initialize()
-- Net vars for sending the team and credits to the client
util.AddNetworkString( "MW_TeamCredits" )
util.AddNetworkString( "MW_TeamUnits" )
util.AddNetworkString( "MW_UpdateClientInfo" )
util.AddNetworkString( "MW_UpdateServerInfo" )

util.AddNetworkString( "MW_SelectContraption" )
util.AddNetworkString( "MW_RequestSelection" )
util.AddNetworkString( "MW_ReturnSelection" )
util.AddNetworkString( "MW_Order" )
util.AddNetworkString( "MW_Stop" )
util.AddNetworkString( "MW_SpawnUnit" )
util.AddNetworkString( "MW_UnitDecoration" )
util.AddNetworkString( "SpawnBase" )
util.AddNetworkString( "SpawnBaseGrandWar" )
util.AddNetworkString( "SpawnBaseUnit" )
util.AddNetworkString( "SpawnCapturePoint" )
util.AddNetworkString( "SpawnOutpost" )
util.AddNetworkString( "MW_SpawnWaterTank" )
util.AddNetworkString( "MW_SpawnProp" )
util.AddNetworkString( "StartGame" )
util.AddNetworkString( "SandboxMode" )

util.AddNetworkString( "ToggleBarracks" )
util.AddNetworkString( "MW_Activate" )
util.AddNetworkString( "PropellerReady" )
util.AddNetworkString( "MW_UseWaterTank" )

util.AddNetworkString( "RestartQueue" )
util.AddNetworkString( "SellEntity" )

util.AddNetworkString( "UpdateClientTeams" )
util.AddNetworkString( "UpdateServerTeams" )

-- Contraptions
util.AddNetworkString( "ContraptionSave" )
util.AddNetworkString( "BeginContraptionSaveClient" )
util.AddNetworkString( "ContraptionSaveClient" )
util.AddNetworkString( "BeginContraptionLoad" )
util.AddNetworkString( "ContraptionLoad" )
util.AddNetworkString( "RequestContraptionLoadToAssembler" )
util.AddNetworkString( "RequestContraptionLoadToClient" )
util.AddNetworkString( "ContraptionAutoValidate" )
util.AddNetworkString( "ContraptionValidateClient" )
util.AddNetworkString( "LegalizeContraption" )

util.AddNetworkString( "MW_ServerControlUnit" )
util.AddNetworkString( "MW_ClientControlUnit" )
util.AddNetworkString( "MWControlShoot" )

util.AddNetworkString( "MWBrute" )

-- (Most of) JonahSoldier's network stuff
util.AddNetworkString( "MWColourMod" )
util.AddNetworkString( "SetMWConvar" )
util.AddNetworkString( "MWReadyUp" )
util.AddNetworkString( "MW_ClientModifySpawnTime" )

MelonWars = MelonWars or {}

include("melonwars/sh_unitlist.lua")
include("melonwars/sh_miscfunctions.lua")

net.Receive( "SetMWConvar", function( _, pl )
	local openPerms = GetConVar( "mw_admin_open_permits" ):GetBool()

	if not pl:IsAdmin() or openPerms then return end

	local convar = net.ReadString()
	local newValue = net.ReadBool()

	if not string.StartWith( convar, "mw_" ) then return end -- NOTE: Switch to StartsWith when/if all Gmod branches are updated to the January 2023 patch

	GetConVar( convar ):SetBool( newValue )
end )

net.Receive( "MWReadyUp", function()
	local ReadyCount = 0
	for _, v in ipairs( player.GetAll() ) do
		ReadyCount = ReadyCount + v:GetInfoNum( "mw_player_ready", 0 ) -- Adds all values of mw_player_ready to the readycount
	end

	if ReadyCount / #player.GetAll() <= GetConVar( "mw_admin_readyup_percentage" ):GetFloat() then return end
	-- This really isn't a good way to do this, but I'm not sure if there's any way to directly call the code without having to do something else fucky like
	-- Sending more signals between the client and server to trigger the network function meant to do this.

	for i = 0, 4 do
		timer.Simple( i, function()
			for _, v in ipairs( player.GetAll() ) do
				v:PrintMessage( HUD_PRINTCENTER, "Match starts in " .. ( 5 - i ) )
			end
		end )
	end

	timer.Simple( 5, function ()
		RunConsoleCommand( "mw_admin_playing", 1 )
		RunConsoleCommand( "mw_admin_move_any_team", 0 )
		RunConsoleCommand( "mw_admin_credit_cost", 1 )
		RunConsoleCommand( "mw_admin_allow_free_placing", 0 )
		RunConsoleCommand( "mw_admin_spawn_time", 1 )
		RunConsoleCommand( "mw_admin_immortality", 0 )
		RunConsoleCommand( "mw_reset_credits" )
		net.Start( "RestartQueue" )
		net.Broadcast()

		for _, v in ipairs( player.GetAll() ) do
			sound.Play( "garrysmod/content_downloaded.wav", v:GetPos() + Vector( 0, 0, 45 ), 100, 40, 1 )
			v:PrintMessage( HUD_PRINTCENTER, "The MelonWars match has begun!" )
			v:PrintMessage( HUD_PRINTTALK, "== The MelonWars match has begun! ==" )
		end
	end )
end )

MelonWars.teamColors = {
	Color(255,50,50,255),
	Color(50,50,255,255),
	Color(255,200,50,255),
	Color(30,200,30,255),
	Color(100,0,80,255),
	Color(100,255,255,255),
	Color(255,120,0,255),
	Color(255,100,150,255)
}

--[[
mw_special_steam_decoration = {}
--  Doorsday
mw_special_steam_decoration["STEAM_0:0:165277892"] = {
	prop = "models/props_c17/door01_left.mdl",
	scale = 0.2,
	chance = 0.2
}
]]--
MelonWars.specialSteamSkins = {}
--  Marum
MelonWars.specialSteamSkins["STEAM_0:0:29138250"] = {
	material = "models/shiny",
	trail = "trails/laser",
	length = 1,
	startSize = 60,
	endSize = 60,
	teamcolor = 0.1
}-- trails/laser

--  JonahSoldier
MelonWars.specialSteamSkins["STEAM_0:0:16826885"] = {
	material = "phoenix_storms/gear",
	trail = "trails/physbeam",
	length = 0.5,
	startSize = 15,
	endSize = 0,
	teamcolor = 0.5
}-- trails/physbeam

--  VarixDog
MelonWars.specialSteamSkins["STEAM_0:1:101608555"] = {
	material = "phoenix_storms/plastic",
	trail = "trails/lol",
	length = 0.5,
	startSize = 15,
	endSize = 15,
	teamcolor = 1
}-- trails/lol

--  EvilDuckGuy
MelonWars.specialSteamSkins["STEAM_0:0:460204826"] = {
	material = "models/combine_scanner/scanner_eye",
	trail = "effects/beam_generic01",
	length = 0.5,
	startSize = 15,
	endSize = 15,
	teamcolor = 1
}-- effects/beam_generic01

--  MerekiDor
MelonWars.specialSteamSkins["STEAM_0:1:93155236"] = {
	material = "phoenix_storms/cube",
	trail = "trails/smoke",
	length = 0.5,
	startSize = 15,
	endSize = 0,
	teamcolor = 0.5
}-- trails/smoke

MelonWars.teamCredits = {2000,2000,2000,2000,2000,2000,2000,2000}
MelonWars.teamUnits = {0,0,0,0,0,0,0,0}

MelonWars.teamGrid = MelonWars.teamGrid or {}

net.Receive( "MW_SelectContraption", function( _, pl )
	local count = net.ReadUInt( 16 )
	local entities = {}
	for i = 0, count do
		table.insert( entities, net.ReadEntity() )
	end
	local extraEntities = {}
	if istable( entities ) then
		for _, v in ipairs( entities ) do
			local constrained = constraint.GetAllConstrainedEntities( v )
			if istable( constrained ) then
				for _, vv in pairs( constrained ) do
					if entities[vv] or extraEntities[vv] then return end
					print( "Added constrained entity " .. tostring( vv ) )
					table.insert( extraEntities, vv )
				end
			end
		end
	end

	local extraCount = #extraEntities
	net.Start( "MW_SelectContraption" )
		net.WriteUInt( extraCount, 16 )
		for _, v in ipairs( extraEntities ) do
			net.WriteEntity( v )
		end
	net.Send( pl )
end )

net.Receive( "MW_RequestSelection", function( _, pl )
	local selectionID = net.ReadInt(20)
	local typeSelect = net.ReadString()
	local center = net.ReadVector()
	local radius = net.ReadFloat()
	local hitEnt = net.ReadEntity()

	-- local allFoundEntities = ents.FindInSphere( center, radius ) -- I'm guessing this is part of the workaround for selection glitch
	local allFoundEntities = {}
	local foundEntities = {}

	if radius > 15 then
		local heightTrace = util.TraceLine( {
			start = center,
			endpos = center + Vector(0,0,2000),
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end,
			mask = MASK_SOLID + MASK_WATER
		} )

		local depthTrace = util.TraceLine( {
			start = center,
			endpos = center - Vector(0,0,2000),
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end,
			mask = MASK_SOLID + MASK_WATER
		} )

		local depth = depthTrace.HitPos:Distance(center)
		local height = heightTrace.HitPos:Distance(center) -- Using the normal distance function is a bit more computationally expensive but hopefully this shouldn't be bad enough to be an issue

		if depth < 25 then depth = 25 end
		if height < 25 then height = 25 end

		if hitEnt:GetClass() == "ent_melon_jetpack" then
			allFoundEntities = ents.FindInBox(center - Vector(radius,radius,50), center + Vector(radius,radius,50) )
		else
			allFoundEntities = ents.FindInBox(center - Vector(radius,radius,depth-1), center + Vector(radius,radius,height-1) )
		end

		local xCoord, yCoord, zCoord = center:Unpack()
		local processedCenter = Vector(xCoord, yCoord, 0) -- probably a better way to do this, I tried multiplying by a vector but that broke the code

		for k, v in pairs(allFoundEntities) do
			local xCoord2, yCoord2, zCoord2 = v:GetPos():Unpack()
			local processedPosition = Vector(xCoord2, yCoord2, 0)
			if processedPosition:DistToSqr(processedCenter) > radius * radius then -- makes sure we select in just a cylinder, not a box.
				table.remove( allFoundEntities, k )
			end
		end
	else
		if hitEnt.Base == "ent_melon_base" then
			table.Empty(allFoundEntities)
			table.insert(allFoundEntities, 1, hitEnt)
		else
			allFoundEntities = ents.FindInSphere( center, 10 )
		end
	end

	local classCheck, canMove, notZone, typeSelectCheck
	for _, v in ipairs( allFoundEntities ) do
		classCheck = string.StartWith( v:GetClass(), "ent_melon_" )
		canMove = cvars.Bool( "mw_admin_move_any_team", false ) or v:GetNWInt( "mw_melonTeam", -1 ) == pl:GetInfoNum( "mw_team", -2 )
		notZone = v:GetClass() ~= "ent_melon_zone"
		typeSelectCheck = typeSelect == ( "nil" or v:GetClass() )
		if classCheck and canMove and notZone and typeSelectCheck then
			table.insert( foundEntities, v )
		end
	end

	local foundCount = #foundEntities
	net.Start("MW_ReturnSelection")
		net.WriteInt(selectionID, 20)
		net.WriteUInt(foundCount, 16)
		for _, v in ipairs(foundEntities) do
			net.WriteEntity(v)
		end
	net.Send(pl)
end )

net.Receive( "MW_Activate", function()
	local ent = net.ReadEntity()
	local team = net.ReadInt(8)
	if team == ent:GetNWInt( "mw_melonTeam", 0 ) then
		ent:Actuate()
	end
end )

net.Receive( "MW_UpdateClientInfo", function( _, pl )
	local a = net.ReadInt(8)

	if a ~= 0 then
		net.Start("MW_TeamCredits")
			net.WriteInt(MelonWars.teamCredits[a] ,32)
		net.Send(pl)
		net.Start("MW_TeamUnits")
			net.WriteInt(MelonWars.teamUnits[a] ,16)
		net.Send(pl)
	else
		net.Start("MW_TeamCredits")
			net.WriteInt(20000 ,32)
		net.Send(pl)
		net.Start("MW_TeamUnits")
			net.WriteInt(0 ,16)
		net.Send(pl)
	end
end )

net.Receive( "MW_UpdateServerInfo", function()
	local a = net.ReadInt(8)
	MelonWars.teamCredits[a] = net.ReadInt(32)
end )

net.Receive( "ToggleBarracks", function()
	local ent = net.ReadEntity()
	local on = ent:GetNWBool( "active", false )
	if on then
		ent:SetNWBool( "active", false )
	else
		ent:SetNWBool( "active", true )
	end
end )

net.Receive( "PropellerReady", function()
	local ent = net.ReadEntity()
	ent:SetNWBool("done",true)
	local foundEnts = ents.FindInSphere(ent:GetPos(), 600 )
	for _, v in pairs( foundEnts ) do
		if v:GetClass() == "ent_melon_propeller" or v:GetClass() == "ent_melon_hover" then
			v:SetNWBool("done",true)
		end
	end
end )

net.Receive( "MW_UseWaterTank", function( _, pl )
	local ent = net.ReadEntity()
	local _team = ent:GetNWInt("capTeam", -1)
	if _team ~= pl:GetInfoNum( "mw_team", -1 ) then return end

	MelonWars.teamCredits[_team] = MelonWars.teamCredits[_team] + ent.waterVal
	for _, v in ipairs( player.GetAll() ) do
		if v:GetInfo( "mw_team" ) == tostring( _team ) then
			net.Start( "MW_TeamCredits" )
				net.WriteInt( MelonWars.teamCredits[_team], 32 )
			net.Send( v )
			v:PrintMessage( HUD_PRINTTALK, "== Received " .. ent.waterVal .. " water! ==" )
		end
	end

	local effectData1 = EffectData()
	effectData1:SetOrigin( ent:GetPos() )
	for i = 0, 10 do
		util.Effect( "balloon_pop", effectData1 )
	end
	local effectData2 = EffectData()
	effectData2:SetOrigin( ent:GetPos())
	effectData2:SetScale(10)
	util.Effect( "watersplash", effectData2 )
	ent:Remove()
end )

local function MW_Server_UpdateWater( team, credits )
	MelonWars.teamCredits[team] = credits
end

net.Receive( "MW_SpawnUnit", function( _, pl ) --TODO: This requires substantial cleanup. "CanSpawnUnit" should probably be created as a shared function to make this all cleaner and consistent.
	local unit_index = net.ReadInt(16)
	local _team = net.ReadInt(4)
	local attach = net.ReadBool()
	local angle = net.ReadAngle()

	local trace = pl:GetEyeTrace( {mask = MASK_SOLID + MASK_WATER} ) --Does setting mask here actually work? I can't remember if Marum did this in the original or if I did it.
	local position = trace.HitPos + vector_up + trace.HitNormal * 5 + MelonWars.units[unit_index].offset --Lets see if this gets horribly de-synced between client and server!

	local unit = MelonWars.units[unit_index]
	local class = unit.class
	local cost
	cost, attach = MelonWars.unitCost(unit_index, attach)
	local spawndelay = unit.spawn_time

	if not MelonWars.canSpawn( unit_index, attach, _team, position, pl, trace.Entity ) then
		return
	end

	--Copied from client,
	pl.mw_spawntime = pl.mw_spawntime or 0
	if (cvars.Number("mw_admin_spawn_time") == 1) then
		if (cvars.Bool("mw_admin_allow_free_placing") or MelonWars.units[unit_index].buildAnywere or MelonWars.isInRange(trace.HitPos, mw_melonTeam) or mw_melonTeam == 0) then
			if (pl.mw_spawntime < CurTime()) then
				pl.mw_spawntime = CurTime() + MelonWars.units[unit_index].spawn_time * (pl.spawnTimeMult or 1) -- spawntimemult has been added here so I can compensate for matches with uneven numbers of commanders
			else
				pl.mw_spawntime = pl.mw_spawntime + MelonWars.units[unit_index].spawn_time * (pl.spawnTimeMult or 1)
			end
		end
	end
	local spawntime = pl.mw_spawntime

	local newMarine = MelonWars.spawnUnitAtPos(class, unit_index, position --[[trace.HitPos + trace.HitNormal * 5]], angle, cost, spawntime, _team, attach, trace.Entity, pl, spawndelay)

	undo.Create("Melon " .. unit.name)
		undo.AddEntity( newMarine )
		undo.SetPlayer( pl)
	undo.Finish()

	if cvars.Bool("mw_admin_credit_cost") or _team == 0 then
		MW_Server_UpdateWater(_team, MelonWars.teamCredits[_team]-cost)
	end
end )

function MelonWars.spawnUnitAtPos( class, unit_index, pos, ang, cost, spawntime, _team, attach, parent, pl, spawndelay )
	local newMarine = ents.Create( class )
	if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail

	newMarine:SetPos( pos)
	newMarine:SetAngles( ang)

	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 )

	if (IsValid(pl)) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
	end
	mw_melonTeam = _team

	newMarine.mw_spawntime = spawntime
	newMarine:Spawn()
	newMarine:SetNWFloat("spawnTime", spawntime)
	newMarine:SetNWInt("mw_melonTeam", _team)

	if (unit_index == -1 or unit_index == -2) then --si es un motor o un propeller
		newMarine:GetPhysicsObject():EnableCollisions( false )
	end

	if (attach) then
		newMarine:SetCollisionGroup( COLLISION_GROUP_DISSOLVING )
		if (tostring(parent) ~= "[NULL Entity]") then
			newMarine:Welded(newMarine, parent)
		else
			newMarine:SetMoveType(MOVETYPE_NONE)
			newMarine:Welded(newMarine, game.GetWorld())
		end
	end

	newMarine:Ini(_team)

	if (IsValid(pl)) then
		pl.mw_melonTeam = _team
		if (class ~= "ent_melon_unit_transport") then --  disable physgun grab / pickup for everything but except the unit transport
			newMarine:SetOwner(pl)
		end

		if (pl:GetInfo( "mw_enable_skin" ) == "1") then
			local _skin = MelonWars.specialSteamSkins[pl:SteamID()]
			if _skin ~= nil and _skin.material ~= nil then
				newMarine:SkinMaterial( _skin.material )
				-- if (_skin.trail ~= nil) then
				-- 	local color = Color(newMarine:GetColor().r*_skin.teamcolor+255*(1-_skin.teamcolor), newMarine:GetColor().g*_skin.teamcolor+255*(1-_skin.teamcolor), newMarine:GetColor().b*_skin.teamcolor+255*(1-_skin.teamcolor))
				-- 	util.SpriteTrail( newMarine, 0, color, false, _skin.startSize, _skin.endSize, _skin.length, 1 / _skin.startSize * 0.5, _skin.trail )
				-- end
			end
			--[[_skin = mw_special_steam_decoration["STEAM_0:0:165277892"]-- [pl:SteamID()]
			if (_skin ~= nil) then
				if (math.Rand(0, 1) < _skin.chance) then
					timer.Simple(1, function()
						print("Sending msg")
						net.Start("MW_UnitDecoration")
							net.WriteEntity(newMarine)

							net.WriteTable(_skin)
						net.Broadcast()
					end)
				end
			end]]--
		end
	end

	newMarine.realvalue = cost
	newMarine.spawnDelay = spawndelay

	if (cvars.Bool("mw_admin_credit_cost")) then
		newMarine.value = cost
	else
		newMarine.value = 0
	end

	return newMarine
end

local function MW_CalculateContraptionValues( betadupetable )
	local cost = 0
	local power = 0

	--  Verify entities
	for _, v in pairs(betadupetable.Entities) do
		if v.Class == "prop_physics" then
			cost = cost + v.Cost
		elseif string.StartWith(v.Class, "ent_melon_") then
			local unit_data = MelonWars.units[mw_unit_ids[v.Class]]
			if unit_data.welded_cost == -1 and (unit_data.contraptionPart == nil or unit_data.contraptionPart == false) then
				return "A non weldable unit can't be part of a contraption!", 0, 0
			else
				cost = cost + unit_data.welded_cost
				power = power + unit_data.population
			end
		end
	end

	--  Verify constraints
	for _, v in pairs(betadupetable.Constraints) do
		local entities = betadupetable.Entities
		if v.Type == "Weld" then
			local ent1isMelon = false
			if string.StartWith( entities[v.Ent1].Class, "ent_melon_" ) then ent1isMelon = true end
			local ent2isMelon = false
			if string.StartWith( entities[v.Ent2].Class, "ent_melon_" ) then ent2isMelon = true end

			if (not ent1isMelon and not ent2isMelon) then
				constraint.Weld( entities[v.Ent1], entities[v.Ent2], v.Bone1, v.Bone2, v.forcelimit, v.nocollide, true )
			elseif (ent1isMelon and ent2isMelon) then
				--  Units can't be welded to other units
				return "Units can't be welded to other units!", 0, 0
			end

		elseif v.Type == "Axis" then
			local ent1isMelon = false
			if string.StartWith( entities[v.Ent1].Class, "ent_melon_" ) then ent1isMelon = true end
			local ent2isMelon = false
			if string.StartWith( entities[v.Ent2].Class, "ent_melon_" ) then ent2isMelon = true end

			if (not ent1isMelon or not ent2isMelon) then
			else
				--  Units can't be welded to other units
				return "Units can't have Axis with other units!", 0, 0
			end

		elseif (v.Type == "Ballsocket") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon = true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon = true end

			if (not ent1isMelon and not ent2isMelon) then
			else
				--  Units can't be welded to other units
				return "Units can't have Ballsockets!", 0, 0
			end

		elseif (v.Type == "Slider") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon = true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon = true end

			if (not ent1isMelon and not ent2isMelon) then
			else
				--  Units can't be welded to other units
				return "Units can't have Sliders!", 0, 0
			end

		elseif (v.Type == "NoCollide") then
			local ent1isMelon = false
			if (string.StartWith(entities[v.Ent1].Class, "ent_melon_")) then ent1isMelon = true end
			local ent2isMelon = false
			if (string.StartWith(entities[v.Ent2].Class, "ent_melon_")) then ent2isMelon = true end

			if (not ent1isMelon or not ent2isMelon) then
			else
				--  Units can't be welded to other units
				return "Units can't have No Collide with other units!", 0, 0
			end
		end
	end

	return "success", cost, power
end

local function MW_GetBetaContraptionTable( dupetable )
	local betadupetable = {}

	-- Save Entities
	betadupetable.Entities = {}

	for k, v in pairs(dupetable.Entities) do
		betadupetable.Entities[k] = {}
		betadupetable.Entities[k].Class = v.Class
		if (v.Class == "prop_physics") then
			betadupetable.Entities[k].EntIndex = k
			betadupetable.Entities[k].Angles = v.Angle
			betadupetable.Entities[k].Pos = v.Pos
			betadupetable.Entities[k].Model = v.Model
			betadupetable.Entities[k].Cost = v.realvalue
		elseif (string.StartWith(v.Class, "ent_melon_")) then
			betadupetable.Entities[k].EntIndex = k
			betadupetable.Entities[k].Angles = v.Angle
			betadupetable.Entities[k].Pos = v.Pos
		end
	end

	--  Save Constraints
	betadupetable.Constraints = {}
	for k, v in pairs(dupetable.Constraints) do
		betadupetable.Constraints[k] = {}
		betadupetable.Constraints[k].Type = v.Type
		if (v.Type == "Weld") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].forcelimit = v.forcelimit
			betadupetable.Constraints[k].nocollide = v.nocollide
		elseif (v.Type == "Axis") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].LPos1 = v.LPos1
			betadupetable.Constraints[k].LPos2 = v.LPos2
			betadupetable.Constraints[k].forcelimit = v.forcelimit
			betadupetable.Constraints[k].torquelimit = v.torquelimit
			betadupetable.Constraints[k].friction = v.friction
			betadupetable.Constraints[k].nocollide = v.nocollide
			betadupetable.Constraints[k].LocalAxis = v.LocalAxis
		elseif (v.Type == "Ballsocket") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].forcelimit = v.forcelimit
			betadupetable.Constraints[k].torquelimit = v.torquelimit
			betadupetable.Constraints[k].nocollide = v.nocollide
			betadupetable.Constraints[k].LPos = v.LPos
		elseif (v.Type == "Slider") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
			betadupetable.Constraints[k].LPos1 = v.LPos1
			betadupetable.Constraints[k].LPos2 = v.LPos2
			betadupetable.Constraints[k].width = v.width
			betadupetable.Constraints[k].material = v.material
		elseif (v.Type == "NoCollide") then
			betadupetable.Constraints[k].Ent1 = v.Ent1:EntIndex()
			betadupetable.Constraints[k].Ent2 = v.Ent2:EntIndex()
			betadupetable.Constraints[k].Bone1 = v.Bone1
			betadupetable.Constraints[k].Bone2 = v.Bone2
		end
	end

	--  Data
	betadupetable.Maxs = dupetable.Maxs
	betadupetable.Mins = dupetable.Mins

	local result, cost, power = MW_CalculateContraptionValues( betadupetable )

	betadupetable.Cost = cost
	betadupetable.Power = power

	return betadupetable
end

net.Receive( "ContraptionSave", function( _, pl )
	local name = net.ReadString()
	local entity = net.ReadEntity()

	if entity:IsWorld() then return end
	local entities = constraint.GetAllConstrainedEntities( entity )
	for _, v in pairs(entities) do
		if v:GetClass() == "prop_physics" then
			v.realvalue = math.min(1000, v:GetPhysicsObject():GetMass()) -- This determines prop price
		end
	end

	duplicator.SetLocalPos( pl:GetEyeTrace().HitPos )
	local dupetable = duplicator.Copy(entity)
	duplicator.SetLocalPos( Vector(0,0,0) )

	local dubJSON

	if cvars.Bool("mw_admin_contraptions_beta") then
		print("Saved contraption with the BETA method")
		local betadupetable = MW_GetBetaContraptionTable( dupetable )

		dubJSON = util.TableToJSON(betadupetable)
		print(dubJSON)
	else
		print("Saved contraption with the CLASSIC method")
		dubJSON = util.TableToJSON(dupetable)
	end

	local text = dubJSON
	local compressed_text = util.Compress( text )
	if not compressed_text then compressed_text = text end
	local len = string.len( compressed_text )
	local send_size = 60000
	local parts = math.ceil( len / send_size )
	local start = 0
	net.Start( "BeginContraptionSaveClient" )
		net.WriteString(name)
		net.WriteEntity(pl)
	net.Send(pl)
	for i = 1, parts do
		local endbyte = math.min( start + send_size, len )
		local size = endbyte - start
		local data = compressed_text:sub( start + 1, endbyte + 1 )
		net.Start( "ContraptionSaveClient" )
			net.WriteBool( i == parts )
			net.WriteUInt( size, 16 )
			net.WriteData( data, size )
		net.Send(pl)
		start = endbyte
	end
end )

MelonWars.messageReceivingEntity = nil
MelonWars.messageReceivingState = "idle"
MelonWars.networkBuffer = ""

net.Receive( "BeginContraptionLoad", function()
	if MelonWars.messageReceivingState ~= "idle" then return end
	local pl = net.ReadEntity()
	MelonWars.messageReceivingEntity = pl
	MelonWars.messageReceivingState = tostring( pl )
	MelonWars.networkBuffer = ""
end )

net.Receive( "ContraptionLoad", function( _, pl )
	undo.Create("Melon Contraption")

	local last = net.ReadBool()
	local size = net.ReadUInt(16)
	local data = net.ReadData(size)

	-- local text = util.Decompress(data)
	MelonWars.networkBuffer = MelonWars.networkBuffer .. data

	if not last then return end
	local text = util.Decompress(MelonWars.networkBuffer)
	local dupetable = util.JSONToTable( text )
	local ent = MelonWars.messageReceivingEntity
	local pos
	if (ent:GetClass() == "player") then
		pos = ent:GetEyeTrace().HitPos
	else
		pos = ent:GetPos()
	end

	-- local constraints
	local localpos = pos - Vector( ( dupetable.Maxs.x + dupetable.Mins.x ) / 2, ( dupetable.Maxs.y + dupetable.Mins.y ) / 2, dupetable.Mins.z - 10 )

	duplicator.SetLocalPos( localpos )
	local paste = duplicator.Paste( player.GetByID( 0 ), dupetable.Entities, dupetable.Constraints )
	duplicator.SetLocalPos( Vector(0,0,0) )

	local mw_melonTeam = pl:GetInfoNum("mw_team", 0)
	for _, v in pairs(paste) do
		if (v.Base == "ent_melon_base") then
			-- v:Initialize()     -- (This deletes constraints)
			v:Ini(mw_melonTeam)
			v:SetCollisionGroup(2)

			if (pl:GetInfo( "mw_enable_skin" ) == "1") then
				local _skin = MelonWars.specialSteamSkins[pl:SteamID()]
				if _skin ~= nil and _skin.material ~= nil then
					v:SkinMaterial( _skin.material )
					-- if (_skin.trail ~= nil) then
					-- 	local color = Color(v:GetColor().r*_skin.teamcolor+255*(1-_skin.teamcolor), v:GetColor().g*_skin.teamcolor+255*(1-_skin.teamcolor), v:GetColor().b*_skin.teamcolor+255*(1-_skin.teamcolor))
					-- 	util.SpriteTrail( v, 0, color, false, _skin.startSize, _skin.endSize, _skin.length, 1 / _skin.startSize * 0.5, _skin.trail )
					-- end
				end
			end
		end
		if (v:GetClass() == "ent_melon_propeller" or v:GetClass() == "ent_melon_hover") then
			v:SetNWBool("done",true)
		end
		if not string.StartWith( v:GetClass(), "ent_melon") then
			v:SetColor(MelonWars.teamColors[mw_melonTeam])
			v:SetMaterial("")
			v:SetRenderFX(kRenderFxNone)
			v:SetNWInt("mw_melonTeam", mw_melonTeam)
			v:SetNWInt("propHP", math.min(1000,v:GetPhysicsObject():GetMass())) --max 1000 de vida
			v.realvalue = v:GetPhysicsObject():GetMass()
			-- hook.Run("MelonWars_EntitySpawned", v)
		end
		if (ent:GetClass() == "player") then
			v:SetVar("targetPos", pos)
			v:SetNWVector("targetPos", pos)
		else
			v:SetVar( "targetPos", ent.targetPos + Vector( 0, 0, 1 ) )
			v:SetNWVector( "targetPos", ent.targetPos + Vector( 0, 0, 1 ) )
			v:SetVar( "moving", true )
		end

		undo.AddEntity( v )
	end

	undo.SetPlayer( pl)
	undo.Finish()

	for _, v in pairs(paste) do
		v:GetPhysicsObject():EnableMotion(true)
	end

	MelonWars.messageReceivingEntity = nil
	MelonWars.messageReceivingState = "idle"
	MelonWars.networkBuffer = ""
end )

net.Receive( "ContraptionAutoValidate", function( _, pl ) --TODO: Rewrite. Probably replace entirely.
	local last = net.ReadBool()
	local size = net.ReadInt(16)
	local data = net.ReadData(size)
	local name = net.ReadString()

	MelonWars.networkBuffer = MelonWars.networkBuffer .. data

	if not last then return end
	local text = util.Decompress(MelonWars.networkBuffer)
	local dupetable = util.JSONToTable( text )
	-- local ent = MelonWars.messageReceivingEntity
	-- print(MelonWars.networkBuffer) -- prints [
	-- print(text) --  Returns the file properly.

	-- PrintTable(dupetable) --  Sometimes this is a table and sometimes it's nil?????????

	-- if (not istable(dupetable)) then --  Prints a list of the dupes that created the nil tables and the text that was sent.
	-- 	print(name)
	-- 	print(text)
	-- end

	--I'm pretty sure the thing that made this work got removed in one of Craft's refactoring passes. 
	--Not a big deal, since it was a shit way of going about it anyway. This needs to be replaced.
	local unitStatsValidation = util.JSONToTable(util.Decompress(file.Read("melonwars/validation/unitvalues.txt"))) -- hehehe this line of code is very long

	for _, v in pairs(dupetable) do
		if istable(v) then
			for _, i in pairs(v) do
				if (i.Base == "ent_melon_base") then
					-- Validation for melon entities.
					-- I could A: Reference a separate file with a list of all units and their default stats in it
					-- or B: Do the same thing as I wrote in the comment for props.

					local genericStatCheck = ents.Create(i.Class) -- should spawn and remove a melon entity. Use Mergetables or something here
					genericStatCheck:Spawn()

					genericStatCheck:Welded(genericStatCheck,genericStatCheck)
					table.Merge( i, genericStatCheck:GetTable())

					genericStatCheck:Remove()

					for _, p in pairs(unitStatsValidation) do -- I feel like I'm violating some sort of coding convention by doing this
						if i.Class == p.class then
							if p.welded_cost == nil or p.welded_cost == -1 then
								i.realvalue = p.cost
							else
								i.realvalue = p.welded_cost
								i.speed = 0
							end

							if i.spawnDelay == nil then
								-- This seems like a horrifically bad way to do this
								-- but I can't find the 'correct' way.

								local tableAdd = {}
								tableAdd["spawnDelay"] = p.spawn_time
								table.Add( i, tableAdd )
							else
								i.spawnDelay = p.spawn_time
							end
						end
					end
				end

				-- For some reason almost every file tries to check some table with almost nothing in it
				-- Class included, so I have to check if it's there first
				if i.Class ~= nil and not string.StartWith( i.Class,"ent_melon" ) then
					-- Spawns a prop and runs getmass on it to validate its price

					local propCheck = ents.Create("prop_physics")
					propCheck:SetModel(i.Model)
					propCheck:Spawn()

					i.realvalue = propCheck:GetPhysicsObject():GetMass()

					propCheck:Remove()
				end
			end
		end
	end

	-- tells melon wars to re-save the contraptions with the same name they had before, overwriting the old files.

	local compressed_text = util.Compress(util.TableToJSON(dupetable))
	if not compressed_text then compressed_text = util.TableToJSON(dupetable) end
	local len = string.len( compressed_text )
	local send_size = 60000
	local parts = math.ceil( len / send_size )
	local start = 0
	net.Start( "BeginContraptionSaveClient" )
		net.WriteString(name)
		net.WriteEntity(pl)
	net.Send(pl)
	for i = 1, parts do
		local endbyte = math.min( start + send_size, len )
		size = endbyte - start
		data = compressed_text:sub( start + 1, endbyte + 1 )
		net.Start( "ContraptionSaveClient" )
			net.WriteBool( i == parts )
			net.WriteUInt( size, 16 )
			net.WriteData( data, size )
		net.Send(pl)
		start = endbyte
	end

	MelonWars.messageReceivingEntity = nil
	MelonWars.messageReceivingState = "idle"
	MelonWars.networkBuffer = ""
end )

net.Receive( "RequestContraptionLoadToAssembler", function( _, pl )
	local ent = net.ReadEntity()
	local powerCost = net.ReadUInt(16)
	local _file = net.ReadString()
	local time = net.ReadFloat()
	ent.file = _file
	ent.player = pl
	ent.powerCost = powerCost
	ent:SetNWBool( "active", true )
	ent:SetNWFloat( "nextSlowThink", CurTime() + time )
	ent:SetNWFloat( "slowThinkTimer", time )
end )

local function MW_SpawnProp( model, pos, ang, _team, parent, health, cost, pl, spawntime, offset )
	local newMarine = ents.Create( "ent_melon_wall" )
	if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail
	--if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end

	newMarine:SetPos(pos)
	newMarine:SetAngles(ang)
	newMarine:SetModel(model)
	newMarine.maxHP = health

	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 )

	newMarine:SetNWInt("mw_melonTeam", _team)

	newMarine.mw_spawntime = spawntime
	newMarine:Spawn()
	newMarine:SetNWFloat("spawnTime", spawntime)

	if (parent ~= nil) then
		local weld = constraint.Weld( newMarine, parent, 0, 0, 0, true , false )
	else
		newMarine:SetMoveType(MOVETYPE_NONE)
		local weld = constraint.Weld( newMarine, game.GetWorld(), 0, 0, 0, true , false )
	end

	newMarine:SetVar("shotOffset", offset) 	-- NOT WORKING!!!!!

	if (IsValid(pl)) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
		pl.mw_melonTeam = _team
		newMarine:SetOwner(pl)
		undo.Create("Melon Marine")
		 undo.AddEntity( newMarine )
		 undo.SetPlayer( pl )
		undo.Finish()
	end

	newMarine.realvalue = cost
	if (cvars.Bool("mw_admin_credit_cost")) then
		newMarine.value = cost
	else
		newMarine.value = 0
	end

	local effectdata = EffectData()
	effectdata:SetEntity( newMarine )
	util.Effect( "propspawn", effectdata )

	return newMarine
end

net.Receive( "MW_SpawnProp", function( _, pl )
	local index = net.ReadInt(16)
	local trace = net.ReadTable()
	local cost = net.ReadInt(16)
	local _team = net.ReadInt(8)
	local spawntime = net.ReadInt(16)
	local propAngle = net.ReadAngle()

	local offset = Vector(0,0,MelonWars.baseProps[index].offset.z)
	if (cvars.Bool("mw_prop_offset") == true) then
		offset = MelonWars.baseProps[index].offset
	end
	local xoffset = Vector( offset.x * ( math.cos( propAngle.y / 180 * math.pi ) ), offset.x * ( math.sin( propAngle.y / 180 * math.pi ) ), 0 )
	local yoffset = Vector( offset.y * ( -math.sin( propAngle.y / 180 * math.pi ) ), offset.y * ( math.cos( propAngle.y / 180 * math.pi ) ), 0 )
	offset = xoffset + yoffset + Vector( 0, 0, offset.z )
	MW_SpawnProp(MelonWars.baseProps[index].model, trace.HitPos + trace.HitNormal + offset, propAngle + MelonWars.baseProps[index].angle, _team, trace.Entity, MelonWars.baseProps[index].hp, cost, pl, spawntime, offset)
end )

local function MW_SpawnBaseAtPos(_team, vector, pl, grandwar, unit)
	local offset = Vector(0,0,0)

	local class = "ent_melon_main_building"
	if (grandwar) then
		class = "ent_melon_main_building_grand_war"
	end
	if (unit) then
		class = "ent_melon_main_unit"
		offset = Vector(0,0,50)
	end
	local newMarine = ents.Create( class )
	if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail
	newMarine:SetPos( vector + offset )

	sound.Play( "garrysmod/content_downloaded.wav", vector, 60, 90, 1 )

	mw_melonTeam = _team

	newMarine.mw_spawntime = 0

	newMarine:Spawn()
	newMarine:SetNWInt("mw_melonTeam", _team)

	newMarine:Ini(_team)

	if not IsValid(pl) then return end
	sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
	undo.Create("Melon Marine")
	undo.AddEntity( newMarine )
	undo.SetPlayer( pl)
	undo.Finish()
end

net.Receive( "SpawnBase", function( _, pl )
	local trace = net.ReadTable()
	local _team = net.ReadInt(8)
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	MW_SpawnBaseAtPos(_team, trace.HitPos, pl, false, false)
end )

net.Receive( "SpawnBaseGrandWar", function( _, pl )
	local trace = net.ReadTable()
	local _team = net.ReadInt(8)
	if ( IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" ) then return end
	MW_SpawnBaseAtPos(_team, trace.HitPos, pl, true, false)
end )

net.Receive( "SpawnBaseUnit", function( _, pl )
	local trace = net.ReadTable()
	local _team = net.ReadInt(8)
	if IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" then return end
	MW_SpawnBaseAtPos(_team, trace.HitPos, pl, false, true)
end )

net.Receive( "SpawnCapturePoint", function()
	local trace = net.ReadTable()
	if IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" then return end
	local e = ents.Create("ent_melon_cap_point")
	e:SetPos(trace.HitPos)
	e:Spawn()
end )

net.Receive( "SpawnOutpost", function()
	local trace = net.ReadTable()
	if IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" then return end
	local e = ents.Create("ent_melon_outpost_point")
	e:SetPos(trace.HitPos)
	e:Spawn()
end )

net.Receive( "MW_SpawnWaterTank", function( _, pl )
	local trace = net.ReadTable()
	if IsValid( trace.Entity ) and trace.Entity.Base == "ent_melon_base" then return end
	local e = ents.Create( "ent_melon_water_tank" )
	e:SetPos( trace.HitPos )
	e:Spawn()
	e.waterVal = pl:GetInfoNum( "mw_water_tank_value", 1000 )
end )

net.Receive( "SellEntity", function( _, pl )
	local entity = net.ReadEntity()
	local playerTeam = net.ReadInt(8)
	if entity.Base == "ent_melon_base" then
		if entity.canMove ~= true then return end
		if entity.gotHit or CurTime() - entity:GetCreationTime() >= 30 or entity.fired ~= false then
			pl:PrintMessage( HUD_PRINTTALK, "== Can't sell mobile MelonWars.units after 30 seconds, after they got hit, or after they fired! ==" )
			sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
			entity = nil
		end
	end
	if IsValid(entity) then
		local isMainBuilding = entity:GetClass() == "ent_melon_main_building"
		local isNotMelonOrPhys = entity.Base ~= ( "ent_melon_base" or "ent_melon_prop_base" or "ent_melon_energy_base" ) and entity:GetClass() ~= "prop_physics"
		local isNotTeamProp = entity:GetClass() == "prop_physics" and entity:GetNWInt("mw_melonTeam", -1) ~= playerTeam
		if not ( isMainBuilding or isNotMelonOrPhys or isNotTeamProp ) then return end
		if IsValid( pl ) then
			pl:PrintMessage( HUD_PRINTTALK, "== That's not a sellable entity! ==" )
			sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
		end
		entity = nil
	end
	if entity == nil then return end
	if entity:GetClass() == "prop_physics" or entity.gotHit or CurTime() - entity:GetCreationTime() >= 30 or ( entity.Base == "ent_melon_base" and entity.fired ~= false ) then --pregunta si NO se va a recivir el dinero de refund NULL ENTITY
		MelonWars.teamCredits[playerTeam] = MelonWars.teamCredits[playerTeam] + entity.value * 0.25
		for _, v in ipairs( player.GetAll() ) do
			if v:GetInfo( "mw_team" ) == tostring( entity:GetNWInt( "mw_melonTeam", 0 ) ) then
				net.Start("MW_TeamCredits")
					net.WriteInt(MelonWars.teamCredits[entity:GetNWInt("mw_melonTeam", 0)] ,32)
				net.Send(v)
				v:PrintMessage( HUD_PRINTTALK, "== " .. tostring( entity.value * 0.25 ) .. " Water Recovered! ==" )
			end
		end
	end
	sound.Play( "garrysmod/balloon_pop_cute.wav", pl:GetPos(), 75, 100, 1 )
	-- local vPoint = Vector( 0, 0, 0 )
	local effectdata = EffectData()
	effectdata:SetOrigin( entity:GetPos() )
	for i = 0, 5 do
		util.Effect( "balloon_pop", effectdata )
	end
	entity:Remove()
end )

net.Receive( "LegalizeContraption", function( _, pl )
	local traceEntity = pl:GetEyeTrace().Entity
	local mw_melonTeam = net.ReadInt( 8 )

	local mass = 0 --precio por masa

	local entities = constraint.GetAllConstrainedEntities( traceEntity )
	if not IsValid( traceEntity ) then return end
	for _, ent in pairs( entities ) do
		local c = ent:GetClass()
		local phys = ent:GetPhysicsObject()
		if not freeze and c == "prop_physics" and ent:GetNWInt("mw_melonTeam", -1) == -1 and IsValid( phys ) then
			mass = mass + math.min( 1000, phys:GetMass() ) --max 1000 de vida
		end
	end
	local massCostMultiplier = 10
	local massHealthMultiplier = 1
	if not ( MelonWars.teamCredits[mw_melonTeam] >= mass * massCostMultiplier or not cvars.Bool( "mw_admin_credit_cost" ) ) then return end
	for _, ent in pairs( entities ) do
		if string.StartWith( ent:GetClass(), "gmod_" ) or string.StartWith( ent:GetClass(), "prop_vehicle") then
			ent:Remove()
		else
			if string.StartWith( ent:GetClass(), "ent_melon") then return end
			ent:SetColor( MelonWars.teamColors[mw_melonTeam] )
			ent:SetNWInt( "mw_melonTeam", mw_melonTeam )
			ent:SetNWInt( "propHP", math.min( 1000, ent:GetPhysicsObject():GetMass() * massHealthMultiplier ) ) --max 1000 de vida
			ent.realvalue = ent:GetPhysicsObject():GetMass() * massCostMultiplier
		end
	end
	if not cvars.Bool( "mw_admin_credit_cost" ) then return end
	MelonWars.teamCredits[mw_melonTeam] = MelonWars.teamCredits[mw_melonTeam] - mass * massCostMultiplier
	net.Start( "MW_TeamCredits" )
		net.WriteInt( MelonWars.teamCredits[mw_melonTeam], 32 )
	net.Send( pl )
end )

concommand.Add( "mw_reset_credits", function()
	local c = cvars.Number( "mw_admin_starting_credits" )
	MelonWars.teamCredits = { c, c, c, c, c, c, c, c }
	for _, v in ipairs( player.GetAll() ) do
		net.Start( "MW_TeamCredits" )
			net.WriteInt( c, 32 )
		net.Send( v )
	end
end )

concommand.Add( "mw_reset_power", function()
	MelonWars.teamUnits = {0,0,0,0,0,0,0,0}

	for _, v in ipairs( player.GetAll() ) do
		local mw_melonTeam = v:GetInfoNum( "mw_team", 0 )
		net.Start( "MW_TeamUnits" )
			net.WriteInt( MelonWars.teamUnits[mw_melonTeam], 32 )
		net.Send( v )
	end
end )

net.Receive( "StartGame", function()
	for i = 0, 4 do
		timer.Simple(i, function()
			for _, v in ipairs( player.GetAll() ) do
				v:PrintMessage( HUD_PRINTCENTER, "Match starts in " .. ( 5 - i ) )
			end
		end)
	end
	timer.Simple(5, function ()
		for _, v in ipairs( player.GetAll() ) do
			RunConsoleCommand("mw_admin_playing", 1)
			RunConsoleCommand("mw_admin_move_any_team", 0)
			RunConsoleCommand("mw_admin_credit_cost", 1)
			RunConsoleCommand("mw_admin_allow_free_placing", 0)
			RunConsoleCommand("mw_admin_spawn_time", 1)
			RunConsoleCommand("mw_admin_immortality", 0)
			RunConsoleCommand("mw_reset_credits")
			net.Start("RestartQueue")
			net.Send(v)
			sound.Play( "garrysmod/content_downloaded.wav", v:GetPos() + Vector( 0, 0, 45 ), 100, 40, 1 )
			v:PrintMessage( HUD_PRINTCENTER, "The MelonWars match has begun!" )
			v:PrintMessage( HUD_PRINTTALK, "== The MelonWars match has begun! ==" )
		end
	end)
end)

net.Receive( "SandboxMode", function()
	for _, v in ipairs( player.GetAll() ) do
		sound.Play( "garrysmod/save_load1.wav", v:GetPos() + Vector( 0, 0, 45 ), 100, 150, 1 )
		v:PrintMessage( HUD_PRINTTALK, "== MelonWars options set to Sandbox ==" )
	end
end )

net.Receive("MW_Stop", function( _, ply ) -- Previously concommand.Add( "mw_stop", function( ply )
	local stopedMelons = false

	local foundMelons = {}
	local entity = net.ReadEntity();
	while (not entity:IsWorld() and entity:IsValid() and entity ~= nil) do
		if (string.StartWith(entity:GetClass(), "ent_melon_")) then
			table.insert(foundMelons, entity)
		end
		entity = net.ReadEntity();
	end

	-- local foundMelons = ply.foundMelons
	if foundMelons == nil then return end
	for _, v in ipairs( foundMelons ) do
		if not IsValid(v) then
			--Si murió, lo saco de la tabla
			table.remove(foundMelons, k)
		else
			if v.Base == "ent_melon_base" then
				--si sigue vivo, le doy la order
				--si no, mueve
				v:SetVar("targetPos", v:GetPos())
				v:SetNWVector("targetPos", v:GetPos())
				v:SetVar("moving", false)
				v:SetNWBool("moving", false)
				v:SetVar("chasing", false)
				v:SetVar("followEntity", v)
				v:SetNWEntity("followEntity", v)
				for i = 1, 30 do
					v.rallyPoints[i] = Vector(0,0,0)
				end
				stopedMelons = true
			end
		end
	end

	if stopedMelons then
		sound.Play( "buttons/button16.wav", ply:GetPos(), 75, 100, 1 )
	end
end)

net.Receive( "MW_Order", function( _, ply ) -- Previously concommand.Add( "mw_order", function( ply )
	local trace = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = function( ent ) if ent:GetClass() ~= "player" then return true end end,
		mask = MASK_WATER + MASK_SOLID
	} )

	local foundMelons = {}
	local rally = net.ReadBool()
	local alt = net.ReadBool()
	local entity = net.ReadEntity()
	while not entity:IsWorld() and entity:IsValid() and entity ~= nil do
		if string.StartWith( entity:GetClass(), "ent_melon_" ) then
			table.insert( foundMelons, entity )
		end
		entity = net.ReadEntity()
	end

	if foundMelons == nil then return end
	for _, v in ipairs( foundMelons ) do
		if not IsValid( v ) or not string.StartWith( v:GetClass(), "ent_melon_" ) then
			--Si murió, lo saco de la tabla
			table.remove(foundMelons, k)
		end
	end

	local movedMelons

	if rally then
		for _, v in ipairs( foundMelons ) do
			local i = 30
			while i >= 0 do
				if v.rallyPoints ~= nil then
					if i == 0 then
						v.rallyPoints[1] = trace.HitPos
						v.moving = true
						movedMelons = true
						i = -1
					elseif v.rallyPoints[i] ~= Vector( 0, 0, 0 ) then
						if i < 30 and v.rallyPoints[i + 1] == Vector( 0, 0, 0 ) then
							v.rallyPoints[i + 1] = trace.HitPos
							movedMelons = true
							i = -1
						end
					end
				end
				i = i - 1
			end
		end
	elseif alt then
		for _, v in ipairs( foundMelons ) do
			if (IsValid(v) and string.StartWith(v:GetClass(), "ent_melon_")) then
				--si tenia apretado alt, dispara
				if (tostring(trace.Entity) == "Entity [0][worldspawn]") then
					--si se le apuntó al mundo, sacar objetivo
					v:SetVar("forcedTargetEntity", v)
					v:SetVar("targetEntity", v)
					v:SetVar("followEntity", v)
					v:SetNWEntity("followEntity", v)
					v:SetNWEntity("targetEntity", v)
					v:SetVar("chasing", false)
				else
					if (v:GetNWInt("mw_melonTeam", 0) == trace.Entity:GetNWInt("mw_melonTeam", 0)) then
						--si se le apuntó a algo, darle eso como objetivo
						v:SetVar("followEntity", trace.Entity)
						v:SetNWEntity("followEntity", trace.Entity)
						v:SetVar("forcedTargetEntity", v)
						v:SetVar("targetEntity", v)
						v:SetNWEntity("targetEntity", v)
						v:SetVar("chasing", false)
					else
						v:SetVar("followEntity", v)
						v:SetNWEntity("followEntity", v)
						v:SetVar("forcedTargetEntity", trace.Entity)
						v:SetVar("targetEntity", trace.Entity)
						v:SetNWEntity("targetEntity", trace.Entity)
						v:SetVar("chasing", true)
					end
				end
				movedMelons = true
			end
		end
	else
		for _, v in ipairs( foundMelons ) do
			--si no, mueve
			if (IsValid(v) and string.StartWith(v:GetClass(), "ent_melon_")) then
				if (v.RemoveRallyPoints ~= nil) then
					v:RemoveRallyPoints()
				end
				v:SetVar("targetPos", trace.HitPos)
				v:SetNWVector("targetPos", trace.HitPos)
				v:SetVar("moving", true)
				v:SetNWBool("moving", true)
				v:SetVar("chasing", false)
				v:SetVar("followEntity", v)
				v:SetNWEntity("followEntity", v)
				movedMelons = true
			end
		end
	end

	if movedMelons then
		sound.Play( "garrysmod/ui_click.wav", ply:GetPos(), 75, 100, 1 )
	else
		sound.Play( "common/wpn_denyselect.wav", ply:GetPos(), 75, 100, 1 )
	end
end )

concommand.Add( "mw_admin_reset_teams", function()
	for i = 1, 8 do
		MelonWars.teamGrid[i] = {}     -- create a new row
		for j = 1, 8 do
			MelonWars.teamGrid[i][j] = false
		end
	end
end )

net.Receive( "UpdateServerTeams", function()
	MelonWars.teamGrid = net.ReadTable()
	for _, v in ipairs( player.GetAll() ) do
		net.Start( "UpdateClientTeams" )
			net.WriteTable( MelonWars.teamGrid )
		net.Send( v )
	end
end )

net.Receive( "MW_ServerControlUnit", function( _, pl )
	local u = net.ReadEntity()
	pl.controllingUnit = u
	u.ai = false
	net.Start( "MW_ClientControlUnit" )
		net.WriteEntity( u )
	net.Send( pl )
end )

net.Receive( "MWControlShoot", function()
	local u = net.ReadEntity()
	local pos = net.ReadVector()
	u:Shoot( u, pos )
end )

net.Receive( "MWBrute", function( _, pl )
	pl:Kill()
end )