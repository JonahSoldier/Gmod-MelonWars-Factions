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
util.AddNetworkString( "MW_SpawnProp" )
util.AddNetworkString( "StartGame" )
util.AddNetworkString( "SandboxMode" )

util.AddNetworkString( "MW_Activate" )
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
util.AddNetworkString( "ContraptionSpawn" )
util.AddNetworkString( "ContraptionLoadToAssembler" )

--Super Secret first person mode of secretness
util.AddNetworkString( "MW_ServerControlUnit" )
util.AddNetworkString( "MW_ClientControlUnit" )
util.AddNetworkString( "MWControlShoot" )

-- Misc Stuff added by faction mod
util.AddNetworkString( "MWColourMod" )
util.AddNetworkString( "SetMWConvar" )
util.AddNetworkString( "MWReadyUp" )
util.AddNetworkString( "MW_ClientModifySpawnTime" ) --TODO: This needs to be handled on both client and server

-- Energy Networks
util.AddNetworkString( "MW_UpdateNetwork" )


MelonWars = MelonWars or {}

include("melonwars/sh_unitlist.lua")
include("melonwars/sh_functions.lua")

AddCSLuaFile("melonwars/cl_worldrings.lua")

--Work-around to make playing on dedicated servers possible.
--MW was originally developed solely on peer-to-peer, so a lot of 
--admin settings rely on the player using them also being the server host.
local mw_validConvars = {
	mw_admin_playing = true,
	mw_admin_locked_teams = true,
	mw_admin_bonusunits = true,
	mw_admin_allow_manual_placing = true,
	mw_admin_ban_contraptions = true,
	mw_admin_spawn_time = true,
	mw_admin_credit_cost = true,
	mw_admin_allow_free_placing = true,
	mw_admin_move_any_team = true,
	mw_admin_immortality = true
}
net.Receive( "SetMWConvar", function( _, pl )
	local openPerms = GetConVar( "mw_admin_open_permits" ):GetBool()

	if not pl:IsAdmin() or openPerms then return end

	local convar = net.ReadString()
	local newValue = net.ReadBool()

	if not mw_validConvars[convar] then return end --Security. We *really* don't want to trust what the client gives us here.

	GetConVar( convar ):SetBool( newValue )
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

--TODO: Finish what Marum started and give Doorsday his damned door props.
--Drago earned one but never actually said what he wanted, so I don't know what to do about that.

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
	local selectionID = net.ReadUInt(8)
	local center = net.ReadVector()
	local radius = net.ReadFloat()
	local hitEnt = net.ReadEntity()
	local isTypeSelect = net.ReadBool()

	local pTeam = pl:GetInfoNum( "mw_team", -2 )
	local foundEntities = MelonWars.selectionCylinder(center, radius, pTeam, hitEnt, isTypeSelect)

	local foundCount = #foundEntities
	net.Start("MW_ReturnSelection")
		net.WriteUInt(selectionID, 8)
		net.WriteUInt(foundCount, 10)
		for _, v in ipairs(foundEntities) do
			net.WriteEntity(v)
		end
	net.Send(pl)
end )

net.Receive( "MW_Activate", function(_, pl)
	local ent = net.ReadEntity()
	local plTeam = pl:GetInfoNum("mw_team", -1)
	if not plTeam == ent:GetNWInt( "mw_melonTeam", 0 ) then return end
	if ent.Actuate then
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

net.Receive( "MW_UpdateServerInfo", function() --TODO: This is bad. It shouldn't exist.
	local a = net.ReadInt(8)
	MelonWars.teamCredits[a] = net.ReadInt(32)
end )

net.Receive( "MW_UseWaterTank", function( _, pl )
	local ent = net.ReadEntity()
	local _team = ent.capTeam
	if _team ~= pl:GetInfoNum( "mw_team", -1 ) then return end

	local waterVal = ent:GetWaterValue()
	MelonWars.teamCredits[_team] = MelonWars.teamCredits[_team] + waterVal
	for _, v in ipairs( player.GetAll() ) do
		if v:GetInfoNum( "mw_team", -1) == _team then
			net.Start( "MW_TeamCredits" )
				net.WriteInt( MelonWars.teamCredits[_team], 32 )
			net.Send( v )
			v:PrintMessage( HUD_PRINTTALK, "== Received " .. waterVal .. " water! ==" )
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

net.Receive( "MW_SpawnUnit", function( _, pl )
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
	if cvars.Number("mw_admin_spawn_time") == 1 then
		if (cvars.Bool("mw_admin_allow_free_placing") or MelonWars.units[unit_index].buildAnywere or MelonWars.isInRange(trace.HitPos, mw_melonTeam) or mw_melonTeam == 0) then
			if (pl.mw_spawntime < CurTime()) then
				pl.mw_spawntime = CurTime() + MelonWars.units[unit_index].spawn_time * (pl.spawnTimeMult or 1) -- spawntimemult has been added here so I can compensate for matches with uneven numbers of commanders
			else
				pl.mw_spawntime = pl.mw_spawntime + MelonWars.units[unit_index].spawn_time * (pl.spawnTimeMult or 1)
			end
		end
	end
	local spawntime = pl.mw_spawntime

	local newMarine = MelonWars.spawnUnitAtPos(class, unit_index, position, angle, cost, spawntime, _team, attach, trace.Entity, pl, spawndelay)

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
	if not IsValid( newMarine ) then return end

	newMarine:SetPos( pos )
	newMarine:SetAngles( ang )

	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 ) --TODO: Move sounds elsewhere

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
		newMarine:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		if IsValid(parent) then
			newMarine:Welded(newMarine, parent)
		else
			newMarine:SetMoveType(MOVETYPE_NONE)
			newMarine:Welded(newMarine, game.GetWorld())
		end
	end

	newMarine:Ini(_team)

	if IsValid(pl) then
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

function MelonWars.sanitizeContraptionEntities( dupeEntities )
	--Nuke absolutely everything except for the basic values required to make the entity.
	local legalDataValues = {
		Model = true,
		Angle = true,
		Pos = true,
		Name = true,
		PhysicsObjects = true,
		Class = true
	}

	for _, entity in pairs(dupeEntities) do
		for k, v in pairs(entity) do
			if not legalDataValues[k] then
				entity[k] = nil
			end
		end
	end
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
	duplicator.SetLocalPos( vector_origin )

	--This'll cut down on file sizes so why not
	MelonWars.sanitizeContraptionEntities( dupetable.Entities )

	local dubJSON = util.TableToJSON(dupetable)

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

MelonWars.messageReceivingState = "idle"
MelonWars.networkBuffer = ""

net.Receive( "BeginContraptionLoad", function(_, pl)
	if MelonWars.messageReceivingState ~= "idle" then return end
	MelonWars.messageReceivingState = tostring( pl )
	MelonWars.networkBuffer = ""
end )

net.Receive( "ContraptionLoad", function( _, pl)
	local last = net.ReadBool()
	local size = net.ReadUInt(16)
	local data = net.ReadData(size)

	MelonWars.networkBuffer = MelonWars.networkBuffer .. data
	if not last then return end
	local text = util.Decompress(MelonWars.networkBuffer)
	local dupeTable = util.JSONToTable( text )
	pl.loadedContraption = dupeTable

	MelonWars.messageReceivingState = "idle"
	MelonWars.networkBuffer = ""
end)

function MelonWars.contraptionSpawn( spawnerEnt )
	undo.Create("Melon Contraption")
	local dupeTable = spawnerEnt.loadedContraption
	local spawnerIsPlayer = spawnerEnt:IsPlayer()

	local pos, entTeam, owner
	if spawnerIsPlayer then
		pos = spawnerEnt:GetEyeTrace().HitPos
		entTeam = spawnerEnt:GetInfoNum("mw_team", 0)
		owner = spawnerEnt
	else
		pos = spawnerEnt:GetPos()
		entTeam = spawnerEnt:GetNWInt("mw_melonTeam")
		owner = spawnerEnt.player
	end

	MelonWars.sanitizeContraptionEntities( dupeTable.Entities )

	local localpos = pos - Vector( ( dupeTable.Maxs.x + dupeTable.Mins.x ) / 2, ( dupeTable.Maxs.y + dupeTable.Mins.y ) / 2, dupeTable.Mins.z - 10 )

	duplicator.SetLocalPos( localpos )
	local paste = duplicator.Paste( player.GetByID( 0 ), dupeTable.Entities, dupeTable.Constraints )
	duplicator.SetLocalPos( vector_origin )

	local enableSkin = tobool(owner:GetInfo( "mw_enable_skin" ))
	for _, v in pairs(paste) do
		local vTbl = v:GetTable()
		if vTbl.Base == "ent_melon_base" then
			vTbl.population = math.ceil(vTbl.population / 2)
			v:Ini(entTeam)
			if not vTbl.isContraptionPart then
				vTbl.canMove = false
			end

			v:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER ) --Don't collide with other turrets, or contraption props
			vTbl.phys:SetDamping(0,0)

			if enableSkin then
				local _skin = MelonWars.specialSteamSkins[owner:SteamID()]
				if _skin and _skin.material then
					v:SkinMaterial( _skin.material )
				end
			end
			if not(v:GetNWBool("done", nil) == nil) then --If done nwVar exists, set it to true. Used for propeller/hover
				v:SetNWBool("done",true)
			end
		else
			v:SetCollisionGroup(COLLISION_GROUP_PLAYER) --Collide with other contraption props, but not turrets.

			v:SetColor(MelonWars.teamColors[entTeam])
			v:SetMaterial("")
			v:SetRenderFX(kRenderFxNone)
			v:SetNWInt("mw_melonTeam", entTeam)
			v:SetNWInt("propHP", math.min(1000,v:GetPhysicsObject():GetMass()))
			vTbl.realvalue = v:GetPhysicsObject():GetMass()
		end
		if spawnerIsPlayer then
			vTbl.targetPos = pos
			v:SetNWVector("targetPos", pos)
		else
			vTbl.targetPos = spawnerEnt.targetPos + vector_up
			v:SetNWVector( "targetPos", spawnerEnt.targetPos + vector_up )
			vTbl.moving = true
		end

		undo.AddEntity( v )
	end

	undo.SetPlayer( owner )
	undo.Finish()

	for _, v in pairs(paste) do
		v:GetPhysicsObject():EnableMotion(true)
	end
end

net.Receive( "ContraptionSpawn", function( _, pl )
	if not pl.loadedContraption then return end
	--TODO: Make sure this is allowed!
	MelonWars.contraptionSpawn( pl )
	pl.loadedContraption = nil
end)

net.Receive( "ContraptionLoadToAssembler", function( _, pl )
	local ent = net.ReadEntity()
	if not( ent:GetNWInt("mw_melonTeam") == pl:GetInfoNum("mw_team", 0) ) then return end

	ent.loadedContraption = pl.loadedContraption
	pl.loadedContraption = nil

	ent.player = pl

	local cost, spawntime, power = MelonWars.calculateContraptionValues( ent.loadedContraption.Entities )

	--TODO: Check that this player has the resources to do this.

	ent.powerCost = power

	ent:SetNWBool( "active", true )
	ent:SetNWFloat( "nextSlowThink", CurTime() + spawntime )
	ent:SetNWFloat( "slowThinkTimer", time )

	local plTeam = pl:GetInfoNum("mw_team", 0)
	if cvars.Bool("mw_admin_credit_cost") then
		MW_Server_UpdateWater(plTeam, MelonWars.teamCredits[plTeam]-cost)
	end
end )

local function MW_SpawnProp( model, pos, ang, _team, parent, health, cost, pl, spawntime, offset )
	local newMarine = ents.Create( "ent_melon_wall" )
	if not IsValid( newMarine ) then return end

	newMarine:SetPos(pos)
	newMarine:SetAngles(ang)
	newMarine:SetModel(model)
	newMarine.maxHP = health

	sound.Play( "garrysmod/content_downloaded.wav", pos, 60, 90, 1 )

	newMarine:SetNWInt("mw_melonTeam", _team)

	newMarine.mw_spawntime = spawntime
	newMarine:Spawn()
	newMarine:SetNWFloat("spawnTime", spawntime)

	if parent then
		constraint.Weld( newMarine, parent, 0, 0, 0, true , false )
	else
		newMarine:SetMoveType(MOVETYPE_NONE)
		constraint.Weld( newMarine, game.GetWorld(), 0, 0, 0, true , false )
	end

	newMarine:SetVar("shotOffset", offset) 	-- NOT WORKING!!!!!
	--TODO: Check what Marum meant by that comment.

	if IsValid(pl) then
		sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
		pl.mw_melonTeam = _team
		newMarine:SetOwner(pl)
		undo.Create("Melon Base Prop")
		 undo.AddEntity( newMarine )
		 undo.SetPlayer( pl )
		undo.Finish()
	end

	newMarine.realvalue = cost
	if cvars.Bool("mw_admin_credit_cost") then
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
	local index = net.ReadUInt(8)
	local trace = net.ReadTable() --TODO: just send the entity and pos over the network, not the entire traceResult table.
	local _team = net.ReadInt(8)
	local propAngle = net.ReadAngle()

	local baseProp = MelonWars.baseProps[index]

	local cost = baseProp.cost
	local spawntime = baseProp.spawn_time * cvars.Number("mw_admin_spawn_time")
	local offset
	if cvars.Bool("mw_prop_offset") then
		offset = baseProp.offset
	else
		offset = Vector(0,0,baseProp.offset.z)
	end

	local xoffset = Vector( offset.x * ( math.cos( propAngle.y / 180 * math.pi ) ), offset.x * ( math.sin( propAngle.y / 180 * math.pi ) ), 0 )
	local yoffset = Vector( offset.y * ( -math.sin( propAngle.y / 180 * math.pi ) ), offset.y * ( math.cos( propAngle.y / 180 * math.pi ) ), 0 )
	offset = xoffset + yoffset + Vector( 0, 0, offset.z )

	MW_SpawnProp(baseProp.model, trace.HitPos + trace.HitNormal + offset, propAngle + baseProp.angle, _team, trace.Entity, baseProp.hp, cost, pl, spawntime, offset)
end )

local function MW_SpawnBaseAtPos(_team, vector, pl, grandwar, unit)
	local offset = vector_origin

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

net.Receive( "SellEntity", function( _, pl )
	local entity = net.ReadEntity()
	local playerTeam = net.ReadInt(4)

	if not entity:IsValid() then
		entity = pl:GetEyeTrace().Entity
	end
	if not entity:IsValid() then
		return
	end

	if entity.Base == "ent_melon_base" then
		if entity.canMove and (entity.gotHit or CurTime() - entity:GetCreationTime() >= 30 or entity.fired ~= false) then
			pl:PrintMessage( HUD_PRINTTALK, "== Can't sell mobile units after 30 seconds, after they got hit, or after they fired! ==" )
			sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
			return
		end
	end

	local isMainBuilding = entity:GetClass() == "ent_melon_main_building"
	local isNotMelonOrPhys = not(entity.Base == "ent_melon_base" or entity.Base ==  "ent_melon_prop_base" or entity.Base == "ent_melon_energy_base") and entity:GetClass() ~= "prop_physics"
	local isNotTeamProp = entity:GetClass() == "prop_physics" and entity:GetNWInt("mw_melonTeam", -1) ~= playerTeam

	if isMainBuilding or isNotMelonOrPhys or isNotTeamProp then
		if IsValid( pl ) then
			pl:PrintMessage( HUD_PRINTTALK, "== That's not a sellable entity! ==" )
			sound.Play( "buttons/button2.wav", pl:GetPos(), 75, 100, 1 )
		end
		return
	end

	if entity:GetClass() == "prop_physics" or entity.gotHit or CurTime() - entity:GetCreationTime() >= 30 or ( entity.Base == "ent_melon_base" and entity.fired ~= false ) then --pregunta si NO se va a recivir el dinero de refund NULL ENTITY
		MelonWars.teamCredits[playerTeam] = MelonWars.teamCredits[playerTeam] + entity.value * 0.25
		for _, v in ipairs( player.GetAll() ) do
			if v:GetInfoNum( "mw_team", -1 ) == entity:GetNWInt( "mw_melonTeam", 0 ) then
				net.Start("MW_TeamCredits")
					net.WriteInt(MelonWars.teamCredits[entity:GetNWInt("mw_melonTeam", 0)] ,32)
				net.Send(v)
				v:PrintMessage( HUD_PRINTTALK, "== " .. tostring( entity.value * 0.25 ) .. " Water Recovered! ==" )
			end
		end
	end
	sound.Play( "garrysmod/balloon_pop_cute.wav", pl:GetPos(), 75, 100, 1 )
	local effectdata = EffectData()
	effectdata:SetOrigin( entity:GetPos() )
	for i = 0, 5 do
		util.Effect( "balloon_pop", effectdata )
	end
	entity:Remove()
end )

concommand.Add( "mw_reset_credits", function(ply)
	if ply:IsValid() and not ply:IsAdmin() then return end

	local c = cvars.Number( "mw_admin_starting_credits" )
	MelonWars.teamCredits = { c, c, c, c, c, c, c, c }
	for _, v in ipairs( player.GetAll() ) do
		net.Start( "MW_TeamCredits" )
			net.WriteInt( c, 32 )
		net.Send( v )
	end
end )

concommand.Add( "mw_reset_power", function(ply)
	if ply:IsValid() and not ply:IsAdmin() then return end

	MelonWars.teamUnits = {0,0,0,0,0,0,0,0}

	for _, v in ipairs( player.GetAll() ) do
		local mw_melonTeam = v:GetInfoNum( "mw_team", 0 )
		net.Start( "MW_TeamUnits" )
			net.WriteInt( MelonWars.teamUnits[mw_melonTeam], 32 )
		net.Send( v )
	end
end )

local function startMatch()
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
end

net.Receive( "StartGame", function()
	startMatch()
end)

net.Receive( "MWReadyUp", function()
	timer.Simple(1, function()
		local ReadyCount = 0
		for _, v in ipairs( player.GetAll() ) do
			ReadyCount = ReadyCount + ((tobool(v:GetInfo( "mw_player_ready")) and 1) or 0)
		end

		if ReadyCount / player.GetCount() <= GetConVar( "mw_admin_readyup_percentage" ):GetFloat() then return end

		startMatch()
	end)
end )

net.Receive( "SandboxMode", function()
	for _, v in ipairs( player.GetAll() ) do
		sound.Play( "garrysmod/save_load1.wav", v:GetPos() + Vector( 0, 0, 45 ), 100, 150, 1 )
		v:PrintMessage( HUD_PRINTTALK, "== MelonWars options set to Sandbox ==" )
	end
end )

net.Receive("MW_Stop", function( _, ply )
	local foundMelons = {}
	local entity = net.ReadEntity()
	while IsValid(entity) do
		if entity.Base == "ent_melon_base" or entity.Base == "ent_melon_energy_base" then
			table.insert(foundMelons, entity)
		end
		entity = net.ReadEntity()
	end

	if #foundMelons > 0 then
		for _, v in ipairs( foundMelons ) do
			v:ClearOrders()
		end
		sound.Play( "buttons/button16.wav", ply:GetPos(), 75, 100, 1 )
	end
end)

net.Receive( "MW_Order", function( _, ply )
	local hitPos = net.ReadVector()
	local hitEnt = net.ReadEntity()

	if hitEnt:IsPlayer() then
		hitEnt = game.GetWorld()
	end

	local rally = net.ReadBool()
	local alt = net.ReadBool()

	local foundMelons = {}
	local entity = net.ReadEntity()
	while IsValid(entity) do
		if entity.Base == "ent_melon_base" or entity.Base == "ent_melon_energy_base" then
			table.insert( foundMelons, entity )
		end
		entity = net.ReadEntity()
	end

	local movedMelons
	if rally then
		for _, v in ipairs( foundMelons ) do
			local vTbl = v:GetTable()
			local rallyPoints = vTbl.rallyPoints
			if rallyPoints then
				for i = 29, 0, -1 do
					if not(rallyPoints[i] == vector_origin) then
						rallyPoints[i + 1] = hitPos
						movedMelons = true
						break
					end
				end
			end
			vTbl.moving = true
		end
	elseif alt then
		local hitValid = hitEnt:IsValid() --Not the world or an inValid entity
		movedMelons = hitValid and #foundMelons > 0
		for _, v in ipairs( foundMelons ) do
			local vTbl = v:GetTable()

			local sameTeam = v:SameTeam(hitEnt)
			local forceTargetEnt = ( (not sameTeam and hitValid ) and hitEnt) or v
			local followEnt = ( sameTeam and hitEnt ) or v

			vTbl.forcedTargetEntity = forceTargetEnt
			vTbl.targetEntity = forceTargetEnt
			v:SetNWEntity("targetEntity", forceTargetEnt)

			vTbl.followEntity = followEnt
			v:SetNWEntity("followEntity", followEnt)

			vTbl.chasing = not sameTeam and hitValid
		end
	else
		movedMelons = #foundMelons > 0
		for _, v in ipairs( foundMelons ) do
			local vTbl = v:GetTable()
			if isfunction(vTbl.RemoveRallyPoints) then
				v:RemoveRallyPoints()
			end
			vTbl.targetPos = hitPos
			v:SetNWVector("targetPos", hitPos)

			vTbl.moving = true
			v:SetNWBool("moving", true)

			vTbl.chasing = false
			vTbl.followEntity = v
			v:SetNWEntity("followEntity", v)
		end
	end

	if movedMelons then
		sound.Play( "garrysmod/ui_click.wav", ply:GetPos(), 75, 100, 1 )
	else
		sound.Play( "common/wpn_denyselect.wav", ply:GetPos(), 75, 100, 1 )
	end
end )

concommand.Add( "mw_admin_reset_teams", function(ply)
	if ply:IsValid() and not ply:IsAdmin() then return end

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

function MelonWars.broadcastTeamMessage(_team, message, mode)
	mode = mode or HUD_PRINTTALK
	for i, v in ipairs(player.GetAll()) do
		if v:GetInfoNum("mw_team", -1) == _team then
			v:PrintMessage( mode, message )
		end
	end
end