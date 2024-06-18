local function MW_Initialize()
	MelonWars.teamColors[0] = Color( 100, 100, 100, 255 )

	-- Create a file for contraption validation
	local text = util.Compress( util.TableToJSON( MelonWars.units ) )
	file.CreateDir( "melonwars/validation" )
	file.Write( "melonwars/validation/unitValues.txt", text )
end
hook.Add( "Initialize", "MelonWars_InitializeTeams", MW_Initialize )

local function MW_AddTabs()
	spawnmenu.AddToolTab( "MelonWars", "#Melonwarstab", "icon16/wrench.png" )
end
hook.Add( "AddToolMenuTabs", "MelonWars_AddTabs", MW_AddTabs ) -- Hook the Tab to the Spawn Menu

local function spawn( ply )
	ply.mw_hover = 0
	ply.mw_menu = 0
	ply.mw_selectTimer = 0
	ply.mw_spawntimer = 0
	ply.mw_frame = nil
	ply.mw_credits = 2000
	for _, v in ipairs( player.GetAll() ) do
		net.Start( "UpdateClientTeams" )
			net.WriteTable( MelonWars.teamGrid )
		net.Send( ply )
	end
	util.PrecacheModel( "models/hunter/tubes/circle2x2.mdl" )
end
hook.Add( "PlayerInitialSpawn", "MelonWars_InitSpawnData", spawn )


hook.Add( "EntityTakeDamage", "MelonWars_EntTakeDmg", function( target, dmginfo )
	if not IsValid( target and dmginfo ) then return end
	if dmginfo:GetAttacker():GetClass() == "player" then return end
	if target:GetNWInt("propHP", -1) ~= -1 then
		target:SetNWInt( "propHP", target:GetNWInt( "propHP", 1 ) - dmginfo:GetDamage() )
		if (target:GetNWInt( "propHP", 1) <= 0) then
			local effectdata = EffectData()
			effectdata:SetOrigin( target:GetPos() )
			util.Effect( "Explosion", effectdata )
			target:Remove()
		end
	end
	if target.chaseStance then
		target.chasing = true
		target.targetEntity = dmginfo:GetAttacker()
		if target.targetEntity.owner ~= nil then
			target.targetEntity = target.targetEntity.owner
		end
	end
end )

hook.Add( "InitPostEntity", "MelonWars_StartLoad", function()
	MelonWars.teamGrid = {}          -- create the matrix
	for i = 1, 8 do
		MelonWars.teamGrid[i] = {}     -- create a new row
		for j = 1, 8 do
			MelonWars.teamGrid[i][j] = false
		end
	end
end )

local function MWSign( x )
	if x > 0 then return 1 end
	if x < 0 then return -1 end
	return 0
end

local function MW_Move( ply, mv )
	if not IsValid( ply.controllingUnit ) then return end
	local cUnit = ply.controllingUnit

	if mv:GetForwardSpeed() ~= 0 or mv:GetSideSpeed() ~= 0 then
		local pos = cUnit:GetPos() + ( mv:GetMoveAngles():Forward() * MWSign( mv:GetForwardSpeed() ) + mv:GetMoveAngles():Right() * MWSign( mv:GetSideSpeed() ) ) * 15
		cUnit:SetVar( "targetPos", pos )
		cUnit:SetNWVector( "targetPos", pos )
		cUnit:SetVar( "moving", true )
	end

	if mv:KeyDown(IN_JUMP) then
		cUnit:Unstuck()
	end

	return true
end
hook.Add( "Move", "MelonWars_CalcView", MW_Move )