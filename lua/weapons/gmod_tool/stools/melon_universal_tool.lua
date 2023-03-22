TOOL.Category = "MelonWars: RTS"
TOOL.Name = "Player Tool"
TOOL.Command = nil
TOOL.ConfigName = "" -- Setting this means that you do not have to create external configuration files to define the layout of the tool config-hud
--[[
TOOL.Information = {
	{ name = "reload" },

	{ name = "left_op0", op = 0 },
	{ name = "left_double_op0", icon2 = "gui/lmb.png", op = 0 },
	{ name = "left_shift_op0", icon2 = "gui/info.png", op = 0 },
	{ name = "right_op0", op = 0 },
	{ name = "right_alt_op0", icon2 = "gui/info.png", op = 0 },
	{ name = "right_shift_op0", icon2 = "gui/info.png", op = 0 },
	{ name = "right_ctrl_op0", icon2 = "gui/info.png", op = 0 },

	{ name = "left_op2", op = 2 },
	{ name = "right_op2", op = 2 }
}
]]
-- Convars (Start)

CreateClientConVar( "mw_chosen_unit", "1", 0, false )
TOOL.ClientConVar[ "mw_chosen_unit" ] = 1
CreateClientConVar( "mw_unit_option_welded", "0", 0, true )
TOOL.ClientConVar[ "mw_unit_option_welded" ] = 0
CreateClientConVar( "mw_team", "1", 1, true )
TOOL.ClientConVar[ "mw_team" ] = 1
CreateClientConVar( "mw_contraption_name", "default", 0, false )
TOOL.ClientConVar[ "mw_contraption_name" ] = "default"
CreateClientConVar( "mw_water_tank_value", "1000", false, true, "Sets the value of a water tank upon its creation.", 0, 50000 )
TOOL.ClientConVar[ "mw_water_tank_value" ] = 1000

CreateConVar( "mw_enable_skin", "1", FCVAR_ARCHIVE + FCVAR_USERINFO, "Enable or disable your custom skin." )
TOOL.ClientConVar[ "mw_enable_skin" ] = "1"

CreateConVar( "mw_admin_open_permits", "0", 8192 + 128, "Whether or not everyone is allowed to use the admin menu." )
TOOL.ClientConVar[ "mw_admin_spawn_time" ] = 0
CreateConVar( "mw_admin_spawn_time", "0", 8192, "Whether or not units take time before spawning." )
TOOL.ClientConVar[ "mw_admin_spawn_time" ] = 1
CreateConVar( "mw_admin_immortality", "0", 8192, "Whether or not units are immortal. Intended for use in photography." )
TOOL.ClientConVar[ "mw_admin_immortality" ] = 1
CreateConVar( "mw_admin_move_any_team", "1", 8192, "If true, everyone can move any melon." )
TOOL.ClientConVar[ "mw_admin_move_any_team" ] = 1
CreateConVar( "mw_admin_allow_free_placing", "1", 8192, "If true, melons can be spawned anywhere." )
TOOL.ClientConVar[ "mw_admin_allow_free_placing" ] = 1
CreateConVar( "mw_admin_playing", "0", 8192, "If false, players can't play and income stops." )
TOOL.ClientConVar[ "mw_admin_playing" ] = 1
CreateConVar( "mw_admin_base_income", "25", 8192, "Amount of income from main buildings. (x2 for grand base)" )
TOOL.ClientConVar[ "mw_admin_base_income" ] = 25
CreateConVar( "mw_admin_cutscene", "0", 8192, "Used in the singleplayer mode." )
TOOL.ClientConVar[ "mw_admin_cutscene" ] = 0
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

CreateClientConVar( "mw_action", "0", 0, true )
TOOL.ClientConVar[ "mw_action" ] = 0

-- Convars (End)

-- mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
local button_energy_color = Color(255, 255, 80)
local button_barrack_color = Color(200, 255, 255)
local orangeColor = Color( 255, 100, 0, 255 )
local color_white = color_white
local color_black = color_black
-- { UNIT INFO

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

local UnitClass = {}
UnitClass.name = "Marine"
UnitClass.class = "ent_melon_marine"
UnitClass.cost = 50
UnitClass.welded_cost = 20
UnitClass.population = 1
UnitClass.spawn_time = 1
UnitClass.model = "models/props_junk/watermelon01.mdl"
UnitClass.description = "No description set"
UnitClass.offset = Vector(0,0,0)
UnitClass.angle = Angle(0,0,0)
UnitClass.angleSnap = true
UnitClass.normalAngle = false
UnitClass.contraptionPart = false
UnitClass.canOverlap = true
UnitClass.button_color = Color(250,250,250)
UnitClass.energyRange = 0
UnitClass.buildAnywere = false
UnitClass.changeAngles = true
UnitClass.spawnable_on_floor = true

local defaultenergyrange = 200

local function Unit() -- Code is an optional argument.
	local newUnit = table.Copy( UnitClass )
	return newUnit
end

local unitCount = 88
mw_units = {}
local u = nil
for i = 1, unitCount do
	mw_units[i] = Unit()
end

local function BarracksText( number, max )
	return "This is a building that produces a " .. mw_units[number].name .. " every " .. tostring(mw_units[number].spawn_time * 3) .. " seconds, up to " .. max .. " at any given time, at half the price. Select this building and command it to move somewhere to set a rally point for its deployed units. Look at it and press E to toggle it on and off."
end

local i = 0

i = i + 1
u = mw_units[i]
u.name 			= "Marine"
u.class 		= "ent_melon_marine"
u.cost 			= 75
u.welded_cost 	= 20
u.population 	= 1
u.spawn_time 	= 2
u.description 	= [[The basic unit.]]
u.model 		= "models/props_junk/watermelon01.mdl"

i = i + 1
u = mw_units[i]
u.name 			= "Medic"
u.class 		= "ent_melon_medic"
u.cost 			= 180
u.welded_cost 	= 100
u.population 	= 1
u.spawn_time 	= 3
u.description 	= [[The healer of the group, always good to have one around.]]
u.model 		= "models/props_junk/watermelon01.mdl"

i = i + 1
u = mw_units[i]
u.name 			= "Jetpack"
u.class 		= "ent_melon_jetpack"
u.cost 			= 250
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 4
u.description 	= [[These marines take to the skies... but not too high. They hover a few meters above ground, enough to make it over enemy walls.]]
u.model 		= "models/props_junk/watermelon01.mdl"
u.offset 		= Vector(0,0,140)

i = i + 1
u = mw_units[i]
u.name 			= "Bomb"
u.class 		= "ent_melon_bomb"
u.cost 			= 400
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 5
u.description 	= [[Explodes on proximity after 0.3 seconds. Send some cannon fodder in front to keep it alive until it reaches its target. Watch out for friendly fire!]]
u.model 		= "models/props_phx/misc/soccerball.mdl"

i = i + 1
u = mw_units[i]
u.name 			= "Gunner"
u.class 		= "ent_melon_gunner"
u.cost 			= 500
u.welded_cost 	= 150
u.population 	= 2
u.spawn_time 	= 6
u.description 	= [[Equipped with a minigun, this tougher and slower unit will shoot faster the longer it holds down the trigger. It has some spread, so try getting up close.]]
u.model 		= "models/Roller.mdl"

i = i + 1
u = mw_units[i]
u.name 			= "Missiles"
u.class 		= "ent_melon_missiles"
u.cost 			= 500
u.welded_cost 	= 175
u.population 	= 2
u.spawn_time 	= 5
u.description 	= [[This unit launches medium range homing missiles to suppress hoards of weak units. Good for dealing constant group damage.]]
u.model 		= "models/xqm/rails/trackball_1.mdl"

i = i + 1
u = mw_units[i]
u.name 			= "Sniper"
u.class 		= "ent_melon_sniper"
u.cost 			= 800
u.welded_cost 	= 350
u.population 	= 2
u.spawn_time 	= 8
u.description 	= [[Slow shooting but very powerful. Useful for picking off bigger targets. It can't shoot while moving.]]
u.model 		= "models/props_junk/propane_tank001a.mdl"
u.offset 		= Vector(0,0,12)

i = i + 1
u = mw_units[i]
u.name 			= "Hot Shot"
u.class 		= "ent_melon_hotshot"
u.cost 			= 1000
u.welded_cost 	= 750
u.population 	= 2
u.spawn_time 	= 5
u.description 	= [[Shoots a fan of incendiary bullets in a wide spread. Useful against spread out squads, not as effective against clumped up enemies.]]
u.model 		= "models/xqm/afterburner1.mdl"
u.offset 		= Vector(0,0,10)

i = i + 1
u = mw_units[i]
u.name 			= "Mortar"
u.class 		= "ent_melon_mortar"
u.cost 			= 3000
u.welded_cost 	= 1500
u.population 	= 3
u.spawn_time 	= 40
u.description 	= [[Very durable. Launches bombs in an arc. Useful for eliminating enemies behind walls. It can't shoot while moving nor at point-blank.]]
u.model 		= "models/props_borealis/bluebarrel001.mdl"
u.offset 		= Vector(0,0,20)

i = i + 1
u = mw_units[i]
u.name 			= "Nuke"
u.class 		= "ent_melon_nuke"
u.cost 			= 3000
u.welded_cost 	= -1
u.population 	= 4
u.spawn_time 	= 30
u.description 	= [[Goes BOOM like a baus. Protect it until it gets to the enemy walls, because it doesn't explode as big if it gets killed before detonation. Takes 1.5 seconds to detonate.]]
u.model 		= "models/props_phx/cannonball.mdl"
u.offset 		= Vector(0,0,20)

i = i + 1
u = mw_units[i]
u.name 			= "Cannon"
u.class 		= "ent_melon_cannon"
u.cost 			= 7000
u.welded_cost 	= 5000
u.population 	= 5
u.spawn_time 	= 20
u.description 	= [[Fires a long range fast cannon ball that deals high (yet inconsistent) damage on impact, going through anything not strong enough to stop it. It can't fire while moving. Its shots can collapse defenses.]]
u.model 		= "models/props_c17/oildrum001.mdl"
u.offset 		= Vector(0,0,0)
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Voidling"
u.class 		= "ent_melon_voidling"
u.cost 			= 20
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 1 / 3
u.description 	= [[A little entity of Void that seeks equilibrium. It will throw itself at enemies to deal damage and die in the process. When sacrificing a voidling to a shredder, you gain a small Water profit.]]
u.model 		= "models/hunter/misc/sphere025x025.mdl"
u.code 			= "--banned--"

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Raider"
u.class 		= "ent_melon_void_raider"
u.cost 			= 300
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 5
u.angle 		= Angle(0, 0, 180)
u.offset 		= Vector(0,0,7)
u.description 	= [[A backpack-wearing void unit that can capture enemy buildings of all sorts. Useful for causing chaos in enemy defensive lines or taking over valuable infrastructure.]]
u.model 		= "models/props_junk/MetalBucket01a.mdl"

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Buck"
u.class 		= "ent_melon_buck"
u.cost 			= 500
u.welded_cost 	= 250
u.population 	= 3
u.spawn_time 	= 20
u.offset 		= Vector(0,0,5)
u.description 	= [[A slow trooper that fires a shotgun blast in a tight spread. Useful for clearing hordes of weak enemies.]]
u.model 		= "models/props_junk/plasticbucket001a.mdl"

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Fighter"
u.class 		= "ent_melon_fighter"
u.cost 			= 750
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 20
u.description 	= [[A fast fighter jet that flies high and shoots down. It can't fly forever without landing, though.]]
u.model 		= "models/props_phx/construct/metal_plate1_tri.mdl"


i = i + 1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Gatling"
u.class 		= "ent_melon_gatling"
u.cost 			= 450
u.welded_cost 	= 100
u.population 	= 2
u.spawn_time 	= 5
u.description 	= [[A gunner with an electric motor to spin up its barrels immediately. Shoots slower as it runs out of energy. Will slowly recharge its batteries with a handcrank when idle.]]
u.model 		= "models/Mechanics/gears/gear12x24.mdl"

i = i + 1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Molotov"
u.class 		= "ent_melon_molotov"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 5
u.offset 		= Vector(0,0,10)
u.description 	= [[A bomb that leaves behind a flaming, dangerous area on the floor.]]
u.model 		= "models/props_junk/propanecanister001a.mdl"

i = i + 1
u = mw_units[i]
u.name 			= "Droid"
u.class 		= "ent_melon_droid"
u.cost 			= 300
u.welded_cost 	= 300
u.population 	= 2
u.spawn_time 	= 8
u.offset 		= Vector(0,0,10)
u.description 	= [[A more damaging, tougher Marine that requires energy to fire.]]
u.model 		= "models/props_c17/utilityconnecter006c.mdl"
u.button_color 	= button_energy_color
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.name 			= "Long-boy"
u.class 		= "ent_melon_longboy"
u.cost 			= 8000
u.welded_cost 	= 8000
u.population 	= 5
u.spawn_time 	= 15
u.offset 		= Vector(0,0,0)
u.description 	= [[A very long range superweapon that needs to deploy to attack. It has to be charged with energy and it can be toggled by looking at it and pressing E.]]
u.model 		= "models/props_trainstation/trainstation_ornament001.mdl"
u.button_color 	= button_energy_color

i = i + 1
u = mw_units[i]
u.code 			= "--banned--"
u.name 			= "Forcefield"
u.class 		= "ent_melon_forcefield"
u.cost 			= 0
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 20000
u.offset        = Vector(0,0,42)
u.description 	= [[A forcefield that blocks bullets from the enemy team.]]
u.model 		= "models/hunter/tubes/tube4x4x2to2x2.mdl"


i = i + 1
u = mw_units[i]
u.code = "prot"
u.name 			= "Heavy Flamethrower"
u.class 		= "ent_melon_flamethrower"
u.cost 			= 9000
u.welded_cost 	= 3000
u.population 	= 8
u.spawn_time 	= 35
u.offset        = Vector(0,0,42)
u.description 	= [[Fire.]]
u.model 		= "models/props_citizen_tech/firetrap_propanecanister01a.mdl"
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code = "full"
u.name 			= "EMP Device"
u.class 		= "ent_melon_emp"
u.cost 			= 100
u.welded_cost 	= 1
u.population 	= 2
u.spawn_time 	= 5
u.offset        = Vector(0,0,5)
u.description 	= [[Needs to be charged before it can detonate. Stuns and slows units for 10 seconds, and drains energy from units and buildings. If it detonates near part of an energy grid it'll disable every building in it for 15 seconds, and the part that was hit for 30. The effects stack, so you can use multiple to disable things longer.]]
u.model 		= "models/maxofs2d/hover_classic.mdl"
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "admin"
u.name 			= "Siege Gun"
u.class 		= "ent_melon_siegegun"
u.cost 			= 100
u.welded_cost 	= 1
u.population 	= 2
u.spawn_time 	= 5
u.offset        = Vector(0,0,32)
u.description 	= [[explode.]]
u.model 		= "models/props_trainstation/trashcan_indoor001b.mdl"


i = i + 1
u = mw_units[i]
u.name 			= "Doot"
u.class 		= "ent_melon_doot"
u.cost 			= 25
u.welded_cost 	= 20
u.population 	= 1
u.spawn_time 	= 0.5-- 1
u.description 	= [[Such spoops]]
u.model 		= "models/Gibs/HGIBS.mdl"
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Mammoth"
u.class 		= "ent_melon_void_mammoth"
u.cost 			= 1000
u.welded_cost 	= -1
u.population 	= 3
u.spawn_time 	= 10
u.offset 		= Vector(0,0,10)
u.description 	= [[A big entity of Void, powerful and slow. Has a lot of health, deals extra damage to buildings and captures points quicker.]]
u.model 		= "models/mechanics/wheels/wheel_spike_48.mdl"
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "admin"
u.name 			= "Engineer"
u.class 		= "ent_melon_engineer"
u.cost 			= 300
u.welded_cost 	= 100
u.population 	= 1
u.spawn_time 	= 3
u.angle 		= Angle(90, 0, 0)
u.offset 		= Vector(0,0,10)
u.description 	= [[A heavy, clunky thing that can repair stationary structures.]]
u.model 		= "models/props_wasteland/light_spotlight01_lamp.mdl"


i = i + 1
local firstBuilding = i --------------------------------- First building


u = mw_units[i]
u.name 			= "City Energy Network Connection"
u.code 			= "admin"
u.class 		= "ent_melon_energy_uplink"
u.cost 			= 9
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Swhy3]]
u.model 		= "models/props_lab/teleportbulkeli.mdl"
u.offset 		= Vector(0,0,100)
u.angle 		= Angle(90, -90, 90)

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Refuel Station"
u.class 		= "ent_melon_refuel"
u.cost 			= 500
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 20
u.description 	= [[A ground-station for the refueling of fighters. Essential, provided you have a safe enough place to put it.]]
u.model 		= "models/xqm/jetenginepropellerlarge.mdl"
u.offset 		= Vector(0,0,-2)
u.angle 		= Angle(90, 0, 0)

i = i + 1
u = mw_units[i]
u.name 			= "Turret"
u.class 		= "ent_melon_turret"
u.cost 			= 350
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 10
u.description 	= [[Static defense, a heavy machinegun with good health and firepower]]
u.model 		= "models/combine_turrets/ground_turret.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(180, 180, 0)
u.energyRange		= 500

i = i + 1
u = mw_units[i]
u.name 			= "Shredder"
u.class 		= "ent_melon_shredder"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 5
u.description 	= [[A set of spinning blades, used to recycle melons, get resources back, and sometimes make smoothies. It has low health, so use as defense at your own risk. (It doesn't give credits for friendly free units)]]
u.model 		= "models/props_c17/TrapPropeller_Blade.mdl"
u.offset 		= Vector(0,0,0)

i = i + 1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Electrified Debris"
u.class 		= "ent_melon_teslarods"
u.cost 			= 150
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A haphazard spread of metal rods connected to an underground power source. Due to its design, it is near impossible to dispatch without use of explosives or excessively high temperatures.]]
u.model 		= "models/props_rooftop/antennaclusters01a.mdl"
u.offset 		= Vector(0,0,60)
u.angle 		= Angle(0, 0, 0)

i = i + 1
u = mw_units[i]
u.name 			= "Elevator Pad"
u.class 		= "ent_melon_elevator_pad"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A pad you place on the floor that lifts up anything above it. Useful as an elevator.]]
u.model 		= "models/hunter/tubes/circle2x2.mdl"
u.offset 		= Vector(0,0,-5)

i = i + 1
u = mw_units[i]
u.name 			= "Loading Bay"
u.class 		= "ent_melon_loading_bay"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A pad you place on the floor that loads units on it to the nearest Unit Transport.]]
u.model 		= "models/props_phx/construct/metal_plate2x2.mdl"
u.offset 		= Vector(0,0,-5)

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Teleporter Transmitter"
u.class 		= "ent_melon_teleporter_sender"
u.cost 			= 1000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A void teleportation platform that links to the nearest receiver platform, upon stepping on this platform friendly units will teleport instantly to the linked receiver.]]
u.model 		= "models/props_lab/teleplatform.mdl"
u.offset 		= Vector(0,0,-5)

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Teleporter Receiver"
u.class 		= "ent_melon_teleporter_receiver"
u.cost 			= 250
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 20
u.buildAnywere  = true
u.description 	= [[A void teleportation platform designed to receive incoming units from a transmitter. Does not need to be built near an outpost/HQ, but does require friendly units to be nearby.]]
u.model 		= "models/props_lab/teleplatform.mdl"
u.offset 		= Vector(0,0,-5)


i = i + 1
u = mw_units[i]
u.name 			= "Gate"
u.class 		= "ent_melon_gate"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A gate that can be opened and closed with E.]]
u.model 		= "models/props_phx/construct/metal_plate1x2.mdl"
u.offset 		= Vector(0,0,18.5)
u.angle 		= Angle(90,0,0)

i = i + 1
u = mw_units[i]
u.name 			= "Station"
u.class 		= "ent_melon_station"
u.cost 			= 1250
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 20
u.description 	= [[A makeshift outpost that allows you to build around it.]]
u.model 		= "models/props_rooftop/roof_vent004.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.code			= "admin"

i = i + 1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Energy Siphon"
--[[
if CLIENT then
	if LocalPlayer():SteamID() == "STEAM_0:1:513312519" then
	u.name 			= "Romanian energy thief network"
	end
end
]]
u.class 		= "ent_melon_energy_siphon"
u.cost 			= 1250
u.welded_cost 	= -1
u.population 	= 5
u.spawn_time 	= 10
u.description 	= [[Connects to enemy energy networks and drains their energy whilst adding to yours at a rate of 5e/s per-attached device. Can be built outside of build range provided a friendly unit is nearby.]]
u.model 		= "models/props_c17/substation_stripebox01a.mdl"
u.offset 		= Vector(0,0,60)
u.button_color 	= button_energy_color
u.buildAnywere  = true
u.energyRange	= 750

i = i + 1
u = mw_units[i]
u.name 			= "Large Gate"
u.class 		= "ent_melon_gate_big"
u.cost 			= 500
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A bigger gate that can be opened and closed with E, useful to get a big army or a contraption through. Requires energy to open and close.]]
u.model 		= "models/props_phx/construct/metal_plate2x4.mdl"
u.offset 		= Vector(0,0,42)
u.angle 		= Angle(90,0,0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Tesla Tower"
u.class 		= "ent_melon_tesla_tower"
u.cost 			= 300
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= [[Static defense that consumes energy to zap up to 5 targets at once. Requires energy to fire.]]
u.model 		= "models/props_c17/FurnitureBoiler001a.mdl"
u.offset 		= Vector(0,0,40)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Particle Tower"
u.class 		= "ent_melon_laser_tower"
u.cost 			= 12000
u.welded_cost 	= -1
u.population 	= 5
u.spawn_time 	= 80
u.description 	= [[Static assault weapon that fires a beam of energy at targets resulting in an explosion after a few seconds. (Alt right click on a unit to target it, alt right click on the world to clear targets, will fire until targeted unit is killed)]]
u.model 		= "models/props_wasteland/lighthouse_fresnel_light_base.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Anti-Power Reactor"
u.class 		= "ent_melon_energy_powerupgrader"
u.cost 			= 2000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 60
u.description 	= [[A large void machine that uses energy to generate negative power, reducing the power usage of its team when it's on up to a maximum of -35. Limit of one per team.]]
u.model 		= "models/props_c17/substation_circuitbreaker01a.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Unit Launcher"
u.class 		= "ent_melon_unit_launcher"
u.cost 			= 2500
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 40
u.description 	= [[A large mortar used to fire shells full of melons at your enemies. Aim/fire by giving move orders to the launcher. Can load up to 10 power. Can't be fired too close to enemy buildings.]]
u.model 		= "models/props_citizen_tech/steamengine001a.mdl"
u.offset 		= Vector(0, 0, 100)
u.angle 		= Angle(-90, 0, -90)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "admin"
u.name 			= "Supergun"
u.class 		= "ent_melon_supergun"
u.cost 			= 6500
u.welded_cost 	= -1
u.population 	= 5
u.spawn_time 	= 40
u.description 	= [[Gun.]]
u.model 		= "models/props_citizen_tech/steamengine001a.mdl"
u.offset 		= Vector(0, 0, 100)
u.angle 		= Angle(-90, 0, -90)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.code 			= "admin"
u.name 			= "Melonium Silo"
u.class 		= "ent_melon_supermissile"
u.cost 			= 6500
u.welded_cost 	= -1
u.population 	= 5
u.spawn_time 	= 40
u.description 	= [[Missl.]]
u.model 		= "models/props_citizen_tech/steamengine001a.mdl"
u.offset 		= Vector(0, 0, 100)
u.angle 		= Angle(-90, 0, -90)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.code 			= "--banned--"
u.name 			= "Universal Overclocker"
u.class 		= "ent_melon_energy_superoverclocker"
u.cost 			= 2250
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 60
u.description 	= [[This is broken don't use it.]]
u.model 		= "models/props_c17/substation_circuitbreaker01a.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.code 			= "admin"
u.name 			= "Siege Mortar"
u.class 		= "ent_melon_supermortar"
u.cost 			= 10000
u.welded_cost 	= -1
u.population 	= 5
u.spawn_time 	= 60
u.description 	= [[Big gun.]]
u.model 		= "models/props_citizen_tech/steamengine001a.mdl"
u.offset 		= Vector(0, 0, 100)
u.angle 		= Angle(-90, 0, -90)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Over-Clocker"
u.class 		= "ent_melon_overclocker"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Place it right next to a Barracks of any kind. When it's on, it will consume energy and boost the barrack's production rate. (It will disappear if not placed close enough to a barracks)]]
u.model 		= "models/props_combine/combine_light001a.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Medical Bay"
u.class 		= "ent_melon_medical_bay"
u.cost 			= 600
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= [[This building will slowly heal up to 10 units at a time in a big radius. It requires a lot of energy per target, so area attacks might drain a lot of energy]]
u.model 		= "models/props_phx/wheels/747wheel.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Charging Station"
u.class 		= "ent_melon_charging_station"
u.cost 			= 300
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= [[Provides energy to nearby energy dependant units.]]
u.model 		= "models/props_c17/substation_transformer01d.mdl"
u.offset 		= Vector(0,0,24)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Radar"
u.class 		= "ent_melon_radar"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 5
u.description 	= [[If energized, it will alert your team of nearby units no matter where you are. It passively consumes the power output of 2 solar panels]]
u.model 		= "models/props_trainstation/trainstation_column001.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Forcefield generator"
u.class 		= "ent_melon_forcefield_generator"
u.cost 			= 750
u.welded_cost 	= -1
u.population 	= 3
u.spawn_time 	= 15
u.description 	= [[Generates a forcefield around itself that uses energy to block enemy bullets while letting friendly bullets and all projectiles through. Stops 1 damage for 2 energy.]]
u.model 		= "models/props_c17/substation_transformer01d.mdl"
u.offset 		= Vector(0,0,23.5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Point Defense Station"
u.class 		= "ent_melon_point_defence"
u.cost 			= 750
u.welded_cost 	= -1
u.population 	= 3
u.spawn_time 	= 25
u.description 	= [[A Full defense tower that zaps and destroys incoming projectiles. Consumes 75 energy per projectile destroyed.]]
u.model 		= "models/props_docks/channelmarker02a.mdl"
u.offset 		= Vector(0,0,23.5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Marine Barracks"
u.class 		= "ent_melon_barracks_marine"
u.cost 			= 750
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description   = BarracksText (1, 10)
u.model 		= "models/Items/ammocrate_ar2.mdl"
u.offset 		= Vector(0,0,10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Medic Academy"
u.class 		= "ent_melon_barracks_medic"
u.cost 			= 1000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= BarracksText (2, 5)
u.model 		= "models/props_junk/wood_crate002a.mdl"
u.offset 		= Vector(0,0,10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Jetpack Flight School"
u.class 		= "ent_melon_barracks_jetpack"
u.cost 			= 2000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= BarracksText (3, 5)
u.model 		= "models/props_wasteland/kitchen_stove002a.mdl"
u.offset 		= Vector(0,0,-15)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Bomb Factory"
u.class 		= "ent_melon_barracks_bomb"
u.cost 			= 1800
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= BarracksText (4, 3)
u.model 		= "models/props_wasteland/laundry_basket001.mdl"
u.offset 		= Vector(0,0,10)
u.angle 		= Angle(180,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Gunner Training Camp"
u.class 		= "ent_melon_barracks_gunner"
u.cost 			= 3000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= BarracksText (5, 5)
u.model 		= "models/props_combine/combine_interface002.mdl"
u.offset 		= Vector(0,0,-25)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Missiles Production Line"
u.class 		= "ent_melon_barracks_missiles"
u.cost 			= 3000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 15
u.description 	= BarracksText (6, 4)
u.model 		= "models/props_interiors/VendingMachineSoda01a.mdl"
u.offset 		= Vector(0,0,10)
u.angle 		= Angle(-90,0,90)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Sniper Shooting Range"
u.class 		= "ent_melon_barracks_sniper"
u.cost 			= 3000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 15
u.description 	= BarracksText (7, 3)
u.model 		= "models/props_wasteland/laundry_cart001.mdl"
u.offset 		= Vector(0,0,15)
u.angle 		= Angle(180, 90, 0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Hot Shot Forge"
u.class 		= "ent_melon_barracks_hotshot"
u.cost 			= 4000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 15
u.description 	= BarracksText (8, 3)
u.model 		= "models/props_wasteland/laundry_dryer002.mdl"
u.offset 		= Vector(0,0,30)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Mortar Production Facility"
u.class 		= "ent_melon_barracks_mortar"
u.cost 			= 5000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 15
u.description 	= BarracksText (9, 3)
u.model 		= "models/XQM/CoasterTrack/train_1.mdl"
u.offset 		= Vector(0,0,-25)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Nuke Assembler"
u.class 		= "ent_melon_barracks_nuke"
u.cost 			= 4500
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description 	= BarracksText (10, 1)
u.model 		= "models/props_lab/teleportframe.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color
--[[
i = i + 1
u = mw_units[i]
u.name 			= "Tombstone"
u.class 		= "ent_melon_barracks_doot"
u.cost 			= 300
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= BarracksText (11, 3)
u.model 		= "models/props_c17/gravestone002a.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color
]]
i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Voidling Reactor"
u.class 		= "ent_melon_barracks_voidling"
u.cost 			= 1500
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description   = BarracksText (12, 5)
u.model 		= "models/props_wasteland/laundry_washer001a.mdl"
u.offset 		= Vector(0,0,25)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Raider Fabrication Platform"
u.class 		= "ent_melon_barracks_void_raider"
u.cost 			= 500
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 30
u.description   = BarracksText (13, 3)
u.model 		= "models/props_vehicles/apc_tire001.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(-90,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Mammoth Spawning Vat"
u.class 		= "ent_melon_barracks_void_mammoth"
u.cost 			= 5000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 30
u.description   = BarracksText (13, 3)
u.model 		= "models/props_combine/masterinterface.mdl"
u.offset 		= Vector(0,0,-10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color
u.isBonusUnit   = true

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Buck University"
u.class 		= "ent_melon_barracks_buck"
u.cost 			= 4000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 40
u.description   = BarracksText (14, 5)
u.model 		= "models/hunter/misc/roundthing2.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Fighter University"
u.class 		= "ent_melon_barracks_fighter"
u.cost 			= 4500
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 40
u.description   = BarracksText (15, 4)
u.model 		= "models/phxtended/trieq2x2x2solid.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Gatling Depot"
u.class 		= "ent_melon_barracks_gatling"
u.cost 			= 2000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description   = BarracksText (16, 5)
u.model 		= "models/props_wasteland/kitchen_stove001a.mdl"
u.offset 		= Vector(0,0,-10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Molotov Depot"
u.class 		= "ent_melon_barracks_molotov"
u.cost 			= 900
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description   = BarracksText (17, 3)
u.model 		= "models/props_industrial/oil_storage.mdl"
u.offset 		= Vector(0,0,-10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = mw_units[i]
u.name 			= "Contraption Assembler"
u.class 		= "ent_melon_contraption_assembler"
u.cost 			= 750
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description 	= [[Produces contraptions. Cost and building time is deduced from the cost of the props and units that form the contraption. Press E on it to see a list of your saved contraptions.]]
u.model 		= "models/props_phx/construct/metal_plate4x4.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0,0,0)
u.angleSnap		= true
u.canOverlap 	= false
u.energy 		= true
u.button_color 	= button_barrack_color


i = i + 1
local firstEnergy = i ----------------------------------First energy


u = mw_units[i]
u.name 			= "Relay"
u.class 		= "ent_melon_energy_relay"
u.cost 			= 75
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[This post will transport energy between connections]]
u.model 		= "models/props_docks/dock01_pole01a_128.mdl"
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange
u.buildAnywere  = true

i = i + 1
u = mw_units[i]
u.name 			= "Big Relay"
u.class 		= "ent_melon_energy_relay_large"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[This post will transport energy between way longer connections. Can only connect to other Big Relays or Relays. Can be built anywhere on the map.]]
u.model 		= "models/props_docks/dock01_pole01a_256.mdl"
u.offset 		= Vector(0,0,100)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= 1000
u.buildAnywere  = true

i = i + 1
u = mw_units[i]
u.name 			= "Switch"
u.class 		= "ent_melon_energy_switch"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[Use the switch to connect and disconnect networks]]
u.model 		= "models/props_trainstation/trashcan_indoor001b.mdl"
u.offset 		= Vector(0,0,16)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "S Battery"
u.class 		= "ent_melon_energy_capacitor"
u.cost 			= 350
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[The battery will store up to 500 energy units. Be careful, as it explodes when destroyed! The explosion is more powerful the more charge the battery had at the time.]]
u.model 		= "models/props_phx/wheels/drugster_back.mdl"
u.offset 		= Vector(0,0,-5)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "M Battery"
u.class 		= "ent_melon_energy_capacitor_medium"
u.cost 			= 1000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[The battery will store up to 2000 energy units. Be careful, as it explodes when destroyed! The explosion is more powerful the more charge the battery had at the time.]]
u.model 		= "models/props_phx/wheels/monster_truck.mdl"
u.offset 		= Vector(0,0,-5)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "L Battery"
u.class 		= "ent_melon_energy_capacitor_large"
u.cost 			= 6000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[The battery will store up to 15000 energy units. Be careful, as it explodes when destroyed! The explosion is more powerful the more charge the battery had at the time.]]
u.model 		= "models/props_combine/combine_train02a.mdl"
u.offset 		= Vector(0,0,100)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Solar Panel"
u.class 		= "ent_melon_energy_solar_panel"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 2
u.description 	= [[Solar panels produce 5 energy every 5 seconds]]
u.model 		= "models/props_combine/weaponstripper.mdl"
u.offset 		= Vector(-62.5,0,0)
u.angle 		= Angle(-90,180,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange
u.changeAngles  = false

i = i + 1
u = mw_units[i]
u.name 			= "Steam Generator"
u.class 		= "ent_melon_energy_steam_plant"
u.cost 			= 2250
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Steam generators can be turned on and off using E. When on, they transform 10 Water into 20 Energy per second]]
u.model 		= "models/mechanics/roboticslarge/claw_hub_8l.mdl"
u.offset 		= Vector(0,0,50)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Nuclear Plant"
u.class 		= "ent_melon_energy_nuclear_plant"
u.cost 			= 8000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Nuclear plants can be turned on and off using E. When on, they transform a 25 Water to 100 Energy per second. It blows up big when destroyed]]
u.model 		= "models/props_combine/combine_booth_med01a.mdl"
u.offset 		= Vector(0,0,20)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = mw_units[i]
u.name 			= "Water Pump"
u.class 		= "ent_melon_energy_water_pump"
u.cost 			= 2000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 20
u.description 	= [[Water pumps consume energy to produce water. They use 5 energy to make 5 water every second.]]
u.model 		= "models/props_buildings/watertower_001c.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange


i = i + 1
local firstContraption = i ---------------------------- First Contraption


u = mw_units[i]
u.name 			= "Engine"
u.class 		= "ent_melon_engine"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[Place this while looking in the direction you want 'forward' to be on your contraption. It will be the one to move and direct your vehicle.]]
u.model 		= "models/thrusters/jetpack.mdl"
u.offset 		= Vector(0,0.8,0)
u.angle 		= Angle(90,180,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i + 1
u = mw_units[i]
u.name 			= "Large Engine"
u.class 		= "ent_melon_engine_large"
u.cost 			= 350
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 7
u.description 	= [[Place this while looking in the direction you want 'forward' to be on your contraption. It will be the one to move and direct your vehicle. It has less max speed than the Thruster, but it has more force. Useful for bigger contraptions.]]
u.model 		= "models/props_c17/trappropeller_engine.mdl"
u.offset 		= Vector(0,0.8,0)
u.angle 		= Angle(90,180,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i + 1
u = mw_units[i]
u.name 			= "Propeller"
u.class 		= "ent_melon_propeller"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 7
u.description 	= [[Propellers will keep your contraption a few meters off the ground.]]
u.model 		= "models/maxofs2d/hover_propeller.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i + 1
u = mw_units[i]
u.name 			= "Hover Pad"
u.class 		= "ent_melon_hover"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 4
u.description 	= [[Hover pads will keep your contraption a few centimeters off the ground.]]
u.model 		= "models/props_c17/pulleywheels_small01.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(90,0,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i + 1
u = mw_units[i]
u.name 			= "Wheel"
u.class 		= "ent_melon_wheel"
u.cost 			= 25
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 2
u.description 	= [[Better than sliding on the ground, I'd say. Wheels don't actually produce any force, but they will help your vehicle roll easier. They apply brakes when the vehicle should stop.]]
u.model 		= "models/XQM/airplanewheel1.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.normalAngle   = true
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i + 1
u = mw_units[i]
u.name 			= "Unit Transport"
u.class 		= "ent_melon_unit_transport"
u.cost 			= 150
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[I bet you can fit 10 units in this crate. Press E on it to free the units inside it.]]
u.model 		= "models/props_junk/wood_crate002a.mdl"
u.offset 		= Vector(0,0,10)
u.angle 		= Angle(0,0,0)
u.angleSnap		= false
u.canOverlap 	= false

i = i + 1
u = mw_units[i]
u.name 			= "Capacitor"
u.class 		= "ent_melon_contraption_capacitor"
u.cost 			= 350
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A battery designed for use on contraptions. Supplies welded entities with energy.]]
u.model 		= "models/props_junk/TrashBin01a.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(90,90,90)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false


-- Create a file for contraption validation
local text = util.Compress(util.TableToJSON(mw_units))
file.CreateDir( "melonwars/validation" )
file.Write( "melonwars/validation/unitValues.txt", text )

teamgrid = {
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false}
}

local BasePropClass = {}
BasePropClass.name = "Prop"
BasePropClass.model = "models/hunter/blocks/cube05x1x05.mdl"
BasePropClass.offset = Vector(0,0,0)
BasePropClass.angle = Angle(0,0,0)
BasePropClass.cost = 1
BasePropClass.hp = 1
BasePropClass.spawn_time = 2

local function BaseProp() -- Code is an optional argument.
	local newProp = table.Copy( BasePropClass )
	return newProp
end

local basePropCount = 25
mw_base_props = {}
local u = nil
for i = 1, basePropCount do
	mw_base_props[i] = BaseProp()
end

i = 0

i = i + 1
u = mw_base_props[i]
u.name = "Blast Door"
u.model = "models/props_lab/blastdoor001c.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 200
u.hp = 150

i = i + 1
u = mw_base_props[i]
u.name = "Barricade"
u.model = "models/props_wasteland/barricade002a.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,90,0)
u.cost = 15
u.hp = 40

i = i + 1
u = mw_base_props[i]
u.name = "Fence"
u.model = "models/props_wasteland/wood_fence01a.mdl"
u.offset = Vector(0,0,40)
u.angle = Angle(0,90,0)
u.cost = 40
u.hp = 100

i = i + 1
u = mw_base_props[i]
u.name = "Pallet"
u.model = "models/props_junk/wood_pallet001a.mdl"
u.offset = Vector(0,0,32)
u.angle = Angle(90,0,0)
u.cost = 25
u.hp = 50

i = i + 1
u = mw_base_props[i]
u.name = "Brick"
u.model = "models/hunter/blocks/cube05x1x05.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 35

i = i + 1
u = mw_base_props[i]
u.name = "Half Block"
u.model = "models/hunter/blocks/cube1x1x05.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,0,0)
u.cost = 35
u.hp = 50

i = i + 1
u = mw_base_props[i]
u.name = "Block"
u.model = "models/hunter/blocks/cube1x1x1.mdl"
u.offset = Vector(0,0,24)
u.angle = Angle(0,0,0)
u.cost = 75
u.hp = 100

i = i + 1
u = mw_base_props[i]
u.name = "Half Platform"
u.model = "models/hunter/blocks/cube2x2x05.mdl"
u.offset = Vector(47,0,10.5)
u.angle = Angle(0,0,0)
u.cost = 115
u.hp = 150

i = i + 1
u = mw_base_props[i]
u.name = "Platform"
u.model = "models/hunter/blocks/cube2x2x1.mdl"
u.offset = Vector(47,0,24)
u.angle = Angle(0,0,0)
u.cost = 150
u.hp = 200

i = i + 1
u = mw_base_props[i]
u.name = "Concrete Barrier"
u.model = "models/props_c17/concrete_barrier001a.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 75
u.hp = 150

i = i + 1
u = mw_base_props[i]
u.name = "Wall"
u.model = "models/hunter/blocks/cube2x2x05.mdl"
u.offset = Vector(0,0,48)
u.angle = Angle(90,0,0)
u.cost = 100
u.hp = 175

i = i + 1
u = mw_base_props[i]
u.name = "Long Wall"
u.model = "models/hunter/blocks/cube1x4x05.mdl"
u.offset = Vector(0,0,24)
u.angle = Angle(90,0,0)
u.cost = 100
u.hp = 175

i = i + 1
u = mw_base_props[i]
u.name = "Flat Platform"
u.model = "models/hunter/plates/plate2x2.mdl"
u.offset = Vector(47,0,-2.5)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 35

i = i + 1
u = mw_base_props[i]
u.name = "Short Ramp"
u.model = "models/hunter/plates/plate1x2.mdl"
u.offset = Vector(23,0,4.5)
u.angle = Angle(-17,0,0)
u.cost = 25
u.hp = 25

i = i + 1
u = mw_base_props[i]
u.name = "Slim Half Ramp"
u.model = "models/hunter/plates/plate1x2.mdl"
u.offset = Vector(33,0,7.3)
u.angle = Angle(0,90,-17)
u.cost = 25
u.hp = 25

i = i + 1
u = mw_base_props[i]
u.name = "Half Ramp"
u.model = "models/hunter/plates/plate2x2.mdl"
u.offset = Vector(33,0,7.3)
u.angle = Angle(0,90,-17)
u.cost = 50
u.hp = 40

i = i + 1
u = mw_base_props[i]
u.name = "Slim Full Ramp"
u.model = "models/hunter/triangles/2x1x1.mdl"
u.offset = Vector(48.3,0,23.1)
u.angle = Angle(0,90,0)
u.cost = 75
u.hp = 75

i = i + 1
u = mw_base_props[i]
u.name = "Barrel"
u.model = "models/props_c17/oildrum001.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 25
u.hp = 50

i = i + 1
u = mw_base_props[i]
u.name = "3D Frame"
u.model = "models/props_phx/construct/metal_wire1x2x2b.mdl"
u.offset = Vector(-70,24,0)
u.angle = Angle(0,0,0)
u.cost = 20
u.hp = 20

i = i + 1
u = mw_base_props[i]
u.name = "Railing"
u.model = "models/PHXtended/bar2x.mdl"
u.offset = Vector(2,48,5.5)
u.angle = Angle(90,180,0)
u.cost = 8
u.hp = 5

i = i + 1
u = mw_base_props[i]
u.name = "Half Pipe"
u.model = "models/props_phx/construct/metal_plate_curve180.mdl"
u.offset = Vector(-46,0,48)
u.angle = Angle(180,0,0)
u.cost = 50
u.hp = 75

i = i + 1
u = mw_base_props[i]
u.name = "Pole"
u.model = "models/props_docks/dock01_pole01a_128.mdl"
u.offset = Vector(0,0,64)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 15

i = i + 1
u = mw_base_props[i]
u.name = "Disk"
u.model = "models/props_phx/construct/metal_angle360.mdl"
u.offset = Vector(-48,0,0)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 15

i = i + 1
u = mw_base_props[i]
u.name = "Half Disk"
u.model = "models/props_phx/construct/metal_angle180.mdl"
u.offset = Vector(-48,0,0)
u.angle = Angle(180,0,0)
u.cost = 8
u.hp = 8

i = i + 1
u = mw_base_props[i]
u.name = "Stilt"
u.model = "models/props_docks/dock01_pole01a_128.mdl"
u.offset = Vector(0,0,-64)
u.angle = Angle(0,0,0)
u.cost = 25
u.hp = 25

local w = 700
local h = 500

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

local function DefaultInfo()
	if not CLIENT then return end
	local pl = LocalPlayer()

	pl.info = vgui.Create("DLabel", pl.panel)
	pl.info:SetPos(190, 190)
	pl.info:SetSize(370,200)
	pl.info:SetWrap(true)
	pl.info:SetFontInternal( "Trebuchet24" )
	pl.info:SetText("Hover over a button to see more info about the units")
	pl.mw_hover = 0

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

local function _MakeButton(number, posnumber, parent) -- Make Button
	if not CLIENT then return end
	local pl = LocalPlayer()

	local button = vgui.Create("DButton", parent) -- Unit button
	button:SetSize(120,40)
	button:SetPos( 10, 10 + ( posnumber - 1 ) * 45 )
	button:SetFont("CloseCaption_Normal")
	button:SetText(mw_units[number].name)
	function button:DoClick()
		pl:ConCommand( "mw_chosen_unit " .. tostring( number ) )
		pl:ConCommand( "mw_action 1" )
		pl.mw_frame:Remove()
		pl.mw_frame = nil
	end
	local color = mw_units[number].button_color
	button.Paint = function(s, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color(color.r-40,color.g-40,color.b-40) )
		draw.RoundedBox( 3, 5, 5, w-10, h-10, color )
	end
	function button:OnCursorEntered()
		pl.mw_hover = number
		pl.info:SetText(mw_units[number].description)
		if (cvars.Number("mw_admin_credit_cost") == 1) then
			pl.info_cost:SetText( "Cost: " .. mw_units[number].cost )
			if (mw_units[number].welded_cost == -1) then
				pl.info_turret_cost:SetText("")
			else
				pl.info_turret_cost:SetText( "Turret cost: " .. mw_units[number].welded_cost )
			end
		else
			pl.info_cost:SetText("")
			pl.info_turret_cost:SetText("")
		end
		pl.info_power:SetText( "Power: " .. mw_units[number].population )
		if (cvars.Number("mw_admin_spawn_time") == 1) then
			pl.info_time:SetText( "Spawn time: " .. mw_units[number].spawn_time .. "s" )
		else
			pl.info_time:SetText("")
		end
		pl.info_name:SetText(mw_units[number].name)
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
		if (text2 ~= nil) then info:AppendText(text2) end
		if (text3 ~= nil) then info:AppendText(text3) end
		if (text4 ~= nil) then info:AppendText(text4) end
		if (text5 ~= nil) then info:AppendText(text5) end
		timer.Simple( 0.001, function() info:GotoTextStart() end )

		if name ~= "About" then return end
		if not ( locPly:GetInfo("mw_code") == "about" or locPly:GetInfo("mw_code") == "ABOUT" ) then return end

		chat.AddText( "Well done" )
		locPly:ConCommand("mw_action 945")
	end
end

local function _CreatePanel()
	if not CLIENT then return end
	local pl = LocalPlayer()

	pl.panel = vgui.Create("DPanel", pl.mw_frame)
	pl.panel:SetSize(w-120, h-25)
	pl.panel:SetPos(120,25)
	pl.panel.Paint = function(s, w, h)
		draw.RoundedBox( 4, 0, 0, w, h, Color(30,30,30) )
	end
	if (pl.mw_menu == 0) then																	--units menu
		-- { units MENU
		local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
		scroll:SetSize( 175, h-30)
		scroll:SetPos( 0, 0 )
		local lines = vgui.Create("DPanel", scroll)
		lines:SetSize(w-120, h-30)
		lines:SetPos(0,0)
		lines.Paint = function(s, w, h)
			surface.SetDrawColor( color_white )
			if (pl.mw_hover ~= 0) then
				local a = pl.mw_hover * 45 - 25
				surface.DrawRect( 135, a, 20, 20 )
			end
		end
		local ipos = 1
		for i = 1, firstBuilding-1 do
			if (cvars.Bool("mw_admin_allow_manual_placing") or mw_units[i].welded_cost ~= -1) then
				if ((mw_units[i].code == nil or pl:GetInfo("mw_code") == mw_units[i].code) and (mw_units[i].isBonusUnit ~= true or GetConVar( "mw_admin_bonusunits" ):GetInt() == 1)) then
					_MakeButton(i, ipos, scroll)
					ipos = ipos + 1
				end
			end
		end

		if not cvars.Bool("mw_admin_allow_manual_placing") then
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
				pl.mw_hover = 0
				pl.info_name:SetText("Spawn as turret")
				pl.info_cost:SetText("")
				pl.info_turret_cost:SetText("")
				pl.info_power:SetText("")
				pl.info_time:SetText("")
				pl.info:SetText("If this is checked, you will be able to spawn units welded to where you point at, with a reduced cost. Not all units can be spawned as turret.")
			end
		end

		DefaultInfo()
		-- }
	elseif (pl.mw_menu == 1) then																--Buildings menu
		-- { BUILDINGS MENU
		local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
		scroll:SetSize( 175, h-25)
		scroll:SetPos( 0, 0 )
		local lines = vgui.Create("DPanel", scroll)
		lines:SetSize(w-120, 900)
		lines:SetPos(0,0)
		lines.Paint = function(s, w, h)
			local a = ( pl.mw_hover - firstBuilding + 1 ) * 45 - 18
			surface.SetDrawColor(color_white)
			surface.DrawRect( 135, a-5, 20, 20 )
		end

		local ipos = 1
		for i = firstBuilding, firstEnergy - 1 do
			if (mw_units[i].code == nil or pl:GetInfo("mw_code") == mw_units[i].code) and (mw_units[i].isBonusUnit ~= true or GetConVar( "mw_admin_bonusunits" ):GetInt() == 1) then
				if mw_units[i].name ~= "Contraption Assembler" or cvars.Number("mw_admin_ban_contraptions") == 0 then
					_MakeButton(i, ipos, scroll)
					ipos = ipos + 1
				end
			end
		end

		DefaultInfo()
		-- }
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
		for k, v in pairs(mw_base_props) do
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
		-- { BUILDINGS MENU
		local scroll = vgui.Create( "DScrollPanel", pl.panel ) -- Create the Scroll panel
		scroll:SetSize( 175, h-25)
		scroll:SetPos( 0, 0 )
		local lines = vgui.Create("DPanel", scroll)
		lines:SetSize(w-120, 450)
		lines:SetPos(0,0)
		lines.Paint = function(s, w, h)
			local a = ( pl.mw_hover - firstEnergy + 1 ) * 45 - 18
			surface.SetDrawColor(color_white)
			surface.DrawRect( 135, a - 5, 20, 20 )
		end

		for i = firstEnergy, firstContraption - 1 do
			_MakeButton( i, i - firstEnergy + 1, scroll )
		end

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
		local lines = vgui.Create("DPanel", scroll)
		lines:SetSize(w-120, 550)
		lines:SetPos(0,0)
		lines.Paint = function(s, w, h)
			local a = ( pl.mw_hover - firstContraption + 1 ) * 45 - 18
			surface.SetDrawColor(color_white)
			surface.DrawRect( 135, a - 5, 20, 20 )
		end

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
		if (cvars.Number("mw_team") ~= 0) then
			selection:SetPos( 135 + cvars.Number( "mw_team" ) * 45, 145 )
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
				draw.RoundedBox( 4, 2, 2, w - 4, h - 4, mw_team_colors[i] )
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
			factionSelection:SetPos( 225, 320 )
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

		_MakeHelpButton( "About", 0, info, "What is this mod?\n\n" ..
			"This is a remake of a 2006 addon called WarMelons:RTS by Lap and MegaJohnny. It's a strategy game that is played in sandbox, allowing you to build contraptions and your own maps with the familiar controls of standard Garry's Mod.\n\n" ..
			"The original addon was discontinued and broke when Gmod 13 came out, and I never heard of the developer again. " ..
			"I missed the addon so much that I looked for it everywhere. After more than a year without success, I decided to learn Lua and make my own version.\n\n" ..
			"This addon isn't quite the same as the original, but I hope it will fill the void that WarMelons left.\n- Marum\n\n" ..
			"Credits:\n\nFaction Mod creator:\nJonahSoldier\n\nFaction Mod contributors:\nthecraftianman\n\n" ..
			"The creator of this addon:\nMarum\n\nThe creators of the original:\nLap and MegaJohnny\n\n" ..
			"Testers and supporters:\nX marks it\n(Xen)SunnY\nBOOM! The_Rusty_Geek\nDagren\nFush\nBroh\nJwanito\nMr. Thompson\nArheisel\nHipnox\n\n" ..
			"Suggestions:\nSquid-Inked (Tesla Tower)\nDurendal5150 (Radar)\n\n",
			"Thanks to:\nMembers of the MelonWars:RTS Discord, and you, for subscribing!\n\nShoutout to Ludsoe, who is also making a WarMelons remake!" )
		info:SetFontInternal("Trebuchet24")

		_MakeHelpButton( "Help", 1, info, "Introduction:\n\nThis addon is a tool that allows you and your friends to play a Real Time Strategy game, much like StarCraft or Age of Empires, but much simpler.\n\n" ..
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

		_MakeHelpButton( "Units", 4, info, "What does each unit do?\n\n" ..
			"Marines:\nThe Marines are the generic soldier. They have accurate rifles, but they aren't very long range. Marines are usually used as cannon fodder to push against slow firing units, but don't underestimate the strength of Marines in big numbers.\n\n" ..
			"Medic:\nThe Medic doesn't like to fight, but he likes seeing others fight. It cannot deal damage in any way. Its only goal is to keep all of its nearby friends healthy and ready for the next battle. " ..
			"Having multiple medics in a squad can drastically increase the squad's durability, and they can keep important units alive. They hurt themselves while healing, and can't heal each other.\n\n" ..
			"Bomb:\nThe Bomb is willing to die for its team. It will explode if it gets killed or if there are enemy units in range. A well placed bomb can take down an entire squad in no time, but they are fragile, so protect them until they get to the target. ",
			"A Bomb spawned as turret will become a Mine and bury into the ground. Be careful about having bombs in your midst, as an enemy sniper can make it explode and take a chunk of your army with it.\n\n" ..
			"Jetpack:\nThe Jetpack is a promoted marine that takes to the skies with a rocket pack. " ..
			"He flies a few meters off the ground at all times, and he specializes in going over walls, transiting harsh terrain, flanking from outside the map, and flying over squads to take down valuable defended targets.\n\n" ..
			"Gunner:\nThe Gunner is a tough and slow unit that carries a minigun. Its gun will spin faster as the battle goes on, so it will deal a lot more damage if it manages to survive 18 seconds of continuous firing.\n\n" ..
			"Missiles:\nThe Missiles is the brother of the Gunner, but it was given a bazooka instead of a machinegun. It fires homing missiles that deal low area damage. It's useful for taking down crowds of weak enemies, taking down a squad's medics, and shooting down flocks of Jetpacks.\n\n" ..
			"Sniper:\nThe Sniper is one of the most damaging units in the game. It shoots very slowly, but it makes every shot count. They are useful for taking down valuable targets, like a bomb in the middle of the enemy army, or quickly taking down a mortar. " ..
			"It's taller than most units to be able to shoot over its allies heads, but its gun is so unwieldy that it cannot shoot while running, making it easily killable on its own. Be sure to escort and protect it, as its shots can be heard from anywhere on the map, and it is sure to become a target.\n\n" ..
			"Mortar:\nThe Mortar is a powerful armored unit that can quickly take down enemy squads. It shoots mortar shells in an arc, which might not be ideal if the enemy is swift to move out of the way, but if that bomb hits a crowd, it will hurt a lot. The mortar is the only unit that can fire over walls, making it a good siege unit.\n\n" ..
			"Nuke:\nThe Nuke is the ultimate breaching weapon. It's slow, but it carries a powerful blast. When it spawns, it informs every player of the imminent danger. " ..
			"It takes 1.5 seconds to explode after it gets to the enemy wall, but it doesn't explode as big if it gets killed before it detonates, so take good care of it until it does. Additionally, it will only automatically target enemy walls in order to avoid enemy kamikazes from triggering it." )

		_MakeHelpButton( "Buildings", 5, info, "What does each building do?\n\n" ..
			"Barracks:\nThe Barracks are a building that produces Marines at one third of the rate they can be spawned with the toolgun, but they spawn ready for battle and half the price. " ..
			"It will produce up to 10 Marines at any given time. The Barracks can be turned on or off by holding the Player Tool, looking at it and pressing the E key.\nEach unit has its own barracks!\n\n" ..
			"Turret:\nThe Turret is your go-to static defense. It has a good damage output, and the longest range in the game. It can't move, even if it's spawned onto a contraption.\n\n" ..
			"Shredder:\nThe Shredder is used to recycle melons and get 90% of their value back. It's good for getting rid of your army if you want to replace your low tier units with higher tier ones.\n\n" ..
			"Elevator Pad:\nThe Elevator Pad is used as an elevator. Every unit on top of it will be levitated upwards up to a certain height. ",
			"Because you can't spawn mobile units onto base props, if you want to, say, make a bomb ambush tower to drop bombs onto your attackers, those bombs can't be spawned directly on the tower. Just use a Pad to get them up there.\n\n" ..
			"Gate:\nThe Gate is useful for making entrances and exits to your base. You can open and close it by looking at it and pressing E with the Player Tool equipped.\n\n" ..
			"Large Gate:\nThe Large Gate can be operated the same way as the small gate, but it requires energy to open and close. It's wider and taller, allowing for bigger armies or contraptions to go through.\n\n" ..
			"Contraption Assembler:\nThis workshop can build any contraption that you've previously saved with the Contraption Manager. Use it to produce tanks, ships, or any vehicle you can imagine and build!\n\n" ..
			"Tesla Tower:\nThis building requires energy to function, but it's a powerful AOE static defense that will zap the 5 closest enemies in a big range. It can get overwhelmed by big squads, and it will consume a LOT of energy while firing.\n\n" ..
			"Over-Clocker:\nSpawn this bad boy right next to a barracks of any kind and watch it increase its production rate! (And consume all of your Energy.) You can't turn it on and off with E.\n\n" ..
			"Radar:\nThe Radar constantly consumes energy, equivalent to one Solar Panel, and cannot be turned off. If the Radar detects an enemy unit, an exclamation mark will pop up on the player's HUD showing the place of the detection.\n\n" ..
			"Medical Bay:\nUses a lot of energy, but has the healing capabilities of 10 Medics in a way bigger radius. It's meant to keep all the units in your base at full health. Be careful though, as having to heal a lot of units at once can really drain your Energy supply." )

		_MakeHelpButton( "Energy", 6, info, "What is Energy for?\n\n" ..
			"Energy is used to power certain buildings that need it to operate. Buildings that interact with Energy appear with Yellow buttons on the spawn menu.\n" ..
			"Buildings use a lot more power than what a player usually generates, so it's a good idea to store it in Batteries in order to have enough when you need it.\n\n" ..
			"How do I connect buildings?\n\nTo connect Energy buildings, use the Relay located in the Energy submenu. For buildings to work, you will need to connect some sort of battery to the network." )

		_MakeHelpButton( "Contrap.", 7, info, "What is a contraption?\n\nA contraption is a machine built by the player that can be used in melon combat as a vehicle. It can be used for ramming, as a tank, as transport, or anything you can imagine.\n\n" ..
			"How do I build them?\n\nBuild a contraption just like you would in Sandbox. Beware that parts like thrusters, hoverballs, and wheels will get removed when you 'legalize' the contraption.\n\n" ..
			"What is legalizing?\n\nIn order to make your contraption legal inside the MelonWars battle, you have to save it using the Contraption Manager, located under the Contrap. menu, and spawn it using a Contraption Assembler.\n\n" ..
			"How do I make my contraption move?\n\nUnder the Contrap. submenu, you have Thrusters, Wheels, Propellers and Hover Pads. " ..
			"The Thruster is a powerful melon that cannot shoot, but it is very strong and can move even if attached to a contraption. The Wheel can be used to help your contraption roll across the ground. The Propeller and Hover Pad can be used to make your contraption hover above ground." )

		_MakeHelpButton("Setup", 8, info, "How do I set up a game?\n\n" ..
			"In order to set up a game, you should build an arena out of props or go to a MelonWars map. The admin should ask the players what colors they want to be, then spawn a Base (or Grand War Base) from the Admin menu for each player at different locations.\n\n" ..
			"Be sure to ask every player to set their team in the Teams tab in this menu.\n\nSpawn a few outposts and capture points around the arena as objectives, and once everything is set up, press the Start Match button.\n\n" ..
			"The admin can also set alliances from the Admin tab.\n\nOnce the match starts, it's a battle to destroy the enemies' bases. Last team standing wins!\n\n" ..
			"Remember, this is as much a gamemode as it is a toy, so there is no actual 'end' to the match other than whatever you make it. " ..
			"You can play until the last base is destroyed, until only one player has units, or any other condition you can imagine. Just be sure to be clear about it with all players before starting." )

		-- }
	elseif (pl.mw_menu == 7) then																--Admin menu
		-- { ADMIN MENU
		if (pl:IsAdmin() or cvars.Number("mw_admin_open_permits") == 1) then
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

			local label = vgui.Create("DLabel", scroll)
			label:SetPos(15, y)
			label:SetSize(200,60)
			label:SetFontInternal( "DermaLarge" )
			label:SetText( "Spawn\nNormal Base" )
			for i = 1, 8 do
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos( 145 + i * 45, y )
				button:SetText("")
				function button:DoClick()
					pl:ConCommand("mw_team " .. tostring(i))
					pl:ConCommand("mw_action 2")
					pl.mw_frame:Remove()
					pl.mw_frame = nil

					net.Start("MW_UpdateClientInfo")
						net.WriteInt(i, 8)
					net.SendToServer()
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
				end
			end

			y = y + 80

			local label = vgui.Create("DLabel", scroll)
			label:SetPos(15, y)
			label:SetSize(200,60)
			label:SetFontInternal( "DermaLarge" )
			label:SetText( "Spawn Grand\nWar Base" )
			for i = 1, 8 do
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos( 145 + i * 45, y )
				button:SetText("")
				function button:DoClick()
					pl:ConCommand("mw_team " .. tostring(i))
					pl:ConCommand("mw_action 7")
					pl.mw_frame:Remove()
					pl.mw_frame = nil

					net.Start("MW_UpdateClientInfo")
						net.WriteInt(i, 8)
					net.SendToServer()
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
				end
			end

			y = y + 80

			local label = vgui.Create("DLabel", scroll)
			label:SetPos(15, y)
			label:SetSize(200,60)
			label:SetFontInternal( "DermaLarge" )
			label:SetText( "Spawn\nOrnament" )
			for i = 1, 8 do
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos( 145 + i * 45, y )
				button:SetText("")
				function button:DoClick()
					pl:ConCommand( "mw_team " .. tostring( i ) )
					pl:ConCommand( "mw_action 25" )
					pl.mw_frame:Remove()
					pl.mw_frame = nil

					net.Start("MW_UpdateClientInfo")
						net.WriteInt(i, 8)
					net.SendToServer()
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
				end
			end

			y = y + 80

			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y)
			label:SetSize(300,60)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText( "Spawn Cap Point" )
			local button = vgui.Create("DButton", scroll)
			button:SetSize(40,40)
			button:SetPos(200,y)
			button:SetText("")
			function button:DoClick()
				pl:ConCommand("mw_action 8")
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
				draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(255, 255, 255, 255) )
			end

			y = y + 60

			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y)
			label:SetSize(300,60)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText( "Spawn Outpost" )
			local button = vgui.Create("DButton", scroll)
			button:SetSize(40,40)
			button:SetPos(200,y)
			button:SetText("")
			function button:DoClick()
				pl:ConCommand("mw_action 9")
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
				draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(255, 255, 255, 255) )
			end

			y = y + 60

			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y)
			label:SetSize(300,60)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText( "Spawn Water Tank" )
			local button = vgui.Create("DButton", scroll)
			button:SetSize(40,40)
			button:SetPos(200,y)
			button:SetText("")
			function button:DoClick()
				pl:ConCommand("mw_action 10")
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
				draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(255, 255, 255, 255) )
			end

			y = y + 80

			local labelTankVal = vgui.Create( "DLabel", scroll )
			labelTankVal:SetPos( 20, y - 20 )
			labelTankVal:SetSize( 200, 80 )
			labelTankVal:SetFontInternal( "DermaLarge" )
			labelTankVal:SetText( "Water Tank\nValue: " .. GetConVar( "mw_water_tank_value" ):GetInt() )
			local default = vgui.Create( "DPanel", scroll )
			default:SetSize( 360, 60 )
			default:SetPos( 200, y - 10 )
			default.Paint = function( s, w, h )
				draw.RoundedBox( 0, 108, 0, 12, h, Color( 10, 150, 10 ) )
				draw.RoundedBox( 0, 0, 0, 72, h, Color( 10, 40, 80 ) )
				draw.RoundedBox( 0, 180, 0, 180, h, Color( 80, 10, 10 ) )
			end
			local sliderTankVal = vgui.Create( "DPanel", scroll )
			sliderTankVal:SetSize( GetConVar( "mw_water_tank_value" ):GetInt() * 0.12, 40 )
			sliderTankVal:SetPos( 200, y )
			for i = 1, 30 do
				local buttonTankVal = vgui.Create( "DButton", scroll )
				buttonTankVal:SetSize( 15, 40 )
				buttonTankVal:SetPos( 185 + i * 12, y )
				buttonTankVal:SetText( "" )
				function buttonTankVal:DoClick()
					pl:ConCommand( "mw_water_tank_value " .. tostring( i * 100 ) )
					sliderTankVal:SetSize( i * 12, 40 )
					labelTankVal:SetText( "Water Tank\nValue: " .. tostring( i * 100 ) )
				end
				buttonTankVal.Paint = function( s, w, h )
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color( 100, 100, 100 ) )
				end
			end

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
			-----------------------------------------------------------  Power
			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y)
			label:SetSize(200,40)
			label:SetFontInternal( "DermaLarge" )
			label:SetText( "Power: " .. tostring( cvars.Number( "mw_admin_max_units" ) ) )
			local default = vgui.Create("DPanel", scroll)
			default:SetSize(360,60)
			default:SetPos( 200, y - 10 )
			default.Paint = function(s, w, h)
				draw.RoundedBox( 0, 108, 0, 12, h, Color(10,150,10) )
				draw.RoundedBox( 0, 0, 0, 12*6, h, Color(10,40,80) )
				draw.RoundedBox( 0, 12*15, 0, 12*15, h, Color(80,10,10) )
			end
			local slider = vgui.Create("DPanel", scroll)
			slider:SetSize( cvars.Number( "mw_admin_max_units" ) * 1.2, 40 )
			slider:SetPos(200,y)
			for i = 1, 30 do
				local button = vgui.Create( "DButton", scroll )
				button:SetSize( 15, 40 )
				button:SetPos( 185 + i * 12, y )
				button:SetText( "" )
				function button:DoClick()
					pl:ConCommand( "mw_admin_max_units " .. tostring( i * 10 ) )
					slider:SetSize( i * 12, 40 )
					label:SetText( "Power: " .. tostring( i * 10 ) )
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 0, w-1, 0, 1, h, Color(100,100,100) )
				end
			end
			----------------------------------------------------------- Starting Credits
			y = y + 70
			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y-20)
			label:SetSize(200,80)
			label:SetFontInternal( "DermaLarge" )
			label:SetText("Starting Water:\n" .. tostring(cvars.Number("mw_admin_starting_credits")))
			local default = vgui.Create("DPanel", scroll)
			default:SetSize(360,60)
			default:SetPos(200,y-10)
			default.Paint = function(s, w, h)
					draw.RoundedBox( 0, 108, 0, 12, h, Color(10,150,10) )
					draw.RoundedBox( 0, 0, 0, 12*6, h, Color(10,40,80) )
					draw.RoundedBox( 0, 12*15, 0, 12*15, h, Color(80,10,10) )
				end
			local slider = vgui.Create("DPanel", scroll)
			slider:SetSize(cvars.Number("mw_admin_starting_credits") * 12 / 200,40)
			slider:SetPos(200,y)
			for i = 1, 30 do
				local button = vgui.Create("DButton", scroll)
				button:SetSize(15,40)
				button:SetPos(185 + i * 12, y)
				button:SetText("")
				function button:DoClick()
					pl:ConCommand("mw_admin_starting_credits " .. tostring(i * 200))
					slider:SetSize(i * 12, 40)
					label:SetText("Starting Water:\n" .. tostring(i * 200))
				end
				button.Paint = function()
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color(100,100,100) )
				end
			end

			y = y + 70
			local label = vgui.Create("DLabel", scroll)
			label:SetPos(20, y-20)
			label:SetSize(200,80)
			label:SetFontInternal( "DermaLarge" )
			label:SetText("Water Income:\n" .. tostring(cvars.Number("mw_admin_base_income")))
			local default = vgui.Create("DPanel", scroll)
			default:SetSize(360,60)
			default:SetPos(200,y-10)
			default.Paint = function(s, w, h)
					draw.RoundedBox( 0, 48, 0, 12, h, Color(10,150,10) )
					draw.RoundedBox( 0, 0, 0, 12*2, h, Color(10,40,80) )
					draw.RoundedBox( 0, 12*8, 0, 12*22, h, Color(80,10,10) )
				end
			local slider = vgui.Create("DPanel", scroll)
			slider:SetSize(cvars.Number("mw_admin_base_income") * 12/5,40)
			slider:SetPos(200,y)
			for i = 1, 30 do
				local button = vgui.Create("DButton", scroll)
				button:SetSize(15,40)
				button:SetPos( 185 + i * 12, y )
				button:SetText("")
				function button:DoClick()
					pl:ConCommand( "mw_admin_base_income " .. tostring( i * 5 ) )
					slider:SetSize( i * 12, 40 )
					label:SetText( "Water Income:\n" .. tostring( i * 5 ) )
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 0, w - 1, 0, 1, h, Color(100,100,100) )
				end
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
					-- checkbox:SetValue( teamgrid[i][j] )
					checkbox:SetSize(30,30)
					checkbox:SetText("")

					if (9-i ~= j) then
						function checkbox:DoClick()
							teamgrid[9-i][j] = not teamgrid[9-i][j]
							teamgrid[j][9-i] = teamgrid[9-i][j]
							net.Start("UpdateServerTeams")
								net.WriteTable(teamgrid)
							net.SendToServer()
						end
						if (i+j < 9) then
							checkbox.Paint = function(s, w, h)
								draw.RoundedBox( 4, 0, 0, w, h, Color(150,150,150) )
								draw.RoundedBox( 2, 2, 2, w-4, h-4, Color(0,0,0) )
								if (teamgrid[9-i][j]) then
									draw.RoundedBox( 0, 4, 4, w / 2-4, h-8, mw_team_colors[9-i] )
									draw.RoundedBox( 0, 4+w / 2-4, 4, w / 2-4, h-8, mw_team_colors[j] )
								end
							end
						else
							checkbox.Paint = function(s, w, h)
								draw.RoundedBox( 8, 0, 0, w, h, Color(30,30,30) )
								draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(20,20,20) )
								if (teamgrid[9-i][j]) then
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
					draw.RoundedBox( 6, 2, 2, w-4, h-4, mw_team_colors[i] )
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
					draw.RoundedBox( 6, 2, 2, w-4, h-4, mw_team_colors[i] )
				end
				grid:AddItem(DPanel)
			end
		else
			local label = vgui.Create("DLabel", pl.panel)
			label:SetPos(120, 210)
			label:SetSize(370,30)
			label:SetFontInternal( "DermaLarge" )
			label:SetText("This menu is for admins only")
		end
		-- }
	elseif (pl.mw_menu == 8) then -- Player menu
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

		local labelstr = "Allows players to start matches if a certain percentage are ready"
		local textstr = "[Ready Up]"
		local checkbox = vgui.Create( "DButton", scroll ) -- Create the checkbox
		checkbox:SetPos( 20, y ) -- Set the position
		checkbox:SetSize(60,30)
		checkbox:SetText("")
		local checked = GetConVar( "mw_player_ready" ):GetInt() ~= 1
		if (inverted) then checked = not checked end
		checkbox.Paint = function(s, w, h)
			draw.RoundedBox( 8, 0, 0, w, h, color_white )
			draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(0,0,0) )
			if not checked then
				draw.RoundedBox( 4, 4, 4, w-8, h-8, color_white )
			end
		end
		function checkbox:DoClick()
			local commandstring = "mw_player_ready " .. tostring( 1 - GetConVar( "mw_player_ready" ):GetInt() )

			pl:ConCommand(commandstring)

			local checked = GetConVar( "mw_player_ready" ):GetInt() ~= 1
			if (inverted) then checked = not checked end
			checkbox.Paint = function(s, w, h)
				draw.RoundedBox( 8, 0, 0, w, h, color_white )
				draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(0,0,0) )
				if (checked) then
					draw.RoundedBox( 4, 4, 4, w-8, h-8, color_white )
				end
			end

			-- I have to add an artificial delay or the serverside code runs before the convar is changed
			timer.Simple(0.1, function()
				net.Start("MWReadyUp")
				net.SendToServer()
			end)
		end
		if (textstr ~= nil) then
			local label = vgui.Create("DLabel", scroll)
			label:SetPos( 90, y)
			label:SetSize(370,30)
			label:SetFontInternal( "Trebuchet24" )
			label:SetText(textstr)
		end
		if (labelstr ~= nil) then
			local label = vgui.Create("DLabel", scroll)
			label:SetPos( 190, y)
			label:SetSize(370,30)
			label:SetFontInternal( "Trebuchet18" )
			label:SetText(labelstr)
		end
	end
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
	if cvars.Bool("mw_admin_cutscene") then return end
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

function TOOL:DrawToolScreen( width, height )
	-- Draw black background
	surface.SetDrawColor( Color( 20, 20, 20 ) )
	surface.DrawRect( 0, 0, width, height )

	if cvars.Bool( "mw_admin_cutscene" ) then
		draw.SimpleText( "Toolgun Disabled", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return
	end

	-- Draw white text in middle
	local action = LocalPlayer():GetInfoNum( "mw_action", 0 )
	if action == 0 then
		draw.SimpleText( "Selecting units", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	elseif action == 1 then
		draw.SimpleText( "Spawning units", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	elseif action == 2 then
		draw.SimpleText( "Spawning Base", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	elseif action == 3 then
		draw.SimpleText( "Spawning Prop", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	elseif action == 4 then
		draw.SimpleText( "Contraptions", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	elseif action == 945 then
		draw.SimpleText( "Click on a unit", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function TOOL:Deploy()
	local owner = self:GetOwner()

	self.pressed = false
	self.rPressed = false
	self.disableKeyboard = false
	self.ctrlPressed = false
	self.canPlace = true
	owner.cutsceneOpacity = 0
	owner.chatTimer = 0
	local _team = owner:GetInfoNum( "mw_team", 0 )
	if not SERVER then return end
	if _team ~= 0 then
		net.Start( "MW_TeamCredits" )
			net.WriteInt( mw_teamCredits[_team], 32 )
		net.Send( owner )

		net.Start( "MW_TeamUnits" )
			net.WriteInt( mw_teamUnits[_team], 16 )
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

local function MW_BeginSelection() -- Previously concommand.Add( "+mw_select", function( ply )
	if not CLIENT then return end

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

local function isInRangeLoop( vector, teamIndex, entClass, buildDist )
	for _, v in ipairs( ents.FindByClass( entClass ) ) do
		if vector:Distance( v:GetPos() ) < buildDist and v:GetNWInt( "mw_melonTeam", 0 ) == teamIndex then
			return true
		end
	end
end

local function isInRange( vector, teamIndex ) -- Why does this not just use findinsphere?
	local canBuild = false

	if isInRangeLoop( vector, teamIndex, "ent_melon_main_building", 800 ) then return true end
	if isInRangeLoop( vector, teamIndex, "ent_melon_station", 250 ) then return true end
	if isInRangeLoop( vector, teamIndex, "ent_melon_main_unit", 250 ) then return true end
	if isInRangeLoop( vector, teamIndex, "ent_melon_main_building_grand_war", 1600 ) then return true end

	local foundPoints = ents.FindByClass( "ent_melon_outpost_point" )

	for _, v in ipairs( foundPoints ) do
		if not canBuild then
			if vector:Distance(v:GetPos()) < 600 then
				if teamgrid == nil or teamgrid[v:GetNWInt( "capTeam", 0 )] == nil or teamgrid[v:GetNWInt( "capTeam", 0 )][teamIndex] == nil then
					canBuild = v:GetNWInt( "capTeam", 0 ) == teamIndex
				elseif v:GetNWInt( "capTeam", 0 ) == teamIndex or teamgrid[v:GetNWInt( "capTeam", 0 )][teamIndex] then
					canBuild = true
				end
			end
		end
	end

	return canBuild
end

local function noEnemyNear( vector, teamIndex )
	local foundEnts = ents.FindInSphere( vector, 300 )
	local canBuild = true

	for _, v in pairs( foundEnts ) do
		if v.Base == "ent_melon_base" then
			if v:GetNWInt( "mw_melonTeam", 0 ) ~= teamIndex then
				if v:GetNWInt( "mw_melonTeam", 0 ) ~= 0 then
					if not teamgrid[v:GetNWInt( "mw_melonTeam", 0 )][teamIndex] then
						canBuild = false
					end
				end
			end
		end
	end

	return canBuild
end

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
	end

	if IsValid( self:GetOwner().controllingUnit ) then return end
	if GetConVar( "mw_admin_cutscene" ):GetBool() then return end
	if pl.mw_cooldown >= CurTime() - 0.1 then return end

	local trace = self:GetOwner():GetEyeTrace( {
	mask = MASK_SOLID + MASK_WATER
	} )

	pl.mw_cooldown = CurTime()
	mw_melonTeam = pl:GetInfoNum("mw_team", 0)

	local action = pl:GetInfoNum("mw_action", 0)
	if action == 0 then
		MW_BeginSelection()
		pl.mw_selectTimer = CurTime()
		pl.mw_spawnTimer = CurTime()
	elseif action == 1 then
		if pl.mw_spawnTimer >= CurTime() - 0.1 then return end
		if (cvars.Bool("mw_admin_playing")) then
			local attach = pl:GetInfoNum("mw_unit_option_welded", 0)
			local unit_index = pl:GetInfoNum("mw_chosen_unit", 0)
			if (cvars.Bool("mw_admin_allow_free_placing") or noEnemyNear(trace.HitPos, mw_melonTeam)) then
				if (mw_units[unit_index].population == 0 or pl.mw_units + mw_units[unit_index].population <= cvars.Number("mw_admin_max_units")) then
					if (pl.canPlace) then
						local cost, mw_delay = 0
						local class = ""

						if (unit_index > 0) then
							class = mw_units[unit_index].class
							mw_delay = mw_units[unit_index].spawn_time
							cost = 1337

							if (attach == 1) then
								cost = mw_units[unit_index].welded_cost
							else
								cost = mw_units[unit_index].cost
							end

							if (cost == -1) then
								cost = mw_units[unit_index].cost
								attach = false
							end

							if (mw_units[unit_index].contraptionPart) then
								attach = true
							end

							if (unit_index >= firstBuilding and unit_index < firstContraption) then
								attach = true
							end
						end

						--if (unit_index >= firstBuilding) then attach = true end
						if pl.mw_credits >= cost or not cvars.Bool("mw_admin_credit_cost") or mw_melonTeam == 0 then
							local canFloorSpawn = mw_units[unit_index].spawnable_on_floor or not trace.Entity:IsWorld()
							local notPointOrWater = trace.Entity:GetClass() ~= "ent_melon_outpost_point" and trace.Entity:GetClass() ~= "ent_melon_cap_point" and trace.Entity:GetClass() ~= "ent_melon_water_tank"
							local entHasTeam = trace.Entity:GetNWInt("mw_melonTeam", 0) == mw_melonTeam or trace.Entity:GetNWInt("mw_melonTeam", 0) == 0

							if attach == false or canFloorSpawn and notPointOrWater and entHasTeam then
								if unit_index >= 0 then
									if (cvars.Number("mw_admin_spawn_time") == 1) then
										if (cvars.Bool("mw_admin_allow_free_placing") or mw_units[unit_index].buildAnywere or isInRange(trace.HitPos, mw_melonTeam) or mw_melonTeam == 0) then
											if (pl.mw_spawntime < CurTime()) then
												pl.mw_spawntime = CurTime() + mw_units[unit_index].spawn_time * pl.spawnTimeMult -- spawntimemult has been added here so I can compensate for matches with uneven numbers of commanders
											else
												pl.mw_spawntime = pl.mw_spawntime + mw_units[unit_index].spawn_time * pl.spawnTimeMult
											end
										end
									end
								else
									pl.mw_spawntime = 0
								end

								local spawnAngle
								if (mw_units[unit_index].normalAngle) then
									spawnAngle = trace.HitNormal:Angle() + mw_units[unit_index].angle
								else
									if (mw_units[unit_index].changeAngles) then
										spawnAngle = pl.propAngle + mw_units[unit_index].angle
									else
										spawnAngle = mw_units[unit_index].angle
									end
								end

								local spawnPosition = trace.HitPos + Vector(0,0,1) + trace.HitNormal*5+mw_units[unit_index].offset

								 net.Start("MW_SpawnUnit")
									net.WriteString(class)
									net.WriteInt(unit_index, 16)
									net.WriteTable(trace)
									net.WriteInt(cost, 16)
									net.WriteInt(pl.mw_spawntime * cvars.Number("mw_admin_spawn_time"), 16)
									net.WriteInt(mw_melonTeam, 8)
									net.WriteInt(mw_delay, 16)
									net.WriteBool(attach)
									net.WriteAngle(spawnAngle)
									net.WriteVector(spawnPosition)
								net.SendToServer()

								local effectdata = EffectData()
								effectdata:SetEntity( newMarine )
								util.Effect( "propspawn", effectdata )

								if (cvars.Bool("mw_admin_allow_free_placing") or mw_units[unit_index].buildAnywere or isInRange(trace.HitPos, mw_melonTeam) or mw_melonTeam == 0) then
									if cvars.Bool( "mw_admin_credit_cost" ) or mw_melonTeam == 0 then
										self:IndicateIncome(-cost)
										pl.mw_credits = pl.mw_credits-cost
									end
								end
							else
								pl:PrintMessage( HUD_PRINTTALK, "== Can't attach units onto non legalized props! ==" )
							end
						else
							pl:PrintMessage( HUD_PRINTTALK, "== Not enough resources! ==" )
						end
					else
						pl:PrintMessage( HUD_PRINTTALK, "== What you're trying to spawn overlaps with something else! ==" )
					end
				else
					pl:PrintMessage( HUD_PRINTTALK, "== Power max reached! ==" )
				end
			else
				pl:PrintMessage( HUD_PRINTTALK, "== Enemy too close! ==" )
			end
		else
			pl:PrintMessage( HUD_PRINTTALK, "== The admin has paused the game! ==" )
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
		local cost = mw_base_props[prop_index].cost
		if not cvars.Bool("mw_admin_playing") then return end
		if not (cvars.Bool("mw_admin_allow_free_placing") or isInRange(trace.HitPos, mw_melonTeam)) then return end
		if not (cvars.Bool("mw_admin_allow_free_placing") or noEnemyNear(trace.HitPos, mw_melonTeam)) then return end
		if not (pl.mw_credits >= cost or not cvars.Bool("mw_admin_credit_cost")) then return end

		if (cvars.Number("mw_admin_spawn_time") == 1) then
			if (pl.mw_spawntime < CurTime()) then
				pl.mw_spawntime = CurTime() + mw_base_props[prop_index].spawn_time
			else
				pl.mw_spawntime = pl.mw_spawntime + mw_base_props[prop_index].spawn_time
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
	elseif (action == 4) then  --Contraption Save
		if (CLIENT) then
			net.Start("ContraptionSave")
				net.WriteString(pl.contraption_name)
				net.WriteEntity(pl:GetEyeTrace().Entity)
			net.SendToServer()
		end
		self:GetOwner():ConCommand("mw_action 0")
	-- elseif (action == 5) then  --Sell Tool
	elseif (action == 6) then  --Contraption Load
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
	elseif (action == 7) then
		net.Start("SpawnBaseGrandWar")
			net.WriteTable(trace)
			net.WriteInt(mw_melonTeam, 8)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif (action == 8) then
		net.Start("SpawnCapturePoint")
			net.WriteTable(trace)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif (action == 9) then
		net.Start("SpawnOutpost")
			net.WriteTable(trace)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif (action == 10) then
		net.Start("MW_SpawnWaterTank")
			net.WriteTable(trace)
		net.SendToServer()
		self:GetOwner():ConCommand("mw_action 0")
	elseif (action == 25) then
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
		else
			net.Start("MWBrute")
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

	if newColor == nil then
		newColor = Color(100,100,100)
	end
	if tostring( locPly.GhostEntity ) == "[NULL Entity]" or not IsValid( locPly.GhostEntity ) then
		locPly.GhostEntity = ents.CreateClientProp( model )
		locPly.GhostEntity:SetSolid( SOLID_VPHYSICS )
		locPly.GhostEntity:SetMoveType( MOVETYPE_NONE )
		locPly.GhostEntity:SetNotSolid( true )
		locPly.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
		locPly.GhostEntity:SetRenderFX( kRenderFxPulseFast )
		locPly.GhostEntity:SetMaterial( "models/debug/debugwhite" )
		locPly.GhostEntity:SetColor( Color( newColor.r * 1.5, newColor.g * 1.5, newColor.b * 1.5, 150 ) )
		locPly.GhostEntity:SetModel( model )
		locPly.GhostEntity:SetPos( pos + offset )
		locPly.GhostEntity:SetAngles( angle )
		locPly.GhostEntity:Spawn()
	else
		locPly.GhostEntity:SetModel( model )
		locPly.GhostEntity:SetPos( pos + offset )
		locPly.GhostEntity:SetAngles( angle )
		local obbmins = locPly.GhostEntity:OBBMins()
		local obbmaxs = locPly.GhostEntity:OBBMaxs()
		obbmins:Rotate( angle )
		obbmaxs:Rotate( angle )
		local mins = Vector( locPly.GhostEntity:GetPos().x + obbmins.x, locPly.GhostEntity:GetPos().y + obbmins.y, pos.z + 5 )
		local maxs = Vector( locPly.GhostEntity:GetPos().x + obbmaxs.x, locPly.GhostEntity:GetPos().y + obbmaxs.y, pos.z + 20 )
		local overlappingEntities = ents.FindInBox( mins, maxs )

		locPly.canPlace = true
		if locPly.mw_action == 1 and not mw_units[locPly:GetInfoNum( "mw_chosen_unit", 0 )].canOverlap then
			for _, v in pairs( overlappingEntities ) do
				if v.Base ~= nil and string.StartWith( v.Base, "ent_melon_" ) then
					locPly.canPlace = false
				end
			end
		end
		if locPly.canPlace then
			locPly.GhostEntity:SetColor( Color(newColor.r, newColor.g, newColor.b, 150 ))
			locPly.GhostEntity:SetRenderFX( kRenderFxPulseSlow )
		else
			locPly.GhostEntity:SetColor( Color(150, 0, 0, 150 ))
			locPly.GhostEntity:SetRenderFX( kRenderFxDistort )
		end
	end

	if tostring( locPly.GhostSphere ) == "[NULL Entity]" or not IsValid( locPly.GhostSphere ) then
		if locPly.mw_action == 1 and ghostSphereRange > 0 then
			locPly.GhostSphere = ents.CreateClientProp( "models/hunter/tubes/circle2x2.mdl" )
			locPly.GhostSphere:SetSolid( SOLID_VPHYSICS )
			locPly.GhostSphere:SetMoveType( MOVETYPE_NONE )
			locPly.GhostSphere:SetNotSolid( true )
			locPly.GhostSphere:SetRenderMode( RENDERMODE_TRANSALPHA )
			locPly.GhostSphere:SetRenderFX( kRenderFxPulseSlow )
			locPly.GhostSphere:SetMaterial("models/debug/debugwhite")
			locPly.GhostSphere:SetColor( Color( newColor.r * 1.5, newColor.g * 1.5, newColor.b * 1.5, 50 ) )
			locPly.GhostSphere:SetModelScale( 0.021 * ghostSphereRange )
			locPly.GhostSphere:Spawn()
		end
	else
		if locPly.mw_action == 1 and ghostSphereRange > 0 then
			local color = locPly.GhostSphere:GetColor()
			locPly.GhostSphere:SetColor( Color(color.r, color.g, color.b, 50) )
			locPly.GhostSphere:SetPos( Vector(pos.x, pos.y, ghostSpherePos.z ) )
			locPly.GhostSphere:SetModelScale( 0.021 * ghostSphereRange )
		else
			locPly.GhostSphere:Remove()
		end
	end
end

local function MW_FinishSelection() -- Previously concommand.Add( "-mw_select", function( ply )
	if not CLIENT then return end

	sound.Play( "buttons/lightswitch2.wav", LocalPlayer():GetPos(), 50, 80, 1 )
	LocalPlayer().mw_selecting = false
end

function TOOL:Think()
	if not CLIENT then return end

	local ply = LocalPlayer()
	local trace = ply:GetEyeTrace()
	local vector = trace.HitPos - ply:GetPos()

	if ply.mw_selecting then
		--[[ Weird code to make the trace sorta act like there's a solid platform on the z level the selection started at:
		 I can't find a way to calculate the length between the player's eye position and the point we're aiming to hit
		 so I'm going to see if this really ghetto solution works and/or if it's laggy ]]
		-- local targetpos = EyePos()

		local specialTrace = util.TraceLine( {
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
			filter = function( ent ) if ( ent:GetClass() ~= "player" ) then return true end end,
			mask = MASK_SOLID + MASK_WATER
		} )

		local desiredZ = ply.mw_selectionStartingPoint[3]
		local actualZ = specialTrace.HitPos[3]
		local eyeZ = ply:EyePos()[3]
		local processedTrace = ply:EyePos()

		if desiredZ < eyeZ and actualZ < desiredZ then
			local fraction = ( eyeZ - desiredZ ) / ( eyeZ - actualZ ) -- Distance to desired z as fraction of the whole trace's length
			processedTrace = processedTrace + ( ply:EyeAngles():Forward() * fraction * specialTrace.StartPos:Distance( specialTrace.HitPos ) )
		else
			-- Not sure if I want the commented stuff, it might in some situations make doing some things a bit easier, and it hasn't bothered me or anyone else yet that it behaves this way
			-- if(actualZ>desiredZ) then
			--	 processedTrace = Vector(specialTrace.HitPos[1], specialTrace.HitPos[2], desiredZ)
			-- else
				processedTrace = specialTrace.HitPos
			-- end
		end

		ply.mw_selectionEndingPoint = ( ply.mw_selectionEndingPoint * 9 + processedTrace ) / 10

		if input.IsMouseDown( MOUSE_LEFT ) then return end

		self:DoSelection( ply.mw_selectionStartingPoint, processedTrace )
		MW_FinishSelection()
		ply.mw_selecting = false
	end

	if ply.chatTimer == nil then
		ply.chatTimer = 0
	end
	if ply.cutsceneOpacity == nil then
		ply.cutsceneOpacity = 0
	end
	if self.canPlace == nil then
		self.canPlace = false
	end
	if ply.chatTimer > 0 then
		if ply.cutsceneOpacity < 230 then
			ply.cutsceneOpacity = ply.cutsceneOpacity + 2
		end
		ply.chatTimer = ply.chatTimer - 1
	else
		if ply.cutsceneOpacity > 0 then
			ply.cutsceneOpacity = ply.cutsceneOpacity - 0.5
			if ply.cutsceneOpacity < 0 then
				ply.cutsceneOpacity = 0
			end
		end
	end

	if ply.mw_action == 1 then
		ply.propAngle = Vector( vector.x, vector.y, 0 ):Angle()
		if ply:GetInfoNum( "mw_chosen_unit", 0 ) ~= 0 then
			if mw_units[ply:GetInfoNum( "mw_chosen_unit", 0 )].angleSnap then
				ply.propAngle = Angle( ply.propAngle.p, 180+math.Round(ply.propAngle.y / 90) * 90, ply.propAngle.r )
			end
		end
	elseif cvars.Number("mw_prop_snap") == 1 then
		ply.propAngle = Vector( vector.x, vector.y, 0 ):Angle()
		ply.propAngle = Angle( ply.propAngle.p, math.Round(ply.propAngle.y / 45) * 45, ply.propAngle.r )
	else
		ply.propAngle = Vector( vector.x, vector.y, 0 ):Angle()
	end

	local newTeam = cvars.Number( "mw_team" )
	local newColor = Color( 200, 200, 200, 255 )

	if not ply.disableKeyboard then
		if input.IsKeyDown( KEY_R ) then
			if self.rPressed == nil then
				self.rPressed = false
			end
			if not self.rPressed then
				self.rPressed = true
				if ply.mw_frame ~= nil then
					ply.mw_frame:Remove()
					ply.mw_frame = nil
				end
			end
		else
			self.rPressed = false
		end

		if ply.mw_action == 0 then
			if input.IsKeyDown( KEY_E ) then
				if self.ePressed == nil then
					self.ePressed = false
				end
				if not self.ePressed then
					self.ePressed = true
					local tr = ply:GetEyeTrace()
					local correctTeam = (tr.Entity:GetNWInt("mw_melonTeam", 0) == newTeam or tr.Entity:GetNWInt("capTeam", 0) == newTeam or cvars.Bool("mw_admin_move_any_team", false))

					if (string.StartWith( tr.Entity:GetClass(), "ent_melon_barracks" ) or tr.Entity:GetClass() == "ent_melon_overclocker" ) then
						-- if (correctTeam) then
							net.Start("ToggleBarracks")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_gate" ) or string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_switch" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
								net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_propeller" ) or string.StartWith( tr.Entity:GetClass(), "ent_melon_hover" )) then
						-- if (correctTeam) then
							net.Start("PropellerReady")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_unit_transport" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_water_tank" )) then
						-- if (correctTeam) then
							net.Start("MW_UseWaterTank")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_steam_plant" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_nuclear_plant" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_contraption_assembler" )) then
						if (correctTeam) then
							ply.selectedAssembler = tr.Entity
							self:MakeContraptionMenu()
						end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_water_pump" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_longboy" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_unit_launcher" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_powerupgrader" )) then
						-- if (correctTeam) then
							net.Start("MW_Activate")
							 	net.WriteEntity(tr.Entity)
							 	net.WriteInt(newTeam,8)
							net.SendToServer()
						-- end
					end
				end
			else
				self.ePressed = false
			end
		end
	end

	if (newTeam ~= 0) then
		newColor = mw_team_colors[newTeam]
	else
		newColor = Color(100,100,100,255)
	end
	ply.mw_hudColor = newColor

	if (ply.mw_action == 5) then
		if not input.IsMouseDown( MOUSE_LEFT ) then
			ply.mw_sell = 0
		else
			ply.mw_sell = ply.mw_sell + 1 / 100
			if (ply.mw_sell > 1) then
				if (trace.Entity:GetNWInt("mw_melonTeam") == newTeam) then
					net.Start("SellEntity")
						net.WriteEntity(trace.Entity)
						net.WriteInt(cvars.Number("mw_team"), 8)
					net.SendToServer()
				end
				ply.mw_sell = 0
			end
		end
	end

	if (input.IsKeyDown( KEY_LCONTROL )) then
		if (self.ctrlPressed == nil) then
			self.ctrlPressed = false
		end
		if not self.ctrlPressed then
			self.ctrlPressed = true

			if (istable(ply.foundMelons)) then
			local count = table.Count(ply.foundMelons)
			if (count > 0) then
				net.Start("MW_Stop")
					for k, v in pairs(ply.foundMelons) do
						net.WriteEntity(v)
					end
				net.SendToServer()
				end
			end
		end
	else
		self.ctrlPressed = false
	end

	if (ply.mw_spawnTimer == nil) then
		ply.mw_spawnTimer = CurTime()
	end
	if (ply.mw_selectTimer == nil) then
		ply.mw_selectTimer = CurTime()
	end
	if (ply.mw_cooldown == nil) then
		ply.mw_cooldown = CurTime()
	end

	if (ply.mw_units == nil) then
		ply.mw_units = 0
	end
	if (ply.mw_credits == nil) then
		ply.mw_credits = 0
	end
	if (ply.mw_sell == nil) then
		ply.mw_sell = 0
	end
	if (ply.mw_spawntime == nil) then
		ply.mw_spawntime = CurTime()
	end

	if (ply.mw_action == 1) then
		local newColor = mw_team_colors[ply:GetInfoNum("mw_team", 0)]
		local unit_index = ply:GetInfoNum("mw_chosen_unit", 0)
		if unit_index > 0 and mw_units[unit_index].offset ~= nil then
			local offset = mw_units[unit_index].offset
			local xoffset = Vector(offset.x * (math.cos(ply.propAngle.y / 180 * math.pi)), offset.x * (math.sin(ply.propAngle.y / 180 * math.pi)),0)
			local yoffset = Vector(offset.y * (-math.sin(ply.propAngle.y / 180 * math.pi)), offset.y * (math.cos(ply.propAngle.y / 180 * math.pi)),0)
			offset = xoffset + yoffset + Vector(0,0,offset.z)
			local ang = ply.propAngle + mw_units[unit_index].angle
			if (mw_units[unit_index].normalAngle) then
				ang = trace.HitNormal:Angle() + mw_units[unit_index].angle
			end

			MW_UpdateGhostEntity(mw_units[unit_index].model, trace.HitPos, trace.HitNormal * 5+offset, ang, newColor, mw_units[unit_index].energyRange, trace.HitPos)
		end
	elseif (ply.mw_action == 3) then
		local newColor = mw_team_colors[ply:GetInfoNum("mw_team", 0)]
		-- local modeltable = list.Get( "WallModels" )
		local prop_index = ply:GetInfoNum("mw_chosen_prop", 0)
		local offset
		if (cvars.Bool("mw_prop_offset") == true) then
			offset = mw_base_props[prop_index].offset
			--offset:Rotate( ply.propAngle )
			local xoffset = Vector(offset.x * (math.cos(ply.propAngle.y / 180 * math.pi)), offset.x * (math.sin(ply.propAngle.y / 180 * math.pi)),0)
			local yoffset = Vector(offset.y * (-math.sin(ply.propAngle.y / 180 * math.pi)), offset.y * (math.cos(ply.propAngle.y / 180 * math.pi)),0)
			offset = xoffset + yoffset + Vector(0,0,offset.z)
		else
			offset = Vector(0,0,mw_base_props[prop_index].offset.z)
		end
		MW_UpdateGhostEntity (mw_base_props[prop_index].model, ply:GetEyeTrace().HitPos, Vector(0,0,1) + offset, ply.propAngle + mw_base_props[prop_index].angle, newColor, 0, trace.HitPos, mw_units[prop_index].defenseRange)
	else
		if IsValid(ply.GhostEntity) then
			ply.GhostEntity:Remove()
		end
		if IsValid(ply.GhostSphere) then
			ply.GhostSphere:Remove()
		end
	end
end

function TOOL:DoSelection(startingPos, endingPos)
	local center = (startingPos + endingPos) / 2;
	local radius = (startingPos-endingPos):Length() / 2

	local foundEntities = {}
	local allFoundEntities = {}
	local typeSelect = nil
	local locPly = LocalPlayer()

	if (locPly.foundMelons ~= nil) then
		if (not locPly:KeyDown(IN_SPEED)) then
			table.Empty(locPly.foundMelons)
		end
	end

	if (locPly.lastSelectionTime == nil) then
		locPly.lastSelectionTime = CurTime()
	end

	local _team = locPly:GetInfoNum("mw_team", -2)

	if (locPly.mw_selectionID == nil) then
		locPly.mw_selectionID = 0
	end

	locPly.mw_selectionID = ( locPly.mw_selectionID + 1 ) % 255

	local clickedUnit = locPly:GetEyeTrace().Entity

	if locPly.lastSelectionTime + 0.3 > CurTime() and IsValid( clickedUnit ) then
		if string.StartWith(clickedUnit:GetClass(),"ent_melon_") then
			allFoundEntities = ents.FindInSphere( center, 300 )
			net.Start("MW_RequestSelection")
				net.WriteInt(locPly.mw_selectionID, 20)
				net.WriteString(clickedUnit:GetClass())
				net.WriteVector(center)
				net.WriteFloat(300)
			net.SendToServer()
			typeSelect = clickedUnit:GetClass()
		end
	else
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


			if clickedUnit:GetClass() == "ent_melon_jetpack" then
				allFoundEntities = ents.FindInBox(center - Vector(radius,radius,50), center + Vector(radius,radius,50) )
			else
				allFoundEntities = ents.FindInBox(center - Vector(radius,radius,depth), center + Vector(radius,radius,height) )
			end

			local xCoord, yCoord, zCoord = center:Unpack()
			local processedCenter = Vector(xCoord, yCoord, 0) -- probably a better way to do this, I tried multiplying by a vector but that broke the code

			for k, v in pairs(allFoundEntities) do
				local xCoord2, yCoord2, zCoord2 = v:GetPos():Unpack()
				local processedPosition = Vector(xCoord2, yCoord2, 0)
				if processedPosition:DistToSqr( processedCenter ) > radius * radius then -- makes sure we select in just a cylinder, not a box.
					table.remove( allFoundEntities, k )
				end
			end

			-- allFoundEntities = ents.FindInSphere( center, radius )
			net.Start("MW_RequestSelection")
				net.WriteInt(locPly.mw_selectionID, 20)
				net.WriteString("nil")
				net.WriteVector(center)
				net.WriteFloat(radius)
				net.WriteEntity(clickedUnit)
			net.SendToServer()
		else
			-- print("The network thing should've run here")
			if clickedUnit.Base == "ent_melon_base" then
				table.Empty(allFoundEntities)
				table.insert(allFoundEntities, 1, hitEnt)
			else
				allFoundEntities = ents.FindInSphere( center, 10 )
				radius = 15
			end

			net.Start("MW_RequestSelection")
				net.WriteInt(locPly.mw_selectionID, 20)
				net.WriteString("nil")
				net.WriteVector(center)
				net.WriteFloat(radius)
				net.WriteEntity(clickedUnit)
			net.SendToServer()
		end
	end

	locPly.lastSelectionTime = CurTime()

	for _, v in ipairs(allFoundEntities) do
		if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("mw_melonTeam", -1) == locPly:GetInfoNum("mw_team", -2)) then
			if (v:GetClass() ~= "ent_melon_zone") then
				if (typeSelect == nil or typeSelect == v:GetClass()) then
					table.insert( foundEntities, v )
				end
			end
		end
	end

	if (istable(foundEntities)) then
		locPly.foundMelons = table.Copy(foundEntities)
	end
end

function TOOL:IndicateIncome(amount)
	local indicator = incomeIndicators[currentIncomeIndicator]
	currentIncomeIndicator = (currentIncomeIndicator+1)%(#incomeIndicators) + 1
	indicator.time = CurTime()
	indicator.value = amount
end

local function SelectContraption(pl, path, contraptionName, contraptionCost, contraptionPower)
	local cost = 0
	local power = 0
	local spawnTime = 0
	local fulltable = util.JSONToTable(file.Read( path ))
	local duptable = fulltable.Entities
	local sizePenalty = 0
	for _, ent in pairs( duptable ) do
		if (ent.realvalue ~= nil) then
			cost = cost + ent.realvalue
			if (ent.spawnDelay == nil) then
				spawnTime = spawnTime + ent.realvalue / 25
			end
		end
		if (ent.population ~= nil) then
			power = power + ent.population
		end
		if (ent.Pos ~= nil) then
			sizePenalty = sizePenalty + (ent.Pos):LengthSqr() / 1000
		end
		if (ent.spawnDelay ~= nil) then
			spawnTime = spawnTime + ent.spawnDelay * 2
		end
	end

	pl.selectedFile = path
	cost = math.Round( cost + sizePenalty )

	pl.selectedAssembler:SetNWFloat("slowThinkTimer", spawnTime)

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
	if locPly.contrapPower ~= 0 or locPly.mw_units + locPly.contrapPower > cvars.Number( "mw_admin_max_units" ) then return end

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
		net.WriteUInt(locPly.contrapPower, 16)
		net.WriteString(_file)
		net.WriteFloat(assembler:GetNWFloat("slowThinkTimer", 0))
	net.SendToServer()

	if cvars.Bool("mw_admin_credit_cost") then
		local newCredits = locPly.mw_credits-locPly.contrapCost
		net.Start("MW_UpdateServerInfo")
			net.WriteInt(cvars.Number("mw_team"), 8)
			net.WriteInt(newCredits, 32)
		net.SendToServer()
		net.Start("MW_UpdateClientInfo")
			net.WriteInt(cvars.Number("mw_team"), 8)
		net.SendToServer()
	end

	locPly.cmenuframe:Remove()
	locPly.cmenuframe = nil
end

function TOOL:MakeContraptionMenu()
	local locPly = LocalPlayer()

	if locPly.cmenuframe ~= nil then
		if locPly.selectedAssembler.file == nil then return end
		-- Fix an exploit resulting from this shit not updating with this
		-- This means contraption price related stuff has to be updated in two separate places now which is stupid, but I don't want to have to restructure Marum's code just to make updating this less annoying

		local cost = 0
		local power = 0
		local spawnTime = 0

		local fulltable = util.JSONToTable(file.Read(locPly.selectedAssembler.file))
		local duptable = fulltable.Entities
		local sizePenalty = 0
		for _, ent in pairs( duptable ) do
			if (ent.realvalue ~= nil) then
				cost = cost + ent.realvalue
				if (ent.spawnDelay == nil) then
					spawnTime = spawnTime + ent.realvalue / 25
				end
			end
			if (ent.population ~= nil) then
				power = power + ent.population
			end
			if (ent.Pos ~= nil) then
				sizePenalty = sizePenalty + (ent.Pos):LengthSqr() / 1000
			end
			if (ent.spawnDelay ~= nil) then
				spawnTime = spawnTime + ent.spawnDelay * 2
			end
		end
		locPly.contrapCost = cost
		locPly.contrapPower = power
		locPly.selectedAssembler:SetNWFloat("slowThinkTimer", spawnTime)

		-- Make the contrap
		StartBuildingContraption(locPly.selectedAssembler, locPly.selectedAssembler.file, locPly.contrapCost, locPly.contrapPower)
	end

	if locPly.cmenuframe ~= nil then return end
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

function TOOL:DrawHUD()
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

	local mx = gui.MouseX()
	if (mx == 0) then mx = ScrW() / 2 end
	local my = gui.MouseY()
	if (my == 0) then my = ScrH() / 2 end

	local cbx, cby = chat.GetChatBoxPos()
	local cbw, cbh = chat.GetChatBoxSize()

	if (pl.cutsceneOpacity > 0) then
		draw.RoundedBox( 5, cbx, cby + 30, cbw-30, cbh-80, Color(0,0,0,pl.cutsceneOpacity) )
	end

	if (GetConVar( "mw_admin_cutscene" ):GetBool()) then
		surface.SetFont("DermaLarge")
		surface.SetTextColor( 255, 255, 255, 150 )
		surface.SetTextPos( mx-103, my-17 )
		surface.DrawText( "Toolgun Disabled" )
	elseif (not cvars.Bool("mw_admin_playing")) then
		surface.SetFont("DermaLarge")
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( mx-50, my-17 )
		surface.DrawText( "PAUSED" )
		draw.DrawText( "R: Open menu", "DermaLarge", x + w-10, y-140, color_white, TEXT_ALIGN_RIGHT )
	else
		local pos = 1
		local teamColor = cvars.Number("mw_team")
		local size = 50
		for i = 1, 8 do
			if (teamgrid[i][teamColor] == true) then
				draw.RoundedBox( 0, x-pos*size, y-size, size, size, Color(20,20,20,255) )
				draw.RoundedBox( 5, x + 4-pos*size, y + 4-size, size-8, size-8, mw_team_colors[i] )
				pos = pos + 1
			end
		end
		if (pos > 1) then
			draw.RoundedBox( 0, x-80, y-size-35, 80, 35, Color(20,20,20,255) )
			draw.DrawText( "Allies:", "DermaLarge", x-40, y-size-32, color_white, TEXT_ALIGN_CENTER )
		end

		pl.mw_action = cvars.Number("mw_action")

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
			if (cvars.Number("mw_team") ~= 0) then
				teamColor = mw_team_colors[cvars.Number("mw_team")]
			end
			if (unit_id > 0) then
				local w = 300
				local h = 280
				local x = ScrW() - w
				local y = ScrH() - h

				draw.RoundedBox( 15, x, y, w, h, teamColor )
				draw.RoundedBox( 10, x + 10, y + 10, w-20, h-20, Color(0,0,0,230) )
				draw.DrawText( mw_units[unit_id].name, "DermaLarge", x + w / 2, y + 30, color_white, TEXT_ALIGN_CENTER )
				for i = 1, mw_units[unit_id].population do
					draw.RoundedBox( 1, x + w / 2-(mw_units[unit_id].population+1) / 2*15+i*15-7, y + 65, 10, 10, color_white )
				end
				if (freeunits) then
					draw.DrawText( "- Infinite Water -", "Trebuchet18", x + w / 2, y + 120, color_white, TEXT_ALIGN_CENTER )
					draw.DrawText( "To enable water cost go to the admin menu", "Trebuchet18", x + w / 2, y + 140, color_white, TEXT_ALIGN_CENTER )
				else
					draw.DrawText( "Cost: " .. mw_units[unit_id].cost, "DermaLarge", x + 30, y + 90, color_white, TEXT_ALIGN_LEFT )
					if (mw_units[unit_id].welded_cost ~= -1) then
						draw.DrawText( "Welded Cost (RMB): " .. mw_units[unit_id].welded_cost, "Trebuchet18", x + 30, y + 130, color_white, TEXT_ALIGN_LEFT )
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

				if (cvars.Bool("mw_unit_option_welded") and mw_units[unit_id].welded_cost ~= -1) then
					draw.RoundedBox( 10, mx-100, my + 40, 200, 45, Color(0,0,0,100) )
					draw.DrawText( "Spawning " .. mw_units[unit_id].name, "Trebuchet24", mx, my + 40, Color(255,255,0,255), TEXT_ALIGN_CENTER )
					draw.DrawText( "as turret", "Trebuchet24", mx, my + 60, Color(255,255,0,255), TEXT_ALIGN_CENTER )

					draw.RoundedBox( 2, mx-21, my-3, 17, 5, Color(50,50,50))
					draw.RoundedBox( 2, mx + 4, my-3, 17, 5, Color(50,50,50))
					draw.RoundedBox( 2, mx-4, my-31-math.sin(CurTime() * 3) * 10, 7, 12, Color(50,50,50))
					draw.RoundedBox( 1, mx-20, my-2, 15, 3, teamColor)
					draw.RoundedBox( 1, mx + 5, my-2, 15, 3, teamColor)
					draw.RoundedBox( 1, mx-3, my-30-math.sin(CurTime() * 3) * 10, 5, 10, teamColor)
				else
					draw.RoundedBox( 10, mx-160, my + 40, 320, 25, Color(0,0,0,100) )
					draw.DrawText( "Spawning " .. mw_units[unit_id].name, "Trebuchet24", mx, my + 40, Color(255,255,255,200), TEXT_ALIGN_CENTER )
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
			draw.DrawText( mw_base_props[prop_id].name, "DermaLarge", x + w-20, y + 70, color_white, TEXT_ALIGN_RIGHT )
			draw.DrawText( "HP: " .. mw_base_props[prop_id].hp, "DermaLarge", x + 30, y + 100, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( "Cost: " .. mw_base_props[prop_id].cost, "DermaLarge", x + 30, y + 130, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( "Water: " .. tostring(pl.mw_credits), "DermaLarge", x + 30, y + 180, color_white, TEXT_ALIGN_LEFT ) -- changed
		elseif pl.mw_action == 4 then
			local teamColor = mw_team_colors[cvars.Number("mw_team")] -- self:GetOwner().mw_hudColor
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
			local teamColor = mw_team_colors[cvars.Number("mw_team")] -- pl.mw_hudColor -- changed
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
			local teamColor = mw_team_colors[cvars.Number("mw_team")]--pl.mw_hudColor -- changed
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
	teamgrid = net.ReadTable()
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