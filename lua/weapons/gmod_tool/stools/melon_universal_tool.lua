TOOL.Category = "MelonWars: RTS"
TOOL.Name = "Player Tool"
TOOL.Command = nil
TOOL.ConfigName = "" -- Setting this means that you do not have to create external configuration files to define the layout of the tool config-hud

-- Convars (Start)

CreateClientConVar( "mw_chosen_unit", "1", 0, false )
TOOL.ClientConVar[ "mw_chosen_unit" ] = 1
CreateClientConVar( "mw_unit_option_welded", "0", 0, true )
TOOL.ClientConVar[ "mw_unit_option_welded" ] = 0
local mw_team_cv = CreateClientConVar( "mw_team", "1", 1, true )
TOOL.ClientConVar[ "mw_team" ] = 1
CreateClientConVar( "mw_contraption_name", "default", 0, false )
TOOL.ClientConVar[ "mw_contraption_name" ] = "default"
CreateClientConVar( "mw_water_tank_value", "10000", false, true, "Sets the value of a water tank upon its creation.", 0, 50000 )
TOOL.ClientConVar[ "mw_water_tank_value" ] = 10000

CreateConVar( "mw_enable_skin", "1", FCVAR_ARCHIVE + FCVAR_USERINFO, "Enable or disable your custom skin." )
TOOL.ClientConVar[ "mw_enable_skin" ] = "1"

CreateConVar( "mw_admin_open_permits", "0", 8192 + 128, "Whether or not everyone is allowed to use the admin menu." )
TOOL.ClientConVar[ "mw_admin_spawn_time" ] = 0
CreateConVar( "mw_admin_spawn_time", "0", 8192, "Whether or not units take time before spawning." )
TOOL.ClientConVar[ "mw_admin_spawn_time" ] = 1 --TODO: This seems like it's duplicated / maybe shouldn't be here?
CreateConVar( "mw_admin_immortality", "0", 8192, "Whether or not units are immortal. Intended for use in photography." )
TOOL.ClientConVar[ "mw_admin_immortality" ] = 1
CreateConVar( "mw_admin_move_any_team", "1", 8192, "If true, everyone can move any melon." )
TOOL.ClientConVar[ "mw_admin_move_any_team" ] = 1
CreateConVar( "mw_admin_allow_free_placing", "1", 8192, "If true, melons can be spawned anywhere." )
TOOL.ClientConVar[ "mw_admin_allow_free_placing" ] = 1
local mw_admin_playing_cv = CreateConVar( "mw_admin_playing", "0", 8192, "If false, players can't play and income stops." )
TOOL.ClientConVar[ "mw_admin_playing" ] = 1
CreateConVar( "mw_admin_base_income", "25", 8192, "Amount of income from main buildings. (x2 for grand base)" )
TOOL.ClientConVar[ "mw_admin_base_income" ] = 25
CreateConVar( "mw_admin_credit_cost", "0", 8192, "If false, units are free." )
TOOL.ClientConVar[ "mw_admin_credit_cost" ] = 1
CreateConVar( "mw_admin_bonusunits", "0", 8192, "Whether or not you can use some more poorly balanced units." )
TOOL.ClientConVar[ "mw_admin_bonusunits" ] = 0
CreateConVar( "mw_admin_max_units", "100", 8192, "The max amount of melons per team." )
TOOL.ClientConVar[ "mw_admin_max_units" ] = 100
CreateConVar( "mw_admin_starting_credits", "2000", 8192, "The starting credits for a match." )
TOOL.ClientConVar[ "mw_admin_max_units" ] = 2000
CreateConVar( "mw_admin_allow_manual_placing", "1", 8192, "If false, you can place units directly with the toolgun." )
TOOL.ClientConVar[ "mw_admin_allow_manual_placing" ] = 1
CreateConVar( "mw_admin_ban_contraptions", "0", 8192, "If false, you can place Contraption Assemblers." )
TOOL.ClientConVar[ "mw_admin_ban_contraptions" ] = 1
CreateConVar( "mw_admin_locked_teams", "0", 8192, "If true, you can't change teams or factions." )
TOOL.ClientConVar[ "mw_admin_locked_teams" ] = 0

CreateConVar( "mw_admin_player_colors", "1", 8192, "If true, players will respawn with their team's color." )
TOOL.ClientConVar[ "mw_admin_player_colors" ] = 1

CreateConVar( "mw_admin_readyup_percentage", "0.75", 8192, "Percentage of players ready needed to trigger a match start." )
TOOL.ClientConVar[ "mw_admin_base_income" ] = 0.75

CreateClientConVar( "mw_chosen_prop", "1", 0, true )
TOOL.ClientConVar[ "mw_chosen_prop" ] = 1
CreateClientConVar( "mw_prop_offset", "1", 0, false )
TOOL.ClientConVar[ "mw_prop_offset" ] = 1
CreateClientConVar( "mw_prop_snap", "1", 0, false )
TOOL.ClientConVar[ "mw_prop_snap" ] = 1
CreateClientConVar( "mw_code", "0", 0, false )
TOOL.ClientConVar[ "mw_code" ] = 1
CreateClientConVar( "mw_income_indicator", "1", 1, false )
TOOL.ClientConVar[ "mw_income_indicator" ] = 1

local mw_action_cv = CreateClientConVar( "mw_action", "0", 0, true )
TOOL.ClientConVar[ "mw_action" ] = 0

-- Convars (End)

local orangeColor = Color( 255, 100, 0, 255 )
local color_white = color_white
local color_black = color_black

local IncomeIndicatorClass = {}
IncomeIndicatorClass.time = 0
IncomeIndicatorClass.value = 0

local function IncomeIndicator() -- Code is an optional argument.
	local newIncomeIndicator = table.Copy( IncomeIndicatorClass )
	return newIncomeIndicator
end

local incomeIndicators = {
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator()
}
local currentIncomeIndicator = 1

local unitCount = MelonWars.unitCount
local firstBuilding = MelonWars.unitlist_firstBuilding
local firstEnergy = MelonWars.unitlist_firstEnergy
local firstContraption = MelonWars.unitlist_firstContraption

MelonWars.teamGrid = {
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false}
}


local w = 700
local h = 500


-- CUSTOM UI ELEMENTS: ----------------------------------

local function _MakeCheckbox (x, y, parent, textstr, command, labelstr, inverted)
	local checkbox = vgui.Create( "DButton", parent ) --  Create the checkbox
	checkbox:SetPos( x, y ) --  Set the position
	checkbox:SetSize(60,30)
	checkbox:SetText("")
	local checked = GetConVar( command ):GetInt() == 1
	if (inverted) then checked = not checked end
	checkbox.Paint = function(s, w, h)
		draw.RoundedBox( 8, 0, 0, w, h, color_white )
		draw.RoundedBox( 6, 2, 2, w-4, h-4, color_black )
		if (checked) then
			draw.RoundedBox( 4, 4, 4, w-8, h-8, color_white )
		end
	end
	function checkbox:DoClick()
		local commandstring = command .. " " .. tostring( 1 - GetConVar( command ):GetInt() )

		LocalPlayer():ConCommand(commandstring)
		net.Start("SetMWConvar")
			net.WriteString(command)
			net.WriteBool( 1 - GetConVar( command ):GetInt() )
		net.SendToServer()

		checked = GetConVar( command ):GetInt() ~= 1
		if inverted then checked = not checked end
		checkbox.Paint = function(s, w, h)
			draw.RoundedBox( 8, 0, 0, w, h, color_white )
			draw.RoundedBox( 6, 2, 2, w-4, h-4, color_black )
			if (checked) then
				draw.RoundedBox( 4, 4, 4, w-8, h-8, color_white )
			end
		end
	end
	if (textstr ~= nil) then
		local label = vgui.Create("DLabel", parent)
		label:SetPos( x + 70, y)
		label:SetSize(370,30)
		label:SetFontInternal( "Trebuchet24" )
		label:SetText(textstr)
	end
	if (labelstr ~= nil) then
		local label = vgui.Create("DLabel", parent)
		label:SetPos( x + 250, y)
		label:SetSize(370,30)
		label:SetFontInternal( "Trebuchet18" )
		label:SetText(labelstr)
	end

	return checkbox
end

local function _MakeButton(number, posnumber, parent) -- Make Button
	if not CLIENT then return end
	local pl = LocalPlayer()

	local button = vgui.Create("DButton", parent) -- Unit button
	button:SetSize(120,40)
	button:SetPos( 10, 10 + ( posnumber - 1 ) * 45 )
	button:SetFont("CloseCaption_Normal")
	button:SetText(MelonWars.units[number].name)
	function button:DoClick()
		pl:ConCommand( "mw_chosen_unit " .. tostring( number ) )
		pl:ConCommand( "mw_action 1" )
		pl.mw_frame:Remove()
		pl.mw_frame = nil
	end
	local color = MelonWars.units[number].button_color
	button.Paint = function(s, w, h)
		local darken = (button:IsHovered() and 25) or 0
		draw.RoundedBox( 6, 0, 0, w, h, Color(color.r-40-darken,color.g-40-darken,color.b-40-darken) )
		draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(color.r-darken, color.g-darken, color.b-darken) )
	end
	function button:OnCursorEntered()
		pl.info:SetText(MelonWars.units[number].description)
		if (cvars.Number("mw_admin_credit_cost") == 1) then
			pl.info_cost:SetText( "Cost: " .. MelonWars.units[number].cost )
			if (MelonWars.units[number].welded_cost == -1) then
				pl.info_turret_cost:SetText("")
			else
				pl.info_turret_cost:SetText( "Turret cost: " .. MelonWars.units[number].welded_cost )
			end
		else
			pl.info_cost:SetText("")
			pl.info_turret_cost:SetText("")
		end
		pl.info_power:SetText( "Power: " .. MelonWars.units[number].population )
		if (cvars.Number("mw_admin_spawn_time") == 1) then
			pl.info_time:SetText( "Spawn time: " .. MelonWars.units[number].spawn_time .. "s" )
		else
			pl.info_time:SetText("")
		end
		pl.info_name:SetText(MelonWars.units[number].name)
	end
end

local function _MakeHelpButton(name, number, info, text1, text2, text3, text4, text5) -- Make HELP Button
	local locPly = LocalPlayer()
	local button = vgui.Create("DButton", locPly.panel)
	button:SetSize(100,40)
	button:SetPos( 10, 10 + number * 45 )
	button:SetText(name)
	button:SetFontInternal("CloseCaption_Normal")
	function button:DoClick()
		info:SetFontInternal("Trebuchet24")
		info:SetText(text1)
		if text2 then info:AppendText(text2) end
		if text3 then info:AppendText(text3) end
		if text4 then info:AppendText(text4) end
		if text5 then info:AppendText(text5) end
		timer.Simple( 0.001, function() info:GotoTextStart() end )

		if name ~= "About" then return end
		if not ( locPly:GetInfo("mw_code") == "about" or locPly:GetInfo("mw_code") == "ABOUT" ) then return end

		chat.AddText( "Well done" )
		locPly:ConCommand("mw_action 945")
	end
end

local function DefaultInfo()
	if not CLIENT then return end
	local pl = LocalPlayer()

	pl.info = vgui.Create("DLabel", pl.panel)
	pl.info:SetPos(190, 190)
	pl.info:SetSize(370,200)
	pl.info:SetWrap(true)
	pl.info:SetFontInternal( "Trebuchet24" )
	pl.info:SetText("Hover over a button to see more info about the units")
	--pl.mw_hover = 0

	pl.info_name = vgui.Create("DLabel", pl.panel)
	pl.info_name:SetPos(190, 50)
	pl.info_name:SetSize(370,100)
	pl.info_name:SetWrap(true)
	pl.info_name:SetFontInternal( "DermaLarge" )
	pl.info_name:SetText("-")

	pl.info_cost = vgui.Create("DLabel", pl.panel)
	pl.info_cost:SetPos(190, 110)
	pl.info_cost:SetSize(370,100)
	pl.info_cost:SetWrap(true)
	pl.info_cost:SetFontInternal( "DermaLarge" )
	pl.info_cost:SetText("Cost: ")

	pl.info_turret_cost = vgui.Create("DLabel", pl.panel)
	pl.info_turret_cost:SetPos(190, 140)
	pl.info_turret_cost:SetSize(370,100)
	pl.info_turret_cost:SetWrap(true)
	pl.info_turret_cost:SetFontInternal( "Trebuchet24" )
	pl.info_turret_cost:SetText("")

	pl.info_power = vgui.Create("DLabel", pl.panel)
	pl.info_power:SetPos(400, 110)
	pl.info_power:SetSize(370,100)
	pl.info_power:SetWrap(true)
	pl.info_power:SetFontInternal( "DermaLarge" )
	pl.info_power:SetText("Power")

	pl.info_time = vgui.Create("DLabel", pl.panel)
	pl.info_time:SetPos(400, 140)
	pl.info_time:SetSize(370,100)
	pl.info_time:SetWrap(true)
	pl.info_time:SetFontInternal( "Trebuchet24" )
	pl.info_time:SetText("")
end

local function unitScroller( lStart, lEnd, unitCheck)
	local pl = LocalPlayer()
	local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
	scroll:SetSize( 175, h-30)
	scroll:SetPos( 0, 0 )

	local ipos = 1
	for i = lStart, lEnd - 1, 1 do
		if isfunction(unitCheck) and unitCheck(MelonWars.units[i]) then
			_MakeButton(i, ipos, scroll)
			ipos = ipos + 1
		end
	end

	return scroll
end

local function _CreatePanel() --TODO: This is like 75% of the file. I should probably refactor/reorganize it. 
	if not CLIENT then return end
	local pl = LocalPlayer()

	pl.panel = vgui.Create("DPanel", pl.mw_frame)
	pl.panel:SetSize(w-120, h-25)
	pl.panel:SetPos(120,25)
	pl.panel.Paint = function(s, w, h)
		draw.RoundedBox( 4, 0, 0, w, h, Color(30,30,30) )
	end

	if (pl.mw_menu == 0) then																	--units menu
		local allowManualPlace = cvars.Bool("mw_admin_allow_manual_placing")
		local plCode = pl:GetInfo("mw_code")
		local bonusUnits = GetConVar( "mw_admin_bonusunits" ):GetBool()
		local function check(unit)
			return (allowManualPlace or unit.welded_cost ~= -1) and (not unit.code or plCode == unit.code) and (not unit.isBonusUnit or bonusUnits)
		end

		unitScroller(1, firstBuilding, check)

		if not allowManualPlace then
			pl:ConCommand("mw_unit_option_welded 1")
			local label = vgui.Create("DLabel", pl.panel)
			label:SetPos(170, 15)
			label:SetSize(400,30)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText("Mobile units only spawnable from barracks!")
			label:SetColor(orangeColor)
			label = vgui.Create("DLabel", pl.panel)
			label:SetPos(170, 40)
			label:SetSize(400,30)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText("These units will be spawned as turrets.")
			label:SetColor(orangeColor)
		else
			local checkbox = _MakeCheckbox( 180, 15, pl.panel, "Spawn as turret", "mw_unit_option_welded")
			function checkbox:OnCursorEntered()
				pl.info_name:SetText("Spawn as turret")
				pl.info_cost:SetText("")
				pl.info_turret_cost:SetText("")
				pl.info_power:SetText("")
				pl.info_time:SetText("")
				pl.info:SetText("If this is checked, you will be able to spawn units welded to where you point at, with a reduced cost. Not all units can be spawned as turret.")
			end
		end

		DefaultInfo()
	elseif (pl.mw_menu == 1) then																--Buildings menu
		local bonusUnits = GetConVar( "mw_admin_bonusunits" ):GetBool()
		local plCode = pl:GetInfo("mw_code")
		local function check(unit)
			return (not unit.code or plCode == unit.code) and (not unit.isBonusUnit or bonusUnits)
		end

		unitScroller(firstBuilding, firstEnergy, check)

		DefaultInfo()
	elseif (pl.mw_menu == 2) then																-- Base menu
		-- { BASE MENU

		local prop_info = vgui.Create("DLabel", pl.panel)
		prop_info:SetPos(360, 250)
		prop_info:SetSize(370,100)
		prop_info:SetFontInternal( "Trebuchet24" )
		prop_info:SetText("Select a prop")

		local prop_window = vgui.Create("DModelPanel", pl.panel)
		prop_window:SetPos(350, 10)
		prop_window:SetSize(200,200)
		prop_window:SetModel("models/hunter/blocks/cube025x025x025.mdl")

		local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
		scroll:SetSize( 340, h-80 )
		scroll:SetPos( 10, 30 )

		local List	= vgui.Create( "DIconLayout", scroll )
		List:SetSize( 330, 200 )
		List:SetPos( 0, 80 )
		List:SetSpaceY( 5 ) -- Sets the space in between the panels on the X Axis by 5
		List:SetSpaceX( 5 ) -- Sets the space in between the panels on the Y Axis by 5

		-- local a = table.getn(base_models)
		-- for i = 1, a do -- Make a loop to create a bunch of panels inside of the DIconLayout
		for k, v in pairs(MelonWars.baseProps) do
			local ListItem = List:Add( "SpawnIcon" ) -- Add DPanel to the DIconLayout
			ListItem:SetSize( 75, 75 ) -- Set the size of it
			ListItem:SetModel(v.model)
			function ListItem:DoClick()
				pl:ConCommand( "mw_chosen_prop " .. tostring( k ) )
				pl:ConCommand( "mw_action 3" )
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
			function ListItem:OnCursorEntered()
				prop_info:SetText( v.name .. "\nHealth: " .. v.hp .. "\nCost: " .. v.cost )
				prop_window:SetModel( v.model )
				prop_window:SetCamPos( prop_window:GetEntity():GetPos() + Vector( 150, 0, 50 ) )
				function prop_window:LayoutEntity( Entity )
					Entity:SetAngles( v.angle + Angle( 0, CurTime() * 50, 0 ) )
				end
				--prop_window:SetLookAt(prop_window:GetEntity():OBBCenter())
			end
		end

		_MakeCheckbox( 380, h - 100, pl.panel, "Offset", "mw_prop_offset" )
		_MakeCheckbox( 380, h - 150, pl.panel, "Angle Snap", "mw_prop_snap" )
		-- }
		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(220,50)
		button:SetPos(20,20)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Sell Tool")
		function button:DoClick()
			pl:ConCommand("mw_chosen_unit -1") -- -1 es el Engine
			pl:ConCommand("mw_action 5")
			pl.mw_frame:Remove()
			pl.mw_frame = nil
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end
	elseif (pl.mw_menu == 3) then																--Energy menu
		unitScroller(firstEnergy, firstContraption, function() return true end)

		DefaultInfo()
	elseif (pl.mw_menu == 4) then																--Contraption menu
		-- { SPECIAL MENU
		local tool_info = vgui.Create("DLabel", pl.panel)
		tool_info:SetPos(270, 30)
		tool_info:SetSize(300,340)
		tool_info:SetFontInternal( "Trebuchet24" )
		tool_info:SetText("Select a tool")

		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(220,50)
		button:SetPos(20,20)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Contraption Manager")
		function button:DoClick()
			pl.panel:Remove()
			pl.mw_menu = -1
			_CreatePanel()
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end

		local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
		scroll:SetSize( 175, h-105)
		scroll:SetPos( 0, 80 )

		for i = firstContraption, unitCount do
			_MakeButton(i, i - firstContraption + 1, scroll)
		end

		DefaultInfo()
		-- }
	elseif (pl.mw_menu == -1) then																--Contraption manager menu
		local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
		scroll:SetSize( 100, 50)
		scroll:SetPos( 20, 20 )

		if (cvars.Number("mw_admin_credit_cost") == 0) then
			local toolInfo1 = vgui.Create("DLabel", pl.panel)
			toolInfo1:SetPos(20, 30)
			toolInfo1:SetSize(200,50)
			toolInfo1:SetFontInternal( "Trebuchet24" )
			toolInfo1:SetText("Save contraption: ")

			local toolInfo2 = vgui.Create("DLabel", pl.panel)
			toolInfo2:SetPos(100, 85)
			toolInfo2:SetSize(500,30)
			toolInfo2:SetFontInternal( "Trebuchet18" )
			toolInfo2:SetText("Type the name, press enter and then click on your contraption")

			local TextEntry = vgui.Create( "DTextEntry", pl.panel ) -- create the form as a child of frame
			TextEntry:SetPos( 200, 30 )
			TextEntry:SetSize( 300, 50 )
			TextEntry:SetText( "name" )
			TextEntry:SetFont( "Trebuchet24" )
			TextEntry.OnEnter = function( self )
				pl.contraption_name = self:GetValue()
				pl:ConCommand("mw_action 4")
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
		else
			local tool_info = vgui.Create("DLabel", pl.panel)
			tool_info:SetPos(80, 50)
			tool_info:SetSize(500,30)
			tool_info:SetFontInternal( "Trebuchet24" )
			tool_info:SetText("You can only save contraptions in Sandbox mode")
		end

		local browser = vgui.Create( "DFileBrowser", pl.panel )
		browser:SetPos( 20, 250 )
		browser:SetSize(500, 200)

		browser:SetPath( "DATA" ) -- The access path i.e. GAME, LUA, DATA etc.
		browser:SetBaseFolder( "melonwars/contraptions" ) -- The root folder
		browser:SetName( "Contraptions" ) -- Name to display in tree
		browser:SetSearch( "contraptions" ) -- Search folders starting with "props_"
		browser:SetFileTypes( "*.txt" ) -- File type filter
		browser:SetOpen( true ) -- Opens the tree ( same as double clicking )
		browser:SetCurrentFolder( "melonwars/contraptions" ) -- Set the folder to use

		function browser:OnSelect( path, pnl ) -- Called when a file is clicked
			pl.selectedFile = path
		end

		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(220,50)
		button:SetPos(20,150)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Delete selected")
		function button:DoClick()
			button:SetText("Are you sure?")
			function button:DoClick()
				if (pl.selectedFile ~= nil) then
					file.Delete( pl.selectedFile )
					timer.Simple(0.1,function ()
						pl.panel:Remove()
						_CreatePanel()
					end)
				end
			end
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end

		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(220,50)
		button:SetPos(300,150)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Load selected")
		if (cvars.Number("mw_admin_credit_cost") == 0) then
			function button:DoClick()
				if (pl.selectedFile ~= nil) then
					pl:ConCommand("mw_action 6")
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
			end
		else
			button:SetText("Sandbox Only")
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(50,50,50) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(70,70,70) )
			end
		end
	elseif (pl.mw_menu == 5) then																--Team menu
		if cvars.Number( "mw_admin_locked_teams" ) ~= 0 then
			local label = vgui.Create("DLabel", pl.panel)
			label:SetPos(200, 220)
			label:SetSize(600,40)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText("Teams are currently locked!")
			return
		end

		local label = vgui.Create("DLabel", pl.panel)
		label:SetPos(20, 150)
		label:SetSize(200,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Select Team:")

		local selection = vgui.Create("DPanel", pl.panel)
		local mwTeam = mw_team_cv:GetInt()
		if not(mwTeam == 0) then
			selection:SetPos( 135 + mwTeam * 45, 145 )
		else
			selection:SetPos( 180, 210 )
		end
		selection:SetSize(50,50)
		selection.Paint = function(s, w, h)
			draw.RoundedBox( 10, 0, 0, w, h, color_white )
		end

		for i = 1, 8 do
			local button = vgui.Create( "DButton", pl.panel )
			button:SetSize( 40, 40 )
			button:SetPos( 140 + i * 45, 150 )
			button:SetText( "" )
			function button:DoClick()
				pl:ConCommand( "mw_team " .. tostring( i ) )
				selection:SetPos( 135 + i * 45, 145 )

				net.Start( "MW_UpdateClientInfo" )
					net.WriteInt( i, 8 )
				net.SendToServer()
			end
			button.Paint = function( s, w, h )
				draw.RoundedBox( 6, 0, 0, w, h, Color( 100, 100, 100, 255 ) )
				draw.RoundedBox( 4, 2, 2, w - 4, h - 4, MelonWars.teamColors[i] )
			end
		end

		------------------- Factions
		local label = vgui.Create("DLabel", pl.panel)
		label:SetPos(20, 275)
		label:SetSize(200,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Faction:")

		local factionSelection = vgui.Create("DPanel", pl.panel)
		factionSelection:SetSize(50,50)
		factionSelection.Paint = function(s, w, h)
			draw.RoundedBox( 10, 0, 0, w, h, color_white )
		end

		local code = cvars.String("mw_code")

		factionSelection:SetPos(180, 270)
		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(40,40)
		button:SetPos(185,275)
		button:SetText("-")
		function button:DoClick()
			pl:ConCommand("mw_code none")
			factionSelection:SetPos(180, 270)
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(90,90,90) )
			draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
		end

		if code == "full" then
			factionSelection:SetPos( 225, 270 )
		end
		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(40,40)
		button:SetPos(185+45,275)
		button:SetText("F")
		function button:DoClick()
			pl:ConCommand("mw_code full")
			factionSelection:SetPos(180+45, 270)
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(255,240,60) )
			draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
		end

		if code == "void" then
			factionSelection:SetPos( 270, 270 )
		end
		local button = vgui.Create( "DButton", pl.panel )
		button:SetSize( 40, 40 )
		button:SetPos( 275, 275 )
		button:SetText("V")
		function button:DoClick()
			pl:ConCommand( "mw_code void" )
			factionSelection:SetPos( 270, 270 )
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,30,240) )
			draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
		end

		if (code == "prot") then
			factionSelection:SetPos(180+135, 270)
		end
		local button = vgui.Create("DButton", pl.panel)
		button:SetSize(40,40)
		button:SetPos(185 + 135,275)
		button:SetText("P")
		function button:DoClick()
			pl:ConCommand("mw_code prot")
			factionSelection:SetPos(180 + 135, 270)
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(20,170,230) )
			draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
		end
		------------------------------------------

		if not pl:IsAdmin() then return end
		local label = vgui.Create("DLabel", pl.panel)
		label:SetPos(20, 215)
		label:SetSize(200,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Gray Team:")

		local button = vgui.Create("DButton", pl.panel)
		button:SetSize( 40, 40 )
		button:SetPos( 185, 215 )
		button:SetText("")
		function button:DoClick()
			pl:ConCommand( "mw_team " .. tostring( 0 ) )
			selection:SetPos( 180, 210 )

			net.Start("MW_UpdateClientInfo")
				net.WriteInt(0, 8)
			net.SendToServer()
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
			draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(80,80,80,255) )
		end
	elseif (pl.mw_menu == 6) then																--Help menu
		-- { HELP MENU

		local info = vgui.Create( "RichText", pl.panel )
		info:SetPos( 120, 20 )
		info:SetSize( 450,450 )
		info:SetWrap( true )
		info:SetContentAlignment( 7 )
		timer.Simple( 0.001, function() info:SetFontInternal( "Trebuchet24" ) end )
		info:SetText( "Thanks for downloading and using the MelonWars:RTS addon. I hope you enjoy it.\n\nChoose a category on the left to see info about a certain topic!" )

		--TODO: I really fucking suck at being concise.
		_MakeHelpButton( "About", 0, info, "What is MelonWars:Factions?\n\n" ..
			"This is a heavily modified version of MelonWars:RTS, which is itself a re-make of a Gmod 12 addon known as WarMelons:RTS.\n\n" ..
			"MelonWars:Factions is my own expansion of/continuation of Melon Wars. It includes new units and buildings, as well as substantial improvements to performance, security, and a LOT of bug-fixes.\n\n" ..
			"Every faction has been substantially reworked, with each one getting 2 new buildings, and almost every faction unit being rebalanced, reworked, or entirely replaced." ..
			"The new versions are no-longer horrendously overpowered, and all of them are useful in some way, whilst still sticking to and reinforcing their factions' theme.\n\n" ..
			"A few of the non-faction units/buildings have been tweaked a little, but none as substantially as the faction units. They're now a bit better-balanced for competititve play," ..
			"but they should still be familiar to anyone who's played the original.\n\n" ,
			"A few units have been removed that either overlapped too heavily in purpose with others, or whose concepts just didn't work well with the rest of the game." ..
			"If you feel the addon's missing something without them, though, you can re-enable them through the admin menu (game-balance-be-damned)"
		)
		info:SetFontInternal("Trebuchet24")

		_MakeHelpButton( "Help", 1, info, "Introduction:\n\nThis addon is a tool that allows you and your friends to play a Real Time Strategy game, similar to StarCraft or Age of Empires, but much simpler.\n\n" ..
			"Getting Started:\n\nIf you are seeing this, you probably know how to equip this tool already, but just in case you forget, I'll explain how to equip it.\n\n" ..
			"Hold Q (or your spawn menu key), and go to the Tools tab, on the upper right.\n\nUnder the category 'MelonWars: RTS', there's the Player Tool. This is pretty much all you need to play.\n\n" ..
			"Select the Player Tool. With this tool equipped, you can now press your Reload key (R by default) to open up the Melon Wars menu. You are going to be using this menu a lot.\n" ..
			"Feel free to navigate this menu on your own. For more help on how the menu works and what to do, please choose the 'Menu' category, to the left." )

		_MakeHelpButton( "Menu", 2, info, "The Melon Wars Menu:\n\nThis menu can be opened and closed with the Reload key while you have the Player Tool equipped, and it has everything you need to play MelonWars.\n\n" ..
			"You have different submenus on the left:\nUnits, Buildings, Base, Energy, Contrap., Team, Help and Admin.\n\n" ..
			"From the Units category, you can spawn different kinds of melons to fight for your team. Inside, you can see info about each unit. Click on a unit to start spawning. The crosshair will change while you are spawning units.\n\n" ..
			"The Buildings menu works similarly to the Units menu, but has different kinds of utility houses and machines to help you improve your army.\n\n" ..
			"From the Base category, you can select props to spawn as defense and walls. You can see the prop's health and cost on the right, as well as toggle Angle Snap and Offset. " ..
			"The Angle Snap option allows you to snap props to 15 degree intervals. The Offset, if disabled, spawns the prop at its origin, rather than a custom point.\n\n",
			"The Energy menu contains buildings that generate, store or transport Energy.\n\n" ..
			"The Contrap. menu is where you spawn contraption parts from, as well as manage your saved contraptions. To learn what a contraption is, go to the Contrap. help tab.\n\n" ..
			"In the Team menu, you can choose which team you want to be on.\n\nThe Help menu is this menu right here!\n\n" ..
			"And finally, the Admin menu is where the server owner can set all of the options for the gamemode." )

		_MakeHelpButton( "Spawning", 3, info, "How do I spawn units?\n\n" ..
			"Once you've selected a unit from the Units menu or a building from the Buildings menu, your toolgun will be set to Spawn the selected unit. While selecting, your crosshair changes, and the selected unit is displayed below it.\n\n" ..
			"While the toolgun is set to spawn, click on the ground to spawn the selected unit. Units have a Water cost and a Power cost. " ..
			"Water is the game's main resource, and it will be depleted when spawning units unless the admin option 'Free Water' is set to true (which it is by default). Power usage increases the more units you have, and you can't spawn units if your power has reached its max.\n\n" ..
			"From the Units menu, you can also select an option to spawn units as Turrets, which reduces their cost but spawns them welded to what you are looking at. Some units can't be spawned as turrets, such as Nukes and Jetpacks." )

		_MakeHelpButton( "Energy", 4, info, "What is Energy for?\n\n" ..
			"Energy is used to power certain buildings that need it to operate. Buildings that interact with Energy appear with Yellow buttons on the spawn menu.\n" ..
			"Buildings use a lot more power than what a player usually generates, so it's a good idea to store it in Batteries in order to have enough when you need it.\n\n" ..
			"How do I connect buildings?\n\nTo connect Energy buildings, use the Relay located in the Energy submenu. For buildings to work, you will need to connect some sort of battery to the network." )

		_MakeHelpButton( "Contrap.", 5, info, "What is a contraption?\n\nA contraption is a machine built by the player that can be used in melon combat as a vehicle. It can be used for ramming, as a tank, as transport, or anything you can imagine.\n\n" ..
			"How do I build them?\n\nBuild a contraption just like you would in Sandbox. Beware that parts like thrusters, hoverballs, and wheels will get removed when you 'legalize' the contraption.\n\n" ..
			"What is legalizing?\n\nIn order to make your contraption legal inside the MelonWars battle, you have to save it using the Contraption Manager, located under the Contrap. menu, and spawn it using a Contraption Assembler.\n\n" ..
			"How do I make my contraption move?\n\nUnder the Contrap. submenu, you have Thrusters, Wheels, Propellers and Hover Pads. " ..
			"The Thruster is a powerful melon that cannot shoot, but it is very strong and can move even if attached to a contraption. The Wheel can be used to help your contraption roll across the ground. The Propeller and Hover Pad can be used to make your contraption hover above ground." )

		_MakeHelpButton("Setup", 6, info, "How do I set up a game?\n\n" ..
			"In order to set up a game, you should build an arena out of props or go to a MelonWars map. The admin should ask the players what colors they want to be, then spawn a Base (or Grand War Base) from the Admin menu for each player at different locations.\n\n" ..
			"Be sure to ask every player to set their team in the Teams tab in this menu.\n\nSpawn a few outposts and capture points around the arena as objectives, and once everything is set up, press the Start Match button.\n\n" ..
			"The admin can also set alliances from the Admin tab.\n\nOnce the match starts, it's a battle to destroy the enemies' bases. Last team standing wins!\n\n" ..
			"Remember, this is as much a gamemode as it is a toy, so there is no actual 'end' to the match other than whatever you make it. " ..
			"You can play until the last base is destroyed, until only one player has units, or any other condition you can imagine. Just be sure to be clear about it with all players before starting." )

		_MakeHelpButton("Factions", 7, info, "How do I set up a game?\n\n" ..
			"If you're reading this, JonahSoldier forgot to write anything here!" )

		_MakeHelpButton("Credits", 8, info, "All the cool people who helped make this mod a reality:\n\n" ..
			"Melon Wars:Factions\n" ..
			"	Creator: JonahSoldier\n" ..
			"	Contributor(s):\n" ..
			"		thecraftianman\n\n" ..
			"	Playtesters:\n" ..
			"		MerekiDor\n" ..
			"		D-Boi-9341\n" ..
			"		Andrew\n".. --idk what to put here, his names aren't exactly recognisable. Maybe Commander Kettle?
			"		Kazzigum\n\n" .. --TODO: Ask everyone if they want to be included here.
			"If You're from my private server and want to be added to this list, dm me!\n\n\n" ..
			"The Original Melon Wars:\n"..
			"	Creator: Marum\n" ..
			"	Testers and supporters:\n		X marks it\n		(Xen)SunnY\n		BOOM! The_Rusty_Geek\n		Dagren\n		Fush\n		Broh\n		Jwanito\n		Mr. Thompson\n		Arheisel\n		Hipnox\n\n" ..
			"	Suggestions:\n		Squid-Inked (Tesla Tower)\n		Durendal5150 (Radar)"
		)

		-- }
	elseif (pl.mw_menu == 7) then																--Admin menu
		-- { ADMIN MENU
		if not(pl:IsAdmin() or cvars.Number("mw_admin_open_permits") == 1) then
			local label = vgui.Create("DLabel", pl.panel)
			label:SetPos(120, 210)
			label:SetSize(370,30)
			label:SetFontInternal( "DermaLarge" )
			label:SetText("This menu is for admins only")
			return
		end

		local y = 20
		local scroll = vgui.Create("DScrollPanel", pl.panel)
		local px, py = pl.panel:GetSize()
		scroll:SetPos(0,0)
		scroll:SetSize(px, py)

		local button = vgui.Create("DButton", scroll)
		button:SetSize(200,40)
		button:SetPos(20,y)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Start Match")
		function button:DoClick()
			net.Start("StartGame")
			net.SendToServer()
			pl.mw_frame:Remove()
			pl.mw_frame = nil
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end
		local label = vgui.Create("DLabel", scroll)
		label:SetPos(270, y)
		label:SetSize(370,40)
		label:SetFontInternal( "Trebuchet18" )
		label:SetText("[Set preferences for a match of MelonWars]")
		y = y + 50
		local button = vgui.Create("DButton", scroll)
		button:SetSize(200,40)
		button:SetPos(20,y)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Sandbox Mode")
		function button:DoClick()
			pl:ConCommand("mw_admin_playing 1")
			pl:ConCommand("mw_admin_locked_teams 0")
			pl:ConCommand("mw_admin_move_any_team 1")
			pl:ConCommand("mw_admin_credit_cost 0")
			pl:ConCommand("mw_admin_allow_free_placing 1")
			pl:ConCommand("mw_admin_spawn_time 0")
			pl:ConCommand("mw_admin_allow_manual_placing 1")
			net.Start("SandboxMode")
			net.SendToServer()
			pl.mw_frame:Remove()
			pl.mw_frame = nil
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end
		local label = vgui.Create("DLabel", scroll)
		label:SetPos(270, y)
		label:SetSize(370,40)
		label:SetFontInternal( "Trebuchet18" )
		label:SetText("[Set preferences for messing around]")
		y = y + 80

		local label = vgui.Create("DLabel", scroll)
		label:SetPos(20, y)
		label:SetSize(300,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Game Control Options")

		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Pause", "mw_admin_playing", "[Stops units, income and controls]", true )

		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Lock Teams", "mw_admin_locked_teams", "[Prevent players from changing team or faction]", false )

		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Extra Unit Options", "mw_admin_bonusunits", "[Balance not guaranteed]", false )

		y = y + 80

		local function baseSpawner(text, action)
			local label = vgui.Create("DLabel", scroll)
			label:SetPos(15, y)
			label:SetSize(200,60)
			label:SetFontInternal( "DermaLarge" )
			label:SetText( text )
			for i = 1, 8 do
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos( 145 + i * 45, y )
				button:SetText("")
				function button:DoClick()
					pl:ConCommand("mw_team " .. tostring(i))
					pl:ConCommand("mw_action " .. tostring(action))
					pl.mw_frame:Remove()
					pl.mw_frame = nil

					net.Start("MW_UpdateClientInfo")
						net.WriteInt(i, 8)
					net.SendToServer()
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, MelonWars.teamColors[i] )
				end
			end
		end

		baseSpawner("Spawn\nNormal Base", 2)
		y = y + 80

		baseSpawner("Spawn Grand\nWar Base", 7)
		y = y + 80

		baseSpawner("Spawn\nOrnament", 25)
		y = y + 80

		local label = vgui.Create("DLabel", scroll)
		label:SetPos(20, y)
		label:SetSize(400,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Alternative Gameplay Options")

		y = y + 40

		_MakeCheckbox( 20, y, scroll, "No Manual Placing", "mw_admin_allow_manual_placing", "[Prevents spawning of mobile units]", true)

		y = y + 40

		_MakeCheckbox( 20, y, scroll, "Ban Contraptions", "mw_admin_ban_contraptions", "[Disable contraption assemblers]", false)

		y = y + 60

		local label = vgui.Create("DLabel", scroll)
		label:SetPos(20, y)
		label:SetSize(300,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Cheats")

		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Instant Spawn", "mw_admin_spawn_time", "[Makes units spawn instantly]", true )
		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Infinite Water", "mw_admin_credit_cost", "[Allows you to spawn units without cost]", true )
		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Build Anywhere", "mw_admin_allow_free_placing", "[Allows you to spawn units anywhere]" )
		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Control Any Team", "mw_admin_move_any_team", "[Allows you to control units regardless of team]" )
		y = y + 40
		_MakeCheckbox( 20, y, scroll, "Immortal Units", "mw_admin_immortality", "[Units can't die. Useful for photography]" )

		y = y + 60
		local button = vgui.Create("DButton", scroll)
		button:SetSize(200,40)
		button:SetPos(20,y)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Reset Credits")
		function button:DoClick()
			pl:ConCommand("mw_reset_credits")
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end
		local label = vgui.Create("DLabel", scroll)
		label:SetPos(270, y)
		label:SetSize(370,40)
		label:SetFontInternal( "Trebuchet18" )
		label:SetText("[Set all credits back to the default]")
		y = y + 45
		local button = vgui.Create("DButton", scroll)
		button:SetSize(200,40)
		button:SetPos(20,y)
		button:SetFont("CloseCaption_Normal")
		button:SetText("Reset Power")
		function button:DoClick()
			pl:ConCommand("mw_reset_power")
		end
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
		end
		local label = vgui.Create("DLabel", scroll)
		label:SetPos(270, y)
		label:SetSize(370,40)
		label:SetFontInternal( "Trebuchet18" )
		label:SetText("[Set all Power back to the default]")
		y = y + 70
		-----------------------------------------------------------  Resource Sliders
		local function resourceSlider(text, convar, lenMul, valMul)
			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y-20)
			label:SetSize(200,80)
			label:SetFontInternal( "DermaLarge" )
			label:SetText( text .. tostring( cvars.Number( convar ) ) )
			local default = vgui.Create("DPanel", scroll)
			default:SetSize(360,60)
			default:SetPos( 200, y - 10 )
			local slider = vgui.Create("DPanel", scroll)
			slider:SetSize( cvars.Number( convar ) * lenMul, 40 )
			slider:SetPos(200,y)
			for i = 1, 30 do
				local button = vgui.Create( "DButton", scroll )
				button:SetSize( 15, 40 )
				button:SetPos( 185 + i * 12, y )
				button:SetText( "" )
				function button:DoClick()
					pl:ConCommand( convar .. " " .. tostring( i * valMul ) )
					slider:SetSize( i * 12, 40 )
					label:SetText( text .. tostring( i * valMul ) )
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 0, w-1, 0, 1, h, Color(100,100,100) )
				end
			end
			return default
		end

		local default1 = resourceSlider("Power: \n", "mw_admin_max_units", 1.2, 10)
		default1.Paint = function(s, w, h)
			draw.RoundedBox( 0, 108, 0, 12, h, Color(10,150,10) )
			draw.RoundedBox( 0, 0, 0, 12*6, h, Color(10,40,80) )
			draw.RoundedBox( 0, 12*15, 0, 12*15, h, Color(80,10,10) )
		end

		y = y + 70
		local default2 = resourceSlider("Starting Water:\n", "mw_admin_starting_credits", 12 / 200, 200)
		default2.Paint = function(s, w, h)
			draw.RoundedBox( 0, 108, 0, 12, h, Color(10,150,10) )
			draw.RoundedBox( 0, 0, 0, 12*6, h, Color(10,40,80) )
			draw.RoundedBox( 0, 12*15, 0, 12*15, h, Color(80,10,10) )
		end

		y = y + 70
		local default3 = resourceSlider("Water Income:\n", "mw_admin_base_income", 12 / 5, 5)
		default3.Paint = function(s, w, h)
			draw.RoundedBox( 0, 48, 0, 12, h, Color(10,150,10) )
			draw.RoundedBox( 0, 0, 0, 12*2, h, Color(10,40,80) )
			draw.RoundedBox( 0, 12*8, 0, 12*22, h, Color(80,10,10) )
		end

		y = y + 70
		local default4 = resourceSlider("Water Tank\nValue:", "mw_water_tank_value", 0.012, 1000)
		default4.Paint = function( s, w, h )
			draw.RoundedBox( 0, 108, 0, 12, h, Color( 10, 150, 10 ) )
			draw.RoundedBox( 0, 0, 0, 72, h, Color( 10, 40, 80 ) )
			draw.RoundedBox( 0, 180, 0, 180, h, Color( 80, 10, 10 ) )
		end

		y = y + 120
		-------------------------------------------------------- TEAMS
		local label = vgui.Create("DLabel", scroll)
		label:SetPos( 20, y - 45 )
		label:SetSize(370,40)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("Alliances")
		local grid = vgui.Create( "DGrid", scroll )
		grid:SetPos( 160, y )
		grid:SetCols( 8 )
		grid:SetColWide( 30 )
		for i = 1, 8 do
			for j=1, 8 do
				local checkbox = vgui.Create( "DButton" ) -- Create the checkbox
				checkbox:SetPos( 20, y ) -- Set the position
				checkbox:SetSize(30,30)
				checkbox:SetText("")

				if (9-i ~= j) then
					function checkbox:DoClick()
						MelonWars.teamGrid[9-i][j] = not MelonWars.teamGrid[9-i][j]
						MelonWars.teamGrid[j][9-i] = MelonWars.teamGrid[9-i][j]
						net.Start("UpdateServerTeams")
							net.WriteTable(MelonWars.teamGrid)
						net.SendToServer()
					end
					if (i+j < 9) then
						checkbox.Paint = function(s, w, h)
							draw.RoundedBox( 4, 0, 0, w, h, Color(150,150,150) )
							draw.RoundedBox( 2, 2, 2, w-4, h-4, Color(0,0,0) )
							if (MelonWars.teamGrid[9-i][j]) then
								draw.RoundedBox( 0, 4, 4, w / 2-4, h-8, MelonWars.teamColors[9-i] )
								draw.RoundedBox( 0, 4+w / 2-4, 4, w / 2-4, h-8, MelonWars.teamColors[j] )
							end
						end
					else
						checkbox.Paint = function(s, w, h)
							draw.RoundedBox( 8, 0, 0, w, h, Color(30,30,30) )
							draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(20,20,20) )
							if (MelonWars.teamGrid[9-i][j]) then
								draw.RoundedBox( 4, 4, 4, w-8, h-8, Color(30,30,30) )
							end
						end
					end
				else
					checkbox.Paint = function(s, w, h)
					end
				end
				grid:AddItem(checkbox)
			end
		end
		-- Horizontal teams
		grid = vgui.Create( "DGrid", scroll )
		grid:SetPos( 160, y-35 )
		grid:SetCols( 8 )
		grid:SetColWide( 30 )
		for i = 1, 8 do
			local DPanel = vgui.Create( "DPanel" )
			DPanel:SetSize( 30, 30 ) -- Set the size of the panel
			DPanel.Paint = function(s, w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color(150,150,150) )
				draw.RoundedBox( 6, 2, 2, w-4, h-4, MelonWars.teamColors[i] )
			end
			grid:AddItem(DPanel)
		end
		-- Vertical teams
		grid = vgui.Create( "DGrid", scroll )
		grid:SetPos( 160-35, y )
		grid:SetCols( 1 )
		grid:SetColWide( 30 )
		for i = 8, 1, -1 do
			local DPanel = vgui.Create( "DPanel" )
				DPanel:SetSize( 30, 30 ) -- Set the size of the panel
			DPanel.Paint = function(s, w, h)
				draw.RoundedBox( 8, 0, 0, w, h, Color(150,150,150) )
				draw.RoundedBox( 6, 2, 2, w-4, h-4, MelonWars.teamColors[i] )
			end
			grid:AddItem(DPanel)
		end
		-- }
	elseif (pl.mw_menu == 8) then -- Player menu
		--TODO: See if I can re-use the slider function
		local y = 20
		local scroll = vgui.Create("DScrollPanel", pl.panel)
		local px, py = pl.panel:GetSize()
		scroll:SetPos(0,0)
		scroll:SetSize(px, py)
		-------------------------------------------------------- Start
		--Build sphere alpha
		y = y + 70
		local label = vgui.Create("DLabel", scroll)
		label:SetPos(20, y-20)
		label:SetSize(250,80)
		label:SetFontInternal( "DermaLarge" )
		label:SetText("BuildSphere Alpha:\n" .. tostring(math.Round(GetConVar("mw_buildalpha_multiplier"):GetFloat(),1)))

		local slider = vgui.Create("DPanel", scroll)
		slider:SetSize(GetConVar("mw_buildalpha_multiplier"):GetFloat() * 120,40)
		slider:SetPos(65,y + 20)
		for i = 1, 35 do
			local button = vgui.Create("DButton", scroll)
			button:SetSize(15,40)
			button:SetPos(50+i*12,y + 20)
			button:SetText("")
			function button:DoClick()
				pl:ConCommand("mw_buildalpha_multiplier " .. tostring(math.Round(i/10,1)))
				slider:SetSize(i*12, 40)
				label:SetText("BuildSphere Alpha:\n" .. tostring(math.Round(i/10,1)))
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 0, w-1, 0, 1, h, Color(100,100,100) )
			end
		end

		local label = vgui.Create("DLabel", scroll)
		label:SetPos( 20, y + 40 )
		label:SetSize( 450, 80 )
		label:SetFontInternal( "Trebuchet24" )
		label:SetText("The transparency of HQ build range bubbles")

		y = y + 120

		-- Player readyup
		_MakeCheckbox(20, y, scroll, "[Ready Up]", "mw_player_ready")
	end
end


-- SELECTION CODE: ----------------------------------

local function MW_BeginSelection() -- Previously concommand.Add( "+mw_select", function( ply )
	if not CLIENT then return end

	local ply = LocalPlayer()
	ply.mw_selecting = true
	local eyePos = ply:EyePos()
	local trace = util.TraceLine( {
		start = eyePos,
		endpos = eyePos + ply:EyeAngles():Forward() * 10000,
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

local function MW_FinishSelection() -- Previously concommand.Add( "-mw_select", function( ply )
	if not CLIENT then return end

	sound.Play( "buttons/lightswitch2.wav", LocalPlayer():GetPos(), 50, 80, 1 )
	LocalPlayer().mw_selecting = false
end

function TOOL:MW_SelectionThink() --This might be a little jank because I wrote it in ~2020. It works properly so I don't feel the need to rewrite it.
	local ply = LocalPlayer()
	local eyePos = ply:EyePos()
	local eyeForwards = ply:EyeAngles():Forward()
	local specialTrace = util.TraceLine( {
		start = eyePos,
		endpos = eyePos + eyeForwards * 10000,
		filter = function( ent ) if ( ent:GetClass() ~= "player" ) then return true end end,
		mask = MASK_SOLID + MASK_WATER
	} )

	local desiredZ = ply.mw_selectionStartingPoint[3]
	local actualZ = specialTrace.HitPos[3]
	local eyeZ = eyePos[3]
	local finalPosition

	if desiredZ < eyeZ and actualZ < desiredZ then
		local fraction = ( eyeZ - desiredZ ) / ( eyeZ - actualZ ) -- Distance to desired z as fraction of the whole trace's length
		local length = 10000 * specialTrace.Fraction --The trace's length.
		finalPosition = eyePos + ( eyeForwards * (fraction * length) )
	else
		finalPosition = specialTrace.HitPos
	end

	ply.mw_selectionEndingPoint = ( ply.mw_selectionEndingPoint * 9 + finalPosition ) / 10

	if input.IsMouseDown( MOUSE_LEFT ) then return true end

	--This should probably be put into finishSelection
	self:DoSelection( ply.mw_selectionStartingPoint, finalPosition )
	MW_FinishSelection()
	ply.mw_selecting = false
end

function TOOL:DoSelection(startingPos, endingPos)
	local center = (startingPos + endingPos) / 2
	local radius = (startingPos - endingPos):Length() / 2

	--local foundEntities = {}
	local locPly = LocalPlayer()

	if locPly.foundMelons and not locPly:KeyDown(IN_SPEED) then
		table.Empty(locPly.foundMelons)
	end

	locPly.lastSelectionTime = locPly.lastSelectionTime or CurTime()

	local _team = locPly:GetInfoNum("mw_team", -2)

	locPly.mw_selectionID = locPly.mw_selectionID or 0

	locPly.mw_selectionID = ( locPly.mw_selectionID + 1 ) % 255

	local clickedUnit = locPly:GetEyeTrace().Entity
	local doubleClick = locPly.lastSelectionTime + 0.3 > CurTime() and IsValid( clickedUnit )

	radius = (doubleClick and 300) or radius
	foundEntities = MelonWars.selectionCylinder(center, radius, _team, clickedUnit, doubleClick)

	net.Start("MW_RequestSelection")
		net.WriteUInt(locPly.mw_selectionID, 8)
		net.WriteVector(center)
		net.WriteFloat(radius)
		net.WriteEntity(clickedUnit)
		net.WriteBool(doubleClick)
	net.SendToServer()

	locPly.lastSelectionTime = CurTime()

	locPly.foundMelons = table.Copy(foundEntities)
end

-- CONTRAPTION CODE: ----------------------------------

local function SelectContraption(pl, path, contraptionName, contraptionCost, contraptionPower)
	local fulltable = util.JSONToTable(file.Read( path ))
	local dupetable = fulltable.Entities

	local cost, spawnTime, power = MelonWars.calculateContraptionValues( dupetable )

	pl.selectedAssembler:SetNWFloat("slowThinkTimer", spawnTime)

	pl.selectedFile = path
	contraptionName:SetText("Contraption: " .. string.sub(path, string.len( "melonwars/contraptions/" ) + 1, string.len( path ) - 4))
	contraptionCost:SetText("Cost: " .. cost)
	contraptionPower:SetText("Power: " .. power)
	return cost, power
end

local function StartBuildingContraption( assembler, _file, cost, power )
	if assembler:GetNWBool( "active" ) then return end
	local locPly = LocalPlayer()
	if locPly.mw_units >= cvars.Number( "mw_admin_max_units" ) then return end
	if locPly.mw_credits < locPly.contrapCost or cvars.Bool( "mw_admin_credit_cost" ) then return end
	if locPly.contrapPower ~= 0 and locPly.mw_units + locPly.contrapPower > cvars.Number( "mw_admin_max_units" ) then return end

	--Most of this should be server-only.
	assembler.nextSlowThink = CurTime() + assembler:GetNWFloat("slowThinkTimer", 0)
	assembler:SetNWFloat("nextSlowThink", CurTime() + assembler:GetNWFloat("slowThinkTimer", 0))
	assembler.unitspawned = false
	assembler:SetNWBool("active", true)
	assembler.player = locPly
	assembler.file = _file
	assembler.contrapCost = cost
	assembler.contrapPower = power

	net.Start("RequestContraptionLoadToAssembler")
		net.WriteEntity(assembler)
		net.WriteUInt(locPly.contrapPower, 10)
		net.WriteString(_file)
		net.WriteFloat(assembler:GetNWFloat("slowThinkTimer", 0))
	net.SendToServer()

	if cvars.Bool("mw_admin_credit_cost") then --TODO: This shouldn't be on client 
		local newCredits = locPly.mw_credits-locPly.contrapCost
		net.Start("MW_UpdateServerInfo")
			net.WriteInt(mw_team_cv:GetInt(), 8)
			net.WriteInt(newCredits, 32)
		net.SendToServer()
		net.Start("MW_UpdateClientInfo")
			net.WriteInt(mw_team_cv:GetInt(), 8)
		net.SendToServer()
	end

	locPly.cmenuframe:Remove()
	locPly.cmenuframe = nil
end

function TOOL:MakeContraptionMenu()
	local locPly = LocalPlayer()

	--I think this is used for the "Double-click e to spawn last contraption" thing. It needs a rewrite.
	if locPly.cmenuframe ~= nil then
		if locPly.selectedAssembler.file == nil then return end

		local fulltable = util.JSONToTable(file.Read(locPly.selectedAssembler.file))
		local dupetable = fulltable.Entities

		local cost, spawnTime, power = MelonWars.calculateContraptionValues( dupetable )
		locPly.contrapCost = cost
		locPly.contrapPower = power
		locPly.selectedAssembler:SetNWFloat("slowThinkTimer", spawnTime) --Does this actually matter on client?

		-- Make the contrap
		StartBuildingContraption(locPly.selectedAssembler, locPly.selectedAssembler.file, locPly.contrapCost, locPly.contrapPower)
		return
	end

	--if locPly.cmenuframe ~= nil then return end
	if locPly.selectedAssembler:GetNWBool( "active", true ) then return end

	locPly.cmenuframe = vgui.Create("DFrame")
	local w = 400
	local h = 400
	-- local freeze = net.ReadBool()
	locPly.cmenuframe:SetSize(w, h)
	locPly.cmenuframe:SetPos(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2)
	locPly.cmenuframe:SetTitle("Contraption Legalizer")
	locPly.cmenuframe:MakePopup()

	locPly.cmenuframe.OnClose = function()
		locPly.cmenuframe = nil
	end

	local contraptionName = vgui.Create("DLabel", locPly.cmenuframe)
	contraptionName:SetPos( 30, 90)
	contraptionName:SetSize(300,30)
	contraptionName:SetFontInternal( "Trebuchet18" )
	contraptionName:SetText("Press E again to spawn last spawned contraption")

	local contraptionName = vgui.Create("DLabel", locPly.cmenuframe)
	contraptionName:SetPos( 30, 110)
	contraptionName:SetSize(300,30)
	contraptionName:SetFontInternal( "Trebuchet24" )
	contraptionName:SetText("Contraption: ")

	local contraptionCost = vgui.Create("DLabel", locPly.cmenuframe)
	contraptionCost:SetPos( 30, 150)
	contraptionCost:SetSize(300,30)
	contraptionCost:SetFontInternal( "Trebuchet24" )
	contraptionCost:SetText("Cost:")

	local contraptionPower = vgui.Create("DLabel", locPly.cmenuframe)
	contraptionPower:SetPos( 200, 150)
	contraptionPower:SetSize(300,30)
	contraptionPower:SetFontInternal( "Trebuchet24" )
	contraptionPower:SetText("Power:")

	if (locPly.selectedAssembler ~= nil and locPly.selectedAssembler.file ~= nil) then
		locPly.contrapCost, locPly.contrapPower = SelectContraption(locPly, locPly.selectedAssembler.file, contraptionName, contraptionCost, contraptionPower)
	end

	local button = vgui.Create("DButton", locPly.cmenuframe)
	button:SetSize(180,40)
	button:SetPos(110, 50)
	button:SetFont("CloseCaption_Normal")
	button:SetText("Produce")
	function button:DoClick()
		if (IsEntity(locPly.selectedAssembler)) then
			StartBuildingContraption(locPly.selectedAssembler, locPly.selectedFile, locPly.contrapCost, locPly.contrapPower)
		else
			print("Somehow, the contraption assembler you have selected doesn't seem to be an Entity")
			print(locPly.selectedAssembler)
			debug.Trace()
		end
	end
	button.Paint = function(s, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
		draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
	end

	local browser = vgui.Create( "DFileBrowser", locPly.cmenuframe )
	browser:SetPos( 25, 200 )
	browser:SetSize(350, 175)

	browser:SetPath( "DATA" ) -- The access path i.e. GAME, LUA, DATA etc.
	browser:SetBaseFolder( "melonwars/contraptions" ) -- The root folder
	browser:SetName( "Contraptions" ) -- Name to display in tree
	browser:SetSearch( "contraptions" ) -- Search folders starting with "props_"
	browser:SetFileTypes( "*.txt" ) -- File type filter
	browser:SetOpen( true ) -- Opens the tree ( same as double clicking )
	browser:SetCurrentFolder( "melonwars/contraptions" ) -- Set the folder to use

	function browser:OnSelect( path, pnl )
		locPly.contrapCost, locPly.contrapPower = SelectContraption(locPly, path, contraptionName, contraptionCost, contraptionPower)
	end
end

-- TOOL FUNCTIONS: ----------------------------------

function TOOL:LeftClick( tr )
	if not CLIENT then return end
	local pl = LocalPlayer()

	if IsValid( self:GetOwner().controllingUnit ) then
		if not IsFirstTimePredicted() then return end
		local cUnit = pl.controllingUnit
		net.Start( "MWControlShoot" )
			net.WriteEntity( cUnit )
			net.WriteVector( pl.controlTrace.HitPos )
		net.SendToServer()
		return
	end

	if pl.mw_cooldown >= CurTime() - 0.1 then return end

	local trace = self:GetOwner():GetEyeTrace( {
		mask = MASK_SOLID + MASK_WATER
	} ) --TODO: We can probably use the "tr" value passed in instead.

	pl.mw_cooldown = CurTime()
	mw_melonTeam = pl:GetInfoNum("mw_team", 0)

	local action = mw_action_cv:GetInt() -- pl:GetInfoNum("mw_action", 0)
	if action == 0 then
		MW_BeginSelection()
		pl.mw_selectTimer = CurTime()
		pl.mw_spawnTimer = CurTime()
	elseif action == 1 then
		if pl.mw_spawnTimer >= CurTime() - 0.1 then return end
		pl.mw_spawnTimer = CurTime()

		local unit_index = pl:GetInfoNum("mw_chosen_unit", 0)
		local attach = pl:GetInfoNum("mw_unit_option_welded", 0)

		if not MelonWars.canSpawn(unit_index, attach, mw_melonTeam, trace.HitPos, pl, trace.Entity) then
			return
		end

		if cvars.Number("mw_admin_spawn_time") == 1 then
			if (pl.mw_spawntime < CurTime()) then
				pl.mw_spawntime = CurTime() + MelonWars.units[unit_index].spawn_time * pl.spawnTimeMult + 1 -- spawntimemult has been added here so I can compensate for matches with uneven numbers of commanders
			else
				pl.mw_spawntime = pl.mw_spawntime + MelonWars.units[unit_index].spawn_time * pl.spawnTimeMult
			end
		end

		local spawnAngle
		if (MelonWars.units[unit_index].normalAngle) then
			spawnAngle = trace.HitNormal:Angle() + MelonWars.units[unit_index].angle
		else
			if (MelonWars.units[unit_index].changeAngles) then
				spawnAngle = pl.propAngle + MelonWars.units[unit_index].angle
			else
				spawnAngle = MelonWars.units[unit_index].angle
			end
		end

		--local spawnPosition = trace.HitPos + Vector(0,0,1) + trace.HitNormal*5+MelonWars.units[unit_index].offset

		net.Start("MW_SpawnUnit")
			net.WriteInt(unit_index, 16)
			net.WriteInt(mw_melonTeam, 4)
			net.WriteBool(attach)
			net.WriteAngle(spawnAngle)
			--net.WriteVector(spawnPosition)
		net.SendToServer()

		local effectdata = EffectData()
		effectdata:SetEntity( newMarine )
		util.Effect( "propspawn", effectdata )

		if cvars.Bool( "mw_admin_credit_cost" ) or mw_melonTeam == 0 then
			local cost = MelonWars.unitCost(unit_index, attach)
			self:IndicateIncome(-cost)
			pl.mw_credits = pl.mw_credits-cost
		end

		pl.mw_spawnTimer = CurTime()
	elseif action == 2 then
		net.Start("SpawnBase")
			net.WriteTable(trace)
			net.WriteInt(mw_melonTeam, 8)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif action == 3 then
		if pl.mw_spawnTimer >= CurTime() - 0.1 then return end
		local prop_index = pl:GetInfoNum("mw_chosen_prop", 0)
		local cost = MelonWars.baseProps[prop_index].cost
		if not mw_admin_playing_cv:GetBool() then return end
		if not (cvars.Bool("mw_admin_allow_free_placing") or MelonWars.isInRange(trace.HitPos, mw_melonTeam)) then return end
		if not (cvars.Bool("mw_admin_allow_free_placing") or MelonWars.noEnemyNear(trace.HitPos, mw_melonTeam)) then return end
		if not (pl.mw_credits >= cost or not cvars.Bool("mw_admin_credit_cost")) then return end

		if (cvars.Number("mw_admin_spawn_time") == 1) then
			if (pl.mw_spawntime < CurTime()) then
				pl.mw_spawntime = CurTime() + MelonWars.baseProps[prop_index].spawn_time
			else
				pl.mw_spawntime = pl.mw_spawntime + MelonWars.baseProps[prop_index].spawn_time
			end
		end
		net.Start("MW_SpawnProp")
			net.WriteInt(prop_index, 16)
			net.WriteTable(trace)
			net.WriteInt(cost, 16)
			net.WriteInt(mw_melonTeam, 8)
			net.WriteInt(pl.mw_spawntime * cvars.Number("mw_admin_spawn_time"), 16)
			net.WriteAngle(pl.propAngle)
		net.SendToServer()
		if (cvars.Bool("mw_admin_credit_cost")) then
			self:IndicateIncome(-cost)
			pl.mw_credits = pl.mw_credits-cost
		end

		net.Start("MW_UpdateServerInfo")
			net.WriteInt(mw_melonTeam ,8)
			net.WriteInt(pl.mw_credits ,32)
		net.SendToServer()
	elseif action == 4 then  --Contraption Save
		if (CLIENT) then
			net.Start("ContraptionSave")
				net.WriteString(pl.contraption_name)
				net.WriteEntity(pl:GetEyeTrace().Entity)
			net.SendToServer()
		end
		self:GetOwner():ConCommand("mw_action 0")
	-- elseif (action == 5) then  --Sell Tool
	elseif action == 6 then  --Contraption Load
		local text = file.Read(pl.selectedFile)
		local compressed_text = util.Compress( text )
		if not compressed_text then compressed_text = text end
		local len = string.len( compressed_text )
		local send_size = 60000
		local parts = math.ceil( len / send_size )
		local start = 0
		net.Start( "BeginContraptionLoad" )
			net.WriteEntity(pl)
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
	elseif action == 7 then
		net.Start("SpawnBaseGrandWar")
			net.WriteTable(trace)
			net.WriteInt(mw_melonTeam, 8)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif action == 25 then
		net.Start("SpawnBaseUnit")
			net.WriteTable(trace)
			net.WriteInt(mw_melonTeam, 8)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif action == 945 then
		if pl:GetInfo( "mw_code" ) == ( "about" or "ABOUT" ) then
			local targetUnit = self:GetOwner():GetEyeTrace().Entity
			if targetUnit == nil then return end
			if targetUnit.Base ~= "ent_melon_base" then return end
			net.Start( "MW_ServerControlUnit" )
				net.WriteEntity( targetUnit )
			net.SendToServer()
		end
	end
end

function TOOL.BuildCPanel( CPanel )
	if not CLIENT then return end
	CPanel:AddControl("Label", { Text = "Reload to open the menu" })
end

local function MW_UpdateGhostEntity(model, pos, offset, angle, newColor, ghostSphereRange, ghostSpherePos)
	if not CLIENT then return end
	local locPly = LocalPlayer()

	newColor = newColor or Color(100,100,100)

	local ghostEntity = locPly.GhostEntity
	if not IsValid( ghostEntity ) then
		ghostEntity = ents.CreateClientProp( model )
		ghostEntity:SetSolid( SOLID_VPHYSICS )
		ghostEntity:SetMoveType( MOVETYPE_NONE )
		ghostEntity:SetNotSolid( true )
		ghostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
		ghostEntity:SetRenderFX( kRenderFxPulseFast )
		ghostEntity:SetMaterial( "models/debug/debugwhite" )
		ghostEntity:SetColor( Color( newColor.r * 1.5, newColor.g * 1.5, newColor.b * 1.5, 150 ) )
		ghostEntity:SetModel( model )
		ghostEntity:SetPos( pos + offset )
		ghostEntity:SetAngles( angle )
		ghostEntity:Spawn()
		locPly.GhostEntity = ghostEntity
	else
		ghostEntity:SetModel( model )
		ghostEntity:SetPos( pos + offset )
		ghostEntity:SetAngles( angle )

		local obbmins = ghostEntity:OBBMins()
		local obbmaxs = ghostEntity:OBBMaxs()
		obbmins:Rotate( angle )
		obbmaxs:Rotate( angle )

		local gEntPos = ghostEntity:GetPos()
		local mins = Vector( gEntPos.x + obbmins.x, gEntPos.y + obbmins.y, pos.z + 5 )
		local maxs = Vector( gEntPos.x + obbmaxs.x, gEntPos.y + obbmaxs.y, pos.z + 20 )
		local overlappingEntities = ents.FindInBox( mins, maxs )

		locPly.canPlace = true
		if locPly.mw_action == 1 and not MelonWars.units[locPly:GetInfoNum( "mw_chosen_unit", 0 )].canOverlap then
			for _, v in ipairs( overlappingEntities ) do
				if v.Base ~= nil and string.StartWith( v.Base, "ent_melon_" ) then
					locPly.canPlace = false
					break
				end
			end
		end
		if locPly.canPlace then
			ghostEntity:SetColor( Color(newColor.r, newColor.g, newColor.b, 150 ))
			ghostEntity:SetRenderFX( kRenderFxPulseSlow )
		else
			ghostEntity:SetColor( Color(150, 0, 0, 150 ))
			ghostEntity:SetRenderFX( kRenderFxDistort )
		end
	end

	local ghostSphere = locPly.GhostSphere
	if not IsValid( ghostSphere ) then
		if locPly.mw_action == 1 and ghostSphereRange > 0 then
			ghostSphere = ents.CreateClientProp( "models/hunter/tubes/circle2x2.mdl" )
			ghostSphere:SetSolid( SOLID_VPHYSICS )
			ghostSphere:SetMoveType( MOVETYPE_NONE )
			ghostSphere:SetNotSolid( true )
			ghostSphere:SetRenderMode( RENDERMODE_TRANSALPHA )
			ghostSphere:SetRenderFX( kRenderFxPulseSlow )
			ghostSphere:SetMaterial("models/debug/debugwhite")
			ghostSphere:SetColor( Color( newColor.r * 1.5, newColor.g * 1.5, newColor.b * 1.5, 50 ) )
			ghostSphere:SetModelScale( 0.021 * ghostSphereRange )
			ghostSphere:Spawn()
			ghostSphere:SetPos( Vector(pos.x, pos.y, ghostSpherePos.z ) )
			locPly.GhostSphere = ghostSphere
		end
	else
		if locPly.mw_action == 1 and ghostSphereRange > 0 then
			local color = ghostSphere:GetColor()
			ghostSphere:SetColor( Color(color.r, color.g, color.b, 50) )
			ghostSphere:SetPos( Vector(pos.x, pos.y, ghostSpherePos.z ) )
			ghostSphere:SetModelScale( 0.021 * ghostSphereRange )
		else
			ghostSphere:Remove()
		end
	end
end

function TOOL:Think()
	if not CLIENT then return end

	local ply = LocalPlayer()
	local plyTbl = ply:GetTable()
	local trace = ply:GetEyeTrace()
	local vector = trace.HitPos - ply:GetPos()

	if plyTbl.mw_selecting and self:MW_SelectionThink() then
		return
	end

	self.canPlace = self.canPlace or false

	if plyTbl.mw_action == 1 then
		plyTbl.propAngle = Vector( vector.x, vector.y, 0 ):Angle()
		if ply:GetInfoNum( "mw_chosen_unit", 0 ) ~= 0 then
			local unit = MelonWars.units[ply:GetInfoNum( "mw_chosen_unit", 0 )]
			if unit and unit.angleSnap then
				plyTbl.propAngle = Angle( plyTbl.propAngle.p, 180+math.Round(plyTbl.propAngle.y / 90) * 90, plyTbl.propAngle.r )
			end
		end
	elseif cvars.Number("mw_prop_snap") == 1 then
		plyTbl.propAngle = Vector( vector.x, vector.y, 0 ):Angle()
		plyTbl.propAngle = Angle( plyTbl.propAngle.p, math.Round(plyTbl.propAngle.y / 45) * 45, plyTbl.propAngle.r )
	else
		plyTbl.propAngle = Vector( vector.x, vector.y, 0 ):Angle()
	end

	local newTeam = mw_team_cv:GetInt() --cvars.Number( "mw_team" )

	if not plyTbl.disableKeyboard then
		if input.IsKeyDown( KEY_R ) then
			if self.rPressed == nil then
				self.rPressed = false
			end
			if not self.rPressed then
				self.rPressed = true
				if plyTbl.mw_frame ~= nil then
					plyTbl.mw_frame:Remove()
					plyTbl.mw_frame = nil
				end
			end
		else
			self.rPressed = false
		end

		if plyTbl.mw_action == 0 then
			if input.IsKeyDown( KEY_E ) then --TODO: Do we need ePressed? it might make more sense to just use locPly:KeyPressed
				self.ePresed = self.ePressed or false
				if not self.ePressed then
					self.ePressed = true
					local tr = ply:GetEyeTrace() --TODO: We already do a trace in this function.
					local correctTeam = (tr.Entity:GetNWInt("mw_melonTeam", 0) == newTeam or tr.Entity:GetNWInt("capTeam", 0) == newTeam or cvars.Bool("mw_admin_move_any_team", false))

					--TODO: Shouldn't be hardcoded.
					local canActivate = {
						["ent_melon_gate"] = true,
						["ent_melon_energy_switch"] = true,
						["ent_melon_unit_transport"] = true,
						["ent_melon_energy_steam_plant"] = true,
						["ent_melon_energy_nuclear_plant"] = true,
						["ent_melon_energy_water_pump"] = true,
						["ent_melon_longboy"] = true,
						["ent_melon_unit_launcher"] = true,
						["ent_melon_powerupgrader"] = true
					}

					local entClass = tr.Entity:GetClass()

					if canActivate[entClass] then
						net.Start("MW_Activate")
							net.WriteEntity(tr.Entity)
							net.WriteInt(newTeam,8) --TODO: UInt 4 bit
						net.SendToServer()
					elseif string.StartsWith( entClass, "ent_melon_barracks") or entClass == "ent_melon_overclocker" then
						net.Start("ToggleBarracks") --TODO: This could probably be rewritten to just use activate
							net.WriteEntity(tr.Entity)
							net.WriteInt(newTeam,8)
						net.SendToServer()
					elseif entClass == "ent_melon_propeller" or entClass == "ent_melon_hover" then
						net.Start("PropellerReady") --TODO: This could probably be rewritten to just use activate
							net.WriteEntity(tr.Entity)
							net.WriteInt(newTeam,8)
						net.SendToServer()
					elseif entClass == "ent_melon_water_tank" then
						net.Start("MW_UseWaterTank") --TODO: This could probably be rewritten to just use activate
							net.WriteEntity(tr.Entity)
							net.WriteInt(newTeam,8)
						net.SendToServer()
					elseif entClass == "ent_melon_contraption_assembler" and correctTeam then --TODO: Team checks here unreliable.
						plyTbl.selectedAssembler = tr.Entity
						self:MakeContraptionMenu()
					end
				end
			else
				self.ePressed = false
			end
		end
	end

	local newColor
	if (newTeam ~= 0) then
		newColor = MelonWars.teamColors[newTeam]
	else
		newColor = Color(100,100,100,255)
	end
	plyTbl.mw_hudColor = newColor

	if (plyTbl.mw_action == 5) then
		if not input.IsMouseDown( MOUSE_LEFT ) then
			plyTbl.mw_sell = 0
		else
			plyTbl.mw_sell = plyTbl.mw_sell + 1 / 100
			if (plyTbl.mw_sell > 1) then
				if (trace.Entity:GetNWInt("mw_melonTeam") == newTeam) then
					net.Start("SellEntity")
						net.WriteEntity(trace.Entity)
						net.WriteInt(mw_team_cv:GetInt(), 4)  --cvars.Number("mw_team"), 4)
					net.SendToServer()
				end
				plyTbl.mw_sell = 0
			end
		end
	end

	if (input.IsKeyDown( KEY_LCONTROL )) then
		self.ctrlPressed = self.ctrlPressed or false
		if not self.ctrlPressed then
			self.ctrlPressed = true

			if (istable(plyTbl.foundMelons)) then
			local count = table.Count(plyTbl.foundMelons)
			if (count > 0) then
				net.Start("MW_Stop")
					for k, v in pairs(plyTbl.foundMelons) do
						net.WriteEntity(v)
					end
				net.SendToServer()
				end
			end
		end
	else
		self.ctrlPressed = false
	end

	plyTbl.mw_spawnTimer = plyTbl.mw_spawnTimer or CurTime()
	plyTbl.mw_selectTimer = plyTbl.mw_selectTimer or CurTime()
	plyTbl.mw_cooldown = plyTbl.mw_cooldown or CurTime()
	plyTbl.mw_units = plyTbl.mw_units or 0
	plyTbl.mw_credits = plyTbl.mw_credits or 0
	plyTbl.mw_sell = plyTbl.mw_sell or 0
	plyTbl.mw_spawntime = plyTbl.mw_spawntime or CurTime()

	if (plyTbl.mw_action == 1) then
		local newColor = MelonWars.teamColors[ply:GetInfoNum("mw_team", 0)]
		local unit_index = ply:GetInfoNum("mw_chosen_unit", 0)
		if unit_index > 0 and MelonWars.units[unit_index].offset ~= nil then
			local offset = MelonWars.units[unit_index].offset
			local xoffset = Vector(offset.x * (math.cos(plyTbl.propAngle.y / 180 * math.pi)), offset.x * (math.sin(plyTbl.propAngle.y / 180 * math.pi)),0)
			local yoffset = Vector(offset.y * (-math.sin(plyTbl.propAngle.y / 180 * math.pi)), offset.y * (math.cos(plyTbl.propAngle.y / 180 * math.pi)),0)
			offset = xoffset + yoffset + Vector(0,0,offset.z)
			local ang = plyTbl.propAngle + MelonWars.units[unit_index].angle
			if (MelonWars.units[unit_index].normalAngle) then
				ang = trace.HitNormal:Angle() + MelonWars.units[unit_index].angle
			end

			MW_UpdateGhostEntity(MelonWars.units[unit_index].model, trace.HitPos, trace.HitNormal * 5+offset, ang, newColor, MelonWars.units[unit_index].energyRange, trace.HitPos)
		end
	elseif (plyTbl.mw_action == 3) then
		local newColor = MelonWars.teamColors[ply:GetInfoNum("mw_team", 0)]
		local prop_index = ply:GetInfoNum("mw_chosen_prop", 0)
		local offset
		if (cvars.Bool("mw_prop_offset") == true) then
			offset = MelonWars.baseProps[prop_index].offset
			local xoffset = Vector(offset.x * (math.cos(plyTbl.propAngle.y / 180 * math.pi)), offset.x * (math.sin(plyTbl.propAngle.y / 180 * math.pi)),0)
			local yoffset = Vector(offset.y * (-math.sin(plyTbl.propAngle.y / 180 * math.pi)), offset.y * (math.cos(plyTbl.propAngle.y / 180 * math.pi)),0)
			offset = xoffset + yoffset + Vector(0,0,offset.z)
		else
			offset = Vector(0,0,MelonWars.baseProps[prop_index].offset.z)
		end
		MW_UpdateGhostEntity (MelonWars.baseProps[prop_index].model, ply:GetEyeTrace().HitPos, Vector(0,0,1) + offset, plyTbl.propAngle + MelonWars.baseProps[prop_index].angle, newColor, 0, trace.HitPos, MelonWars.units[prop_index].defenseRange)
	else
		if IsValid(plyTbl.GhostEntity) then
			plyTbl.GhostEntity:Remove()
		end
		if IsValid(plyTbl.GhostSphere) then
			plyTbl.GhostSphere:Remove()
		end
	end
end

function TOOL:IndicateIncome(amount)
	local indicator = incomeIndicators[currentIncomeIndicator]
	currentIncomeIndicator = (currentIncomeIndicator+1)%(#incomeIndicators) + 1
	indicator.time = CurTime()
	indicator.value = amount
end

function TOOL:MenuButton( pl, y, h, text, number )
	local button = vgui.Create( "DButton", pl.mw_frame )
	button:SetSize( 100, h )
	button:SetPos( 10, y )
	button:SetText( text )
	button:SetFont( "CloseCaption_Normal" )
	function button:DoClick()
		pl.panel:Remove()
		pl.mw_menu = number
		_CreatePanel()
	end
end

function TOOL:Reload()
	if not CLIENT then return end
	local pl = LocalPlayer()
	if pl.mw_frame ~= nil then return end
	--	CREATE FRAME
	pl.mw_frame = vgui.Create("DFrame")
	pl.mw_frame:SetSize(w, h)
	pl.mw_frame:SetPos(ScrW() / 2 - w / 2 + 150, ScrH() / 2 - h / 3)
	pl.mw_frame:SetTitle("Melon Wars")
	pl.mw_frame:MakePopup()
	pl.mw_frame:ShowCloseButton()
	local button = vgui.Create("DButton", pl.mw_frame)
	button:SetSize(90, 18)
	button:SetPos(w - 93, 3)
	button:SetText("Press R to close")
	function button:DoClick()
		pl.mw_frame:Remove()
		pl.mw_frame = nil
	end

	_CreatePanel()

	local h = 70
	self:MenuButton(pl, 30 + h * 0, h, "Units", 0)
	self:MenuButton(pl, 30 + h * 1, h, "Buildings", 1)
	self:MenuButton(pl, 30 + h * 2, h, "Base", 2)
	self:MenuButton(pl, 30 + h * 3, h, "Energy", 3)
	self:MenuButton(pl, 30 + h * 4, h, "Contrap.", 4)

	self:MenuButton(pl, 390, 25, "Help", 6)
	self:MenuButton(pl, 415, 25, "Team", 5)
	self:MenuButton(pl, 440, 25, "Admin", 7)
	self:MenuButton(pl, 470, 25, "Player", 8)
end

local toolScreenTextCol =  Color( 200, 200, 200 )
function TOOL:DrawToolScreen( width, height )

	-- Draw black background
	surface.SetDrawColor( 20, 20, 20 )
	surface.DrawRect( 0, 0, width, height )

	-- Draw white text in middle
	local action = mw_action_cv:GetInt() --LocalPlayer():GetInfoNum( "mw_action", 0 )
	local textStrings = {"Selecting Units", "Spawning Units", "Spawning Base", "Spawning Prop", "Contraptions"}
	textStrings[944] = "Click on a Unit"

	local txtStr = textStrings[action + 1] or "Unknown Action"

	draw.SimpleText( txtStr, "DermaLarge", width / 2, height / 2, toolScreenTextCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function TOOL:Deploy()
	local owner = self:GetOwner()

	self.pressed = false
	self.rPressed = false
	self.disableKeyboard = false
	self.ctrlPressed = false
	self.canPlace = true
	local _team = owner:GetInfoNum( "mw_team", 0 )
	if not SERVER then return end
	if _team ~= 0 then
		net.Start( "MW_TeamCredits" )
			net.WriteInt( MelonWars.teamCredits[_team], 32 )
		net.Send( owner )

		net.Start( "MW_TeamUnits" )
			net.WriteInt( MelonWars.teamUnits[_team], 16 )
		net.Send( owner )
	end
	owner:PrintMessage( HUD_PRINTCENTER, "Press R to open the menu" )
end

function TOOL:Holster()
	if IsValid( self.GhostEntity ) then
		self.GhostEntity:Remove()
	end
	if IsValid( self.GhostSphere ) then
		self.GhostSphere:Remove()
	end
end

function TOOL:RightClick( tr )
	local owner = self:GetOwner()
	if IsValid( owner.controllingUnit ) then
		owner.controllingUnit = nil
	end

	if not CLIENT then return end

	local locPly = LocalPlayer()
	if locPly.mw_cooldown >= ( CurTime() - 0.05 ) then return end

	if cvars.Number( "mw_chosen_unit" ) == 0 then
		if istable( locPly.foundMelons ) then
			net.Start( "MW_Order" )
				net.WriteBool( locPly:KeyDown(IN_SPEED) )
				net.WriteBool( locPly:KeyDown(IN_WALK) )
				for _, v in pairs( locPly.foundMelons ) do
					if not v:IsWorld() and v:IsValid() and v ~= nil then
						net.WriteEntity( v )
					end
				end
			net.SendToServer()
		end
	else
		owner:ConCommand( "mw_chosen_unit 0" ) -- Stop spawning
	end

	locPly:ConCommand("mw_action 0")
	locPly.mw_cooldown = CurTime()
end

function TOOL:DrawHUD() --TODO: Refactor. This needs to be split up/reorganized at least a little bit, since it's a giant 400 line function
	if game.SinglePlayer() then
		local w = 550
		local h = 320
		local x = ScrW() / 2 - w / 2
		local y = ScrH() / 2 - h / 2

		draw.RoundedBox( 15, x, y, w, h, Color(255, 80 + 80 * math.sin( CurTime() * 3 ), 0, 255) )
		draw.RoundedBox( 10, x + 10, y + 10, w - 20, h - 20, Color( 0, 0, 0, 150 ) )
		draw.DrawText( "I'm sorry, but this tool does not work in\nsingleplayer. Please start a 2 player game\nif you want to use this addon on your own.\n\n" ..
			"You'll have more fun if you play with\nsomeone. Join the MelonWars:RTS Steam\ngroup to find MelonWars players!", "DermaLarge", x + w / 2, y + 30, color_white, TEXT_ALIGN_CENTER )
		draw.DrawText( "https:--steamcommunity.com/groups/melonwarsrts", "Trebuchet24", x + w / 2, y + 270, color_white, TEXT_ALIGN_CENTER )
		return
	end

	-- Starting to draw multiplayer menu

	local pl = LocalPlayer()
	local w = 300
	-- local h = 280
	local x = ScrW() - w
	local y = ScrH()

	local mx = gui.MouseX() or 0
	if (mx == 0) then mx = ScrW() / 2 end
	local my = gui.MouseY() or 0
	if (my == 0) then my = ScrH() / 2 end

	if not mw_admin_playing_cv:GetBool() then
		surface.SetFont("DermaLarge")
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( mx-50, my-17 )
		surface.DrawText( "PAUSED" )
		draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-140, color_white, TEXT_ALIGN_RIGHT )
	else
		local pos = 1
		local teamColor = mw_team_cv:GetInt()
		local size = 50
		for i = 1, 8 do
			if (MelonWars.teamGrid[i][teamColor] == true) then
				draw.RoundedBox( 0, x-pos*size, y-size, size, size, Color(20,20,20,255) )
				draw.RoundedBox( 5, x + 4-pos*size, y + 4-size, size-8, size-8, MelonWars.teamColors[i] )
				pos = pos + 1
			end
		end
		if (pos > 1) then
			draw.RoundedBox( 0, x-80, y-size-35, 80, 35, Color(20,20,20,255) )
			draw.DrawText( "Allies:", "DermaLarge", x-40, y-size-32, color_white, TEXT_ALIGN_CENTER )
		end

		pl.mw_action = mw_action_cv:GetInt()

		local unit_id = cvars.Number("mw_chosen_unit")

		if (math.floor(pl.mw_spawntime - CurTime()) > 0) then
			draw.DrawText( "Spawning Queue: " .. math.floor(pl.mw_spawntime-CurTime()), "DermaLarge", ScrW() / 2, ScrH() - 80, color_white, TEXT_ALIGN_CENTER )
		end

		local cheats = false
		local cheatsOffset = 500
		local freeunits = not cvars.Bool("mw_admin_credit_cost")
		if (freeunits) then
			cheats = true
			draw.DrawText( "> Infinite Water", "DermaLarge", 10, ScrH() - cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
			cheatsOffset = cheatsOffset + 40
		end

		local freeplacing = cvars.Bool("mw_admin_allow_free_placing")
		if (freeplacing) then
			cheats = true
			draw.DrawText( "> Build anywhere", "DermaLarge", 10, ScrH() - cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
			cheatsOffset = cheatsOffset + 40
		end

		local controlany = cvars.Bool("mw_admin_move_any_team")
		if (controlany) then
			cheats = true
			draw.DrawText( "> Control any team", "DermaLarge", 10, ScrH() - cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
			cheatsOffset = cheatsOffset + 40
		end

		local instantspawn = not cvars.Bool("mw_admin_spawn_time")
		if (instantspawn) then
			cheats = true
			draw.DrawText( "> Instant spawn", "DermaLarge", 10, ScrH() - cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
			cheatsOffset = cheatsOffset + 40
		end

		local immortality = cvars.Bool("mw_admin_immortality")
		if (immortality) then
			cheats = true
			draw.DrawText( "> Immortal units", "DermaLarge", 10, ScrH() - cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
			cheatsOffset = cheatsOffset + 40
		end

		if (cheats) then
			cheatsOffset = cheatsOffset + 20
			draw.DrawText( "Go to the admin menu to set these\noptions, or press the start game button\nto start a game and turn off cheats", "Trebuchet18", 10, ScrH() - cheatsOffset, Color( 255, 255, 255, 100 ), TEXT_ALIGN_LEFT )
			cheatsOffset = cheatsOffset + 30
			draw.DrawText( "Current Cheats:", "DermaLarge", 10, ScrH() - cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
		end

		if (pl.mw_action == 2) then --spawning main building
			local w = 300
			-- local h = 280
			local x = ScrW() - w
			local y = ScrH()

			draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-140, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "LMB: Spawn Main Building", "DermaLarge", x + w-10, y-100, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "RMB: Cancel", "DermaLarge", x + w-10, y-60, color_white, TEXT_ALIGN_RIGHT )
		elseif (pl.mw_action == 1) then --spawning
			local teamColor = Color(100,100,100,255)
			local mwTeam = mw_team_cv:GetInt()
			if mwTeam ~= 0 then
				teamColor = MelonWars.teamColors[mwTeam]
			end
			if (unit_id > 0) then
				local w = 300
				local h = 280
				local x = ScrW() - w
				local y = ScrH() - h

				draw.RoundedBox( 15, x, y, w, h, teamColor )
				draw.RoundedBox( 10, x + 10, y + 10, w-20, h-20, Color(0,0,0,230) )
				draw.DrawText( MelonWars.units[unit_id].name, "DermaLarge", x + w / 2, y + 30, color_white, TEXT_ALIGN_CENTER )
				for i = 1, MelonWars.units[unit_id].population do
					draw.RoundedBox( 1, x + w / 2-(MelonWars.units[unit_id].population+1) / 2*15+i*15-7, y + 65, 10, 10, color_white )
				end
				if (freeunits) then
					draw.DrawText( "- Infinite Water -", "Trebuchet18", x + w / 2, y + 120, color_white, TEXT_ALIGN_CENTER )
					draw.DrawText( "To enable water cost go to the admin menu", "Trebuchet18", x + w / 2, y + 140, color_white, TEXT_ALIGN_CENTER )
				else
					draw.DrawText( "Cost: " .. MelonWars.units[unit_id].cost, "DermaLarge", x + 30, y + 90, color_white, TEXT_ALIGN_LEFT )
					if (MelonWars.units[unit_id].welded_cost ~= -1) then
						draw.DrawText( "Welded Cost (RMB): " .. MelonWars.units[unit_id].welded_cost, "Trebuchet18", x + 30, y + 130, color_white, TEXT_ALIGN_LEFT )
					end
					draw.DrawText( "Water: " .. tostring(self:GetOwner().mw_credits), "DermaLarge", x + 30, y + 160, color_white, TEXT_ALIGN_LEFT )
				end
				draw.DrawText( "Power: " .. tostring(self:GetOwner().mw_units) .. " / " .. tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x + 30, y + 200, color_white, TEXT_ALIGN_LEFT )

				draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-120, color_white, TEXT_ALIGN_RIGHT )
				draw.DrawText( "LMB: Spawn", "DermaLarge", x + w-10, y-80, color_white, TEXT_ALIGN_RIGHT )
				draw.DrawText( "RMB: Cancel", "DermaLarge", x + w-10, y-40, color_white, TEXT_ALIGN_RIGHT )

				--if (math.floor(pl.mw_spawntime-CurTime()) > 0) then
				--	draw.DrawText( "Spawning Queue: " .. math.floor(pl.mw_spawntime-CurTime()), "DermaLarge", ScrW() / 2, ScrH() - 80, color_white, TEXT_ALIGN_CENTER )
				--end

				if (cvars.Bool("mw_unit_option_welded") and MelonWars.units[unit_id].welded_cost ~= -1) then
					draw.RoundedBox( 10, mx-100, my + 40, 200, 45, Color(0,0,0,100) )
					draw.DrawText( "Spawning " .. MelonWars.units[unit_id].name, "Trebuchet24", mx, my + 40, Color(255,255,0,255), TEXT_ALIGN_CENTER )
					draw.DrawText( "as turret", "Trebuchet24", mx, my + 60, Color(255,255,0,255), TEXT_ALIGN_CENTER )

					draw.RoundedBox( 2, mx-21, my-3, 17, 5, Color(50,50,50))
					draw.RoundedBox( 2, mx + 4, my-3, 17, 5, Color(50,50,50))
					draw.RoundedBox( 2, mx-4, my-31-math.sin(CurTime() * 3) * 10, 7, 12, Color(50,50,50))
					draw.RoundedBox( 1, mx-20, my-2, 15, 3, teamColor)
					draw.RoundedBox( 1, mx + 5, my-2, 15, 3, teamColor)
					draw.RoundedBox( 1, mx-3, my-30-math.sin(CurTime() * 3) * 10, 5, 10, teamColor)
				else
					draw.RoundedBox( 10, mx-160, my + 40, 320, 25, Color(0,0,0,100) )
					draw.DrawText( "Spawning " .. MelonWars.units[unit_id].name, "Trebuchet24", mx, my + 40, Color(255,255,255,200), TEXT_ALIGN_CENTER )
					local a = math.sin(CurTime() * 3) * 5

					draw.RoundedBox( 2, mx-4, my-23-a, 7, 12, Color(50,50,50))
					draw.RoundedBox( 2, mx-4, my + 12+a, 7, 12, Color(50,50,50))
					draw.RoundedBox( 2, mx-24-a, my-3, 12, 7, Color(50,50,50))
					draw.RoundedBox( 2, mx + 11+a, my-3, 12, 7, Color(50,50,50))

					draw.RoundedBox( 1, mx-3, my-22-a, 5, 10, teamColor)
					draw.RoundedBox( 1, mx-3, my + 13+a, 5, 10, teamColor)
					draw.RoundedBox( 1, mx-23-a, my-2, 10, 5, teamColor)
					draw.RoundedBox( 1, mx + 12+a, my-2, 10, 5, teamColor)
				end
			else
				local name = ""
				draw.RoundedBox( 10, mx-115, my + 40, 230, 45, Color(0,0,0,100) )
				draw.DrawText( "Spawning " .. name, "Trebuchet24", mx, my + 40, Color(255,255,0,255), TEXT_ALIGN_CENTER )

				draw.RoundedBox( 2, mx-21, my-3, 17, 5, Color(50,50,50))
				draw.RoundedBox( 2, mx + 4, my-3, 17, 5, Color(50,50,50))
				draw.RoundedBox( 2, mx-4, my-31-math.sin(CurTime() * 3) * 10, 7, 12, Color(50,50,50))
				draw.RoundedBox( 1, mx-20, my-2, 15, 3, teamColor)
				draw.RoundedBox( 1, mx + 5, my-2, 15, 3, teamColor)
				draw.RoundedBox( 1, mx-3, my-30-math.sin(CurTime() * 3) * 10, 5, 10, teamColor)
			end
		elseif pl.mw_action == 0 then -- pl.mw_selecting
			local teamColor = pl.mw_hudColor -- self:GetOwner().mw_hudColor

			local w = 300
			local h = 150
			local x = ScrW() - w
			local y = ScrH() - h

			draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-235, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "LMB (Hold and drag): Select", "DermaLarge", x + w-10, y-195, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "LMB double click: Select unit type", "CloseCaption_Normal", x + w-10, y-165, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "Hold Shift to add to selection", "CloseCaption_Normal", x + w-10, y-145, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "RMB: Move selected", "DermaLarge", x + w-10, y-115, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "Alt + RMB: force target or follow ally", "CloseCaption_Normal", x + w-10, y-85, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "Shift + RMB: Add waypoint", "CloseCaption_Normal", x + w-10, y-65, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "Left Ctrl: Stop selected units", "CloseCaption_Normal", x + w-10, y-45, color_white, TEXT_ALIGN_RIGHT )
			-- draw.DrawText( "Left Ctrl + RMB: Disperse", "CloseCaption_Normal", x + w-10, y-25, color_white, TEXT_ALIGN_RIGHT )

			draw.RoundedBox( 15, x, y, w, h, teamColor )
			draw.RoundedBox( 10, x + 10, y + 10, w-20, h-20, Color(0,0,0,230) )
			if (freeunits) then
				draw.DrawText( "- Infinite Water -", "Trebuchet18", x + w / 2, y + 20, color_white, TEXT_ALIGN_CENTER )
				draw.DrawText( "To enable water cost go to the admin menu", "Trebuchet18", x + w / 2, y + 40, color_white, TEXT_ALIGN_CENTER )
			else
				draw.DrawText( "Water: " .. tostring(self:GetOwner().mw_credits), "DermaLarge", x + 30, y + 30, color_white, TEXT_ALIGN_LEFT )
			end
			draw.DrawText( "Power: " .. tostring(self:GetOwner().mw_units) .. " / " .. tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x + 30, y + 70, color_white, TEXT_ALIGN_LEFT )
		elseif pl.mw_action == 3 then
			local prop_id = pl:GetInfoNum("mw_chosen_prop", 1) -- changed

			local teamColor = pl.mw_hudColor -- changed
			local w = 300
			local h = 250
			local x = ScrW() - w
			local y = ScrH() - h

			draw.RoundedBox( 15, x, y, w, h, teamColor )
			draw.RoundedBox( 10, x + 10, y + 10, w-20, h-20, Color(0,0,0,230) )
			draw.DrawText( "Base Builder", "DermaLarge", x + w / 2, y + 30, color_white, TEXT_ALIGN_CENTER )
			draw.DrawText( MelonWars.baseProps[prop_id].name, "DermaLarge", x + w-20, y + 70, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "HP: " .. MelonWars.baseProps[prop_id].hp, "DermaLarge", x + 30, y + 100, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( "Cost: " .. MelonWars.baseProps[prop_id].cost, "DermaLarge", x + 30, y + 130, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( "Water: " .. tostring(pl.mw_credits), "DermaLarge", x + 30, y + 180, color_white, TEXT_ALIGN_LEFT ) -- changed
		elseif pl.mw_action == 4 then
			local teamColor = MelonWars.teamColors[mw_team_cv:GetInt()] -- self:GetOwner().mw_hudColor
			local w = 300
			local h = 150
			local x = ScrW() - w
			local y = ScrH() - h

			draw.RoundedBox( 10, mx-125, my + 40, 250, 25, Color(0,0,0,100) )
			draw.DrawText( "Click on your contraption", "Trebuchet24", mx, my + 40, Color(255,255,255,200), TEXT_ALIGN_CENTER )

			draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-140, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "LMB: Save Contraption", "DermaLarge", x + w-10, y-100, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "RMB: Cancel", "DermaLarge", x + w-10, y-60, color_white, TEXT_ALIGN_RIGHT )

			draw.RoundedBox( 15, x, y, w, h, teamColor )
			draw.RoundedBox( 10, x + 10, y + 10, w-20, h-20, Color(0,0,0,230) )
			draw.DrawText( "Water: " .. tostring(pl.mw_credits), "DermaLarge", x + 30, y + 30, color_white, TEXT_ALIGN_LEFT ) -- changed
			draw.DrawText( "Power: " .. tostring(pl.mw_units) .. " / " .. tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x + 30, y + 70, color_white, TEXT_ALIGN_LEFT ) -- changed
		elseif pl.mw_action == 5 then
			local teamColor = MelonWars.teamColors[mw_team_cv:GetInt()] -- pl.mw_hudColor -- changed
			local w = 160
			local h = 30
			local x = ScrW()
			local y = ScrH()

			draw.DrawText( "R: Open menu", "DermaLarge", x-10, y-280, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "Hold LMB: Sell target", "DermaLarge", x-10, y-240, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "RMB: Cancel", "DermaLarge", x-10, y-200, color_white, TEXT_ALIGN_RIGHT )

			draw.RoundedBox( 3, ScrW() / 2-w / 2, ScrH() / 2 + 20, w, h, Color(0,0,0, 200) )
			draw.RoundedBox( 0, ScrW() / 2-w / 2+3, ScrH() / 2+20+3, pl.mw_sell*(w-6), h-6, Color(0,230,0, 200) )
			draw.DrawText( "Hold click to sell", "Trebuchet18", ScrW() / 2, ScrH() / 2+25, color_white, TEXT_ALIGN_CENTER )

			draw.RoundedBox( 15, x-300, y-150, 300, 150, teamColor )
			draw.RoundedBox( 10, x-300+10, y-140, 300-20, 130, Color(0,0,0,230) )
			draw.DrawText( "Water: " .. tostring(pl.mw_credits), "DermaLarge", x-270, y-100, color_white, TEXT_ALIGN_LEFT )
		elseif pl.mw_action == 6 then
			local teamColor = MelonWars.teamColors[mw_team_cv:GetInt()]--pl.mw_hudColor -- changed
			local w = 300
			local h = 150
			local x = ScrW() - w
			local y = ScrH() - h

			draw.RoundedBox( 10, mx-130, my + 40, 260, 25, Color(0,0,0,100) )
			draw.DrawText( "Click to spawn contraption", "Trebuchet24", mx, my + 40, Color(255,255,255,200), TEXT_ALIGN_CENTER )

			draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-140, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "LMB: Load Contraption", "DermaLarge", x + w-10, y-100, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "RMB: Cancel", "DermaLarge", x + w-10, y-60, color_white, TEXT_ALIGN_RIGHT )

			draw.RoundedBox( 15, x, y, w, h, teamColor )
			draw.RoundedBox( 10, x + 10, y + 10, w-20, h-20, Color(0,0,0,230) )
			draw.DrawText( "Water: " .. tostring(pl.mw_credits), "DermaLarge", x + 30, y + 30, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( "Power: " .. tostring(pl.mw_units) .. " / " .. tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x + 30, y + 70, color_white, TEXT_ALIGN_LEFT )
		end

		if (cvars.Bool("mw_income_indicator")) then
			for k, v in pairs(incomeIndicators) do
				local time = CurTime() - v.time
				local text = tostring(v.value)
				local indColor = Color(255,0,0,200-time * 100)
				if (v.value > 0) then
					text = "+" .. text
					indColor = Color(0,255,0,200-time * 100)
				end
				draw.DrawText( text, "DermaLarge", ScrW() - w-time * 40, ScrH() - 150+k*10, indColor, TEXT_ALIGN_RIGHT )
			end
		end

		surface.SetDrawColor(pl.mw_hudColor)

		if (pl.mw_action ~= 16) then
			for i = 0, 3 do
				surface.DrawOutlinedRect( mx-5-i, my-4-i, 9+i*2, 9+i*2 )
			end
			surface.SetDrawColor(color_black)
			surface.DrawOutlinedRect( mx-5+1, my-4+1, 9-1*2, 9-1*2 )
			surface.DrawOutlinedRect( mx-5-4, my-4-4, 9+4*2, 9+4*2 )
		end
	end
end

net.Receive( "UpdateClientTeams", function()
	MelonWars.teamGrid = net.ReadTable()
end )

if CLIENT then
	language.Add( "tool.melon_universal_tool.name", "MelonWars: RTS" )
	language.Add( "tool.melon_universal_tool.desc", "Sandbox strategy game" )
	language.Add( "tool.melon_universal_tool.0", "" )
	language.Add( "tool.melon_universal_tool.reload", "Open menu" )

	language.Add( "tool.melon_universal_tool.left_op0", "Hold and drag to select units" )
	language.Add( "tool.melon_universal_tool.left_double_op0", "Select unit type" )
	language.Add( "tool.melon_universal_tool.left_shift_op0", "Hold Shift to add to selection" )
	language.Add( "tool.melon_universal_tool.right_op0", "Move selected units" )
	language.Add( "tool.melon_universal_tool.right_alt_op0", "Press Alt to force target or follow ally" )
	language.Add( "tool.melon_universal_tool.right_shift_op0", "Add waypoint" )
	language.Add( "tool.melon_universal_tool.right_ctrl_op0", "Stop selected units" )

	language.Add( "tool.melon_universal_tool.left_op2", "Spawn main building" )
	language.Add( "tool.melon_universal_tool.right_op2", "Cancel" )

	language.Add( "undone.melon_universal_tool", "Marine has been undone." )
end