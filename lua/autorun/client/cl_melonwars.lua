if engine.ActiveGamemode() ~= "sandbox" then return end

MelonWars = MelonWars or {}

--TODO: Move these to tool
CreateClientConVar( "mw_player_ready", "0", false, true, "Is the player ready or not", 0, 1 )
CreateClientConVar( "mw_buildalpha_multiplier", "1", true, false, "Makes the sphere around outposts more/less transparent", 0, 10 )
CreateClientConVar( "mw_oldbuildzones", "0", true, false, "Draw full spheres instead of just lines on the ground.", 0, 1 )

include("melonwars/sh_unitlist.lua")
include("melonwars/sh_functions.lua")

include("melonwars/cl_worldrings.lua")

MelonWars.teamColors = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
MelonWars.teamColors[0] = Color(100,100,100,255)

MelonWars.messageReceivingEntity = nil
MelonWars.messageReceivingState = "idle"
MelonWars.networkBuffer = ""

cvars.AddChangeCallback("mw_player_ready", function()
	net.Start("MWReadyUp")
	net.SendToServer()
end)

function MelonWars.sendContraptionToServer(_file)
	local text = file.Read(_file)
	local compressed_text = util.Compress( text )
	if not compressed_text then compressed_text = text end
	local len = string.len( compressed_text )
	local send_size = 60000
	local parts = math.ceil( len / send_size )
	local start = 0

	net.Start( "BeginContraptionLoad" )
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
end

net.Receive( "MW_ReturnSelection", function()
	local returnedSelectionID = net.ReadUInt(8)

	if returnedSelectionID ~= LocalPlayer().mw_selectionID then return end
	local count = net.ReadUInt(10)

	for i = 1, count do
		local foundEntity = net.ReadEntity()
		if not foundEntity:IsValid() then
			print("== Melon Wars: Received a null entity from the server. If you see this in console please tell a dev, it means something's not working and you may fail to select units.")
		end
		if not table.HasValue(LocalPlayer().foundMelons, foundEntity) then
			table.insert(LocalPlayer().foundMelons, foundEntity)
		end
	end
end )

net.Receive( "MW_SelectContraption", function()
	local count = net.ReadUInt( 16 )
	local ply = LocalPlayer()
	-- print("Receiving extra selections from the server ("..count..")")
	local v, hasMelonBase, canMove, isFound
	for i = 0, count do
		v = net.ReadEntity()
		hasMelonBase = v.Base == "ent_melon_base"
		canMove = cvars.Bool( "mw_admin_move_any_team", false ) or ( ply == nil or v:GetNWInt( "mw_melonTeam", -1 ) == ply:GetInfoNum( "mw_team", -1 ) )
		isFound = ply.foundMelons[v]
		if hasMelonBase and canMove and not isFound then
			table.insert( ply.foundMelons, v )
		end
	end
end )

net.Receive( "RestartQueue", function()
	LocalPlayer().mw_spawntime = CurTime()
end )

net.Receive( "BeginContraptionSaveClient", function()
	MelonWars.messageReceivingState = net.ReadString()
	MelonWars.messageReceivingEntity = net.ReadEntity()
	MelonWars.networkBuffer = ""
end )

net.Receive( "ContraptionSaveClient", function()
	local last = net.ReadBool()
	local size = net.ReadUInt( 16 )
	local data = net.ReadData( size )
	MelonWars.networkBuffer = MelonWars.networkBuffer .. data
	if not last then return end
	local text = util.Decompress( MelonWars.networkBuffer )
	file.CreateDir( "melonwars/contraptions" )
	file.Write( "melonwars/contraptions/" .. MelonWars.messageReceivingState .. ".txt", text )
	MelonWars.messageReceivingEntity = nil
	MelonWars.messageReceivingState = "idle"
	MelonWars.networkBuffer = ""
end )

local function ResourcesChanged( dif )
	local tool = LocalPlayer():GetTool()
	if tool == nil then return end
	if tool.Mode ~= "melon_universal_tool" then return end
	tool:IndicateIncome( dif )
end

net.Receive( "MW_TeamCredits", function()
	local previousCredits = LocalPlayer().mw_credits
	LocalPlayer().mw_credits = net.ReadInt( 32 )
	local newCredits = LocalPlayer().mw_credits
	if previousCredits == nil then return end
	local difference = newCredits - previousCredits
	if difference == 0 then return end
	ResourcesChanged( difference )
end )

net.Receive( "MW_TeamUnits", function()
	--LocalPlayer().MelonWars.units = net.ReadInt(16)
	LocalPlayer().mw_units = net.ReadInt(16)
end )

net.Receive( "MW_ClientControlUnit", function()
	local u = net.ReadEntity()
	LocalPlayer().controllingUnit = u
end)

net.Receive( "MW_UnitDecoration", function()
	local entity = net.ReadEntity()
	local tbl = net.ReadTable()

	local prop = ClientsideModel( tbl.prop )
	prop:SetPos( entity:GetPos() + VectorRand( -3, 3 ) )
	prop:SetAngles( AngleRand() )
	prop:SetModelScale( tbl.scale )
	prop:SetMoveParent( entity )
	local cdata = EffectData()
	cdata:SetEntity( prop )
	util.Effect( "propspawn", cdata )
end)

net.Receive( "MWColourMod", function()
	LocalPlayer().MWhasColourModifier = net.ReadBool()
	LocalPlayer().MWColourModifierTable = net.ReadTable()
	DrawColorModify( LocalPlayer().MWColourModifierTable )
end)

net.Receive( "MW_ClientModifySpawnTime", function()
	local spawnTimeChange = net.ReadFloat()
	LocalPlayer().spawnTimeMult = spawnTimeChange
end )