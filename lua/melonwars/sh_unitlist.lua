AddCSLuaFile()
--[[
	This file determines the details of units as they appear in the melon-wars tool.
	It is shared, as things like spawn-time and cost need to be known by the server as well.
	The rest is either visual or directly tied in with the tool.
	If you want to edit unit stats like HP, speed, their *actual* model, etc then edit the entity files.
--]]

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

--local unitCount = 88
local unitCount = 84
MelonWars.units = {}
MelonWars.unitCount = unitCount
local u = nil
for i = 1, unitCount do
	MelonWars.units[i] = Unit()
end

local function BarracksText( number, max )
	return "This is a building that produces a " .. MelonWars.units[number].name .. " every " .. tostring(MelonWars.units[number].spawn_time * 3) .. " seconds, up to " .. max .. " at any given time, at half the price. Select this building and command it to move somewhere to set a rally point for its deployed units. Look at it and press E to toggle it on and off."
end
local button_energy_color = Color(255, 255, 80)
local button_barrack_color = Color(200, 255, 255)

local indicator_attack_colour = Color(255, 0, 0, 100)
local indicator_utility_colour = Color(0, 0, 255, 100)
local indicator_unitsRequired_colour = Color(0, 255, 0, 100)

local i = 0

i = i + 1
u = MelonWars.units[i]
u.name 			= "Marine"
u.class 		= "ent_melon_marine"
u.cost 			= 75
u.welded_cost 	= 20
u.population 	= 1
u.spawn_time 	= 2
u.description 	= [[The basic unit.]]
u.model 		= "models/props_junk/watermelon01.mdl"

i = i + 1
u = MelonWars.units[i]
u.name 			= "Medic"
u.class 		= "ent_melon_medic"
u.cost 			= 180
u.welded_cost 	= 100
u.population 	= 1
u.spawn_time 	= 3
u.description 	= [[The healer of the group, always good to have one around.]]
u.model 		= "models/props_junk/watermelon01.mdl"

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.name 			= "Bomb"
u.class 		= "ent_melon_bomb"
u.cost 			= 400
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 5
u.description 	= [[Explodes on proximity after 0.3 seconds. Send some cannon fodder in front to keep it alive until it reaches its target. Watch out for friendly fire!]]
u.model 		= "models/props_phx/misc/soccerball.mdl"

i = i + 1
u = MelonWars.units[i]
u.name 			= "Gunner"
u.class 		= "ent_melon_gunner"
u.cost 			= 500
u.welded_cost 	= 150
u.population 	= 2
u.spawn_time 	= 6
u.description 	= [[Equipped with a minigun, this tougher and slower unit will shoot faster the longer it holds down the trigger. It has some spread, so try getting up close.]]
u.model 		= "models/Roller.mdl"

i = i + 1
u = MelonWars.units[i]
u.name 			= "Missiles"
u.class 		= "ent_melon_missiles"
u.cost 			= 500
u.welded_cost 	= 175
u.population 	= 2
u.spawn_time 	= 5
u.description 	= [[This unit launches medium range homing missiles to suppress hordes of weak units. Good for dealing constant group damage.]]
u.model 		= "models/xqm/rails/trackball_1.mdl"

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.name 			= "Hot Shot"
u.class 		= "ent_melon_hotshot"
u.cost 			= 1000
u.welded_cost 	= 750
u.population 	= 3
u.spawn_time 	= 5
u.description 	= [[Shoots a fan of incendiary bullets in a wide spread. Useful against spread out squads, not as effective against clumped up enemies.]]
u.model 		= "models/xqm/afterburner1.mdl"
u.offset 		= Vector(0,0,10)

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.code 			= "void"
u.name 			= "Raider"
u.class 		= "ent_melon_void_raider"
u.cost 			= 400
u.welded_cost 	= -1
u.population 	= 2
u.spawn_time 	= 5
u.angle 		= Angle(0, 0, 180)
u.offset 		= Vector(0,0,7)
u.description 	= [[A backpack-wearing void unit that can capture enemy buildings of all sorts. Useful for causing chaos in enemy defensive lines or taking over valuable infrastructure.]]
u.model 		= "models/props_junk/MetalBucket01a.mdl"

i = i + 1
u = MelonWars.units[i]
u.code 			= "full"
u.name 			= "Buck"
u.class 		= "ent_melon_buck"
u.cost 			= 500
u.welded_cost 	= 250
u.population 	= 3
u.spawn_time 	= 20
u.offset 		= Vector(0,0,5)
u.description 	= [[A slow trooper that fires a shotgun blast in a tight spread. Cost-effective and very strong, but pretty slow to spawn.]]
u.model 		= "models/props_junk/plasticbucket001a.mdl"

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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

--[[
i = i + 1
u = MelonWars.units[i]
u.code 			= "--banned--"
u.name 			= "Forcefield"
u.class 		= "ent_melon_forcefield"
u.cost 			= 0
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 20000
u.offset        = Vector(0,0,42)
--u.description 	= [[A forcefield that blocks bullets from the enemy team.]]
--u.model 		= "models/hunter/tubes/tube4x4x2to2x2.mdl"
--]]

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
MelonWars.unitlist_firstBuilding = i --------------------------------- First building


u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u.indRingRadius = 150
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
u.name 			= "Turret"
u.class 		= "ent_melon_turret"
u.cost 			= 350
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 10
u.description 	= [[Static defense, a heavy machinegun with good health and firepower]]
u.model 		= "models/combine_turrets/ground_turret.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(180, 180, 0)
u.indRingRadius = 500
u.indRingColour = indicator_attack_colour

i = i + 1
u = MelonWars.units[i]
u.name 			= "Shredder"
u.class 		= "ent_melon_shredder"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 5
u.description 	= [[A set of spinning blades, used to recycle melons, get resources back, and sometimes make smoothies. It has low health, so use as defense at your own risk. (It doesn't give credits for friendly free units)]]
u.model 		= "models/props_c17/TrapPropeller_Blade.mdl"
u.offset 		= Vector(0,0,0)
u.indRingRadius = 60
u.indRingColour = indicator_attack_colour

i = i + 1
u = MelonWars.units[i]
u.code 			= "prot"
u.name 			= "Electrified Debris"
u.class 		= "ent_melon_teslarods"
u.cost 			= 150
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 8
u.description 	= [[A haphazard spread of metal rods connected to an underground power source. Will zap units passing through it dealing a small amount of damage. Can only be cleared by explosives and other AOE weapons.]]
u.model 		= "models/props_rooftop/antennaclusters01a.mdl"
u.offset 		= Vector(0,0,60)
u.angle 		= Angle(0, 0, 0)
u.indRingRadius = 80
u.indRingColour = indicator_attack_colour

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u.indRingRadius = 250
u.indRingColour = indicator_unitsRequired_colour

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.name 			= "Radar"
u.class 		= "ent_melon_radar"
u.cost 			= 400
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 5
u.description 	= [[Will alert your team of nearby units no matter where you are.]]
u.model 		= "models/props_trainstation/trainstation_column001.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0, 0, 0)
u.indRingRadius = 1000
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
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
u.indRingRadius = 250
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
u.code 			= "prot"
u.name 			= "Energy Siphon"
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
u.indRingRadius = 250
u.indRingColour = indicator_unitsRequired_colour

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u.indRingRadius = 400
u.indRingColour = indicator_attack_colour

i = i + 1
u = MelonWars.units[i]
u.code 			= "full"
u.name 			= "Particle Tower"
u.class 		= "ent_melon_particle_tower"
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
u.indRingRadius = 1600
u.indRingColour = indicator_attack_colour

i = i + 1
u = MelonWars.units[i]
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
u.isBonusUnit   = true

i = i + 1
u = MelonWars.units[i]
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
u.indRingRadius = 5000
u.indRingColour = indicator_attack_colour

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u.indRingRadius = 50
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
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
u.indRingRadius = 750
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
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
u.indRingRadius = 250
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
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
u.indRingRadius = 100
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
u.code 			= "full"
u.name 			= "Point Defence"
u.class 		= "ent_melon_point_defence"
u.cost 			= 750
u.welded_cost 	= -1
u.population 	= 3
u.spawn_time 	= 25
u.description 	= [[A Full defence tower that zaps and destroys incoming projectiles. Consumes 75 energy per projectile destroyed.]]
u.model 		= "models/props_docks/channelmarker02a.mdl"
u.offset 		= Vector(0,0,23.5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange
u.indRingRadius = 300
u.indRingColour = indicator_utility_colour

i = i + 1
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.code 			= "void"
u.name 			= "Raider Fabrication Platform"
u.class 		= "ent_melon_barracks_void_raider"
u.cost 			= 500 --TODO: This seems way too low. I don't remember ever using raider barracks so maybe there was a reason for them to be this cheap? It could've just been accidental or overlooked.
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.code 			= "prot"
u.name 			= "Molotov Depot"
u.class 		= "ent_melon_barracks_molotov"
u.cost 			= 900
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description   = BarracksText (17, 3)
u.model 		= "models/props_wasteland/laundry_washer001a.mdl"
u.offset 		= Vector(0,0,30)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i + 1
u = MelonWars.units[i]
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
MelonWars.unitlist_firstEnergy = i ----------------------------------First energy


u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
u.name 			= "Steam Generator"
u.class 		= "ent_melon_energy_steam_plant"
u.cost 			= 2250
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Steam generators can be turned on and off using E. When on, they transform 5 Water into 20 Energy per second]]
u.model 		= "models/mechanics/roboticslarge/claw_hub_8l.mdl"
u.offset 		= Vector(0,0,50)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = MelonWars.units[i]
u.name 			= "Nuclear Plant"
u.class 		= "ent_melon_energy_nuclear_plant"
u.cost 			= 8000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Nuclear plants can be turned on and off using E. When on, they transform a 15 Water to 100 Energy per second. It blows up big when destroyed]]
u.model 		= "models/props_combine/combine_booth_med01a.mdl"
u.offset 		= Vector(0,0,20)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i + 1
u = MelonWars.units[i]
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
MelonWars.unitlist_firstContraption = i ---------------------------- First Contraption


u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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
u = MelonWars.units[i]
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

local uCID = {}
MelonWars.classIDDict = uCID

for j, unit in ipairs(MelonWars.units) do
	uCID[unit.class] = j
end



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
MelonWars.baseProps = {}
--u = nil
for j = 1, basePropCount do
	MelonWars.baseProps[j] = BaseProp()
end

i = 0

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Blast Door"
u.model = "models/props_lab/blastdoor001c.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 200
u.hp = 150

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Barricade"
u.model = "models/props_wasteland/barricade002a.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,90,0)
u.cost = 15
u.hp = 40

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Fence"
u.model = "models/props_wasteland/wood_fence01a.mdl"
u.offset = Vector(0,0,40)
u.angle = Angle(0,90,0)
u.cost = 40
u.hp = 100

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Pallet"
u.model = "models/props_junk/wood_pallet001a.mdl"
u.offset = Vector(0,0,32)
u.angle = Angle(90,0,0)
u.cost = 25
u.hp = 50

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Brick"
u.model = "models/hunter/blocks/cube05x1x05.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 35

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Half Block"
u.model = "models/hunter/blocks/cube1x1x05.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,0,0)
u.cost = 35
u.hp = 50

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Block"
u.model = "models/hunter/blocks/cube1x1x1.mdl"
u.offset = Vector(0,0,24)
u.angle = Angle(0,0,0)
u.cost = 75
u.hp = 100

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Half Platform"
u.model = "models/hunter/blocks/cube2x2x05.mdl"
u.offset = Vector(47,0,10.5)
u.angle = Angle(0,0,0)
u.cost = 115
u.hp = 150

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Platform"
u.model = "models/hunter/blocks/cube2x2x1.mdl"
u.offset = Vector(47,0,24)
u.angle = Angle(0,0,0)
u.cost = 150
u.hp = 200

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Concrete Barrier"
u.model = "models/props_c17/concrete_barrier001a.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 75
u.hp = 150

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Wall"
u.model = "models/hunter/blocks/cube2x2x05.mdl"
u.offset = Vector(0,0,48)
u.angle = Angle(90,0,0)
u.cost = 100
u.hp = 175

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Long Wall"
u.model = "models/hunter/blocks/cube1x4x05.mdl"
u.offset = Vector(0,0,24)
u.angle = Angle(90,0,0)
u.cost = 100
u.hp = 175

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Flat Platform"
u.model = "models/hunter/plates/plate2x2.mdl"
u.offset = Vector(47,0,-2.5)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 35

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Short Ramp"
u.model = "models/hunter/plates/plate1x2.mdl"
u.offset = Vector(23,0,4.5)
u.angle = Angle(-17,0,0)
u.cost = 25
u.hp = 25

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Slim Half Ramp"
u.model = "models/hunter/plates/plate1x2.mdl"
u.offset = Vector(33,0,7.3)
u.angle = Angle(0,90,-17)
u.cost = 25
u.hp = 25

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Half Ramp"
u.model = "models/hunter/plates/plate2x2.mdl"
u.offset = Vector(33,0,7.3)
u.angle = Angle(0,90,-17)
u.cost = 50
u.hp = 40

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Slim Full Ramp"
u.model = "models/hunter/triangles/2x1x1.mdl"
u.offset = Vector(48.3,0,23.1)
u.angle = Angle(0,90,0)
u.cost = 75
u.hp = 75

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Barrel"
u.model = "models/props_c17/oildrum001.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 25
u.hp = 50

i = i + 1
u = MelonWars.baseProps[i]
u.name = "3D Frame"
u.model = "models/props_phx/construct/metal_wire1x2x2b.mdl"
u.offset = Vector(-70,24,0)
u.angle = Angle(0,0,0)
u.cost = 20
u.hp = 20

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Railing"
u.model = "models/PHXtended/bar2x.mdl"
u.offset = Vector(2,48,5.5)
u.angle = Angle(90,180,0)
u.cost = 8
u.hp = 5

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Half Pipe"
u.model = "models/props_phx/construct/metal_plate_curve180.mdl"
u.offset = Vector(-46,0,48)
u.angle = Angle(180,0,0)
u.cost = 50
u.hp = 75

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Pole"
u.model = "models/props_docks/dock01_pole01a_128.mdl"
u.offset = Vector(0,0,64)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 15

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Disk"
u.model = "models/props_phx/construct/metal_angle360.mdl"
u.offset = Vector(-48,0,0)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 15

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Half Disk"
u.model = "models/props_phx/construct/metal_angle180.mdl"
u.offset = Vector(-48,0,0)
u.angle = Angle(180,0,0)
u.cost = 8
u.hp = 8

i = i + 1
u = MelonWars.baseProps[i]
u.name = "Stilt"
u.model = "models/props_docks/dock01_pole01a_128.mdl"
u.offset = Vector(0,0,-64)
u.angle = Angle(0,0,0)
u.cost = 25
u.hp = 25