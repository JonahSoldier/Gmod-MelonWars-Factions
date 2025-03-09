if engine.ActiveGamemode() ~= "sandbox" then return end
hook.Add( "Initialize", "MelonWars_InitializeTeams", function()
	MelonWars.teamColors[0] = Color( 100, 100, 100, 255 )
end )

hook.Add( "AddToolMenuTabs", "MelonWars_AddTabs", function()
	spawnmenu.AddToolTab( "MelonWars", "#Melonwarstab", "icon16/wrench.png" )
end ) -- Hook the Tab to the Spawn Menu

hook.Add( "PlayerInitialSpawn", "MelonWars_InitSpawnData", function( ply )
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
end)

local function MelonWars_EntTakeDmg(target, dmgInfo)
	if not IsValid( target and dmgInfo ) then return end
	if dmgInfo:GetAttacker():IsPlayer() then return end
	if target:GetNWInt("propHP", -1) ~= -1 then
		target:SetNWInt( "propHP", target:GetNWInt( "propHP", 1 ) - dmgInfo:GetDamage() )
		if (target:GetNWInt( "propHP", 1) <= 0) then
			local effectdata = EffectData()
			effectdata:SetOrigin( target:GetPos() )
			util.Effect( "Explosion", effectdata )
			target:Remove()
		end
	end
	if target.chaseStance then
		target.chasing = true
		target.targetEntity = dmgInfo:GetAttacker()
		if target.targetEntity.owner ~= nil then
			target.targetEntity = target.targetEntity.owner
		end
	end
end

hook.Add( "EntityTakeDamage", "MelonWars_EntTakeDmg", MelonWars_EntTakeDmg)

hook.Add( "InitPostEntity", "MelonWars_StartLoad", function()
	MelonWars.teamGrid = {}		-- create the matrix
	for i = 1, 8 do
		MelonWars.teamGrid[i] = {}	-- create a new row
		for j = 1, 8 do
			MelonWars.teamGrid[i][j] = false
		end
	end
end )

timer.Simple(0, function()
	if not CPPI then return end

	--Hooks are executed in alphabetical order, string.char(0) forces us to run *first*
	hook.Add( "EntityTakeDamage", string.char(0) .. "MelonWars_DmgProtect_Bypass", function( target, dmgInfo )
		if dmgInfo:GetAttacker() == target then return end

		local targetTbl = target:GetTable()
		if not(targetTbl.Base == "ent_melon_base" or targetTbl.Base == "ent_melon_energy_base" or targetTbl.Base == "ent_melon_prop_base") then return end

		target:OnTakeDamage(dmgInfo) --We need to do this here, because it'll be screwed up by changing the attacker.
		target.mw_suppressOnTakeDamage = true --So that we don't run OnTakeDamage twice

		dmgInfo:SetInflictor( target )
		dmgInfo:SetAttacker( target )

		target:TakeDamageInfo(dmgInfo) --trigger a new damage event, but with the entity itself as the inflictor/attacker

		return true --suppress this damage event
	end)

end)

timer.Simple(0, function() --Delaying it like this isn't ideal but I can't be bothered to re-organize at the moment. This is so that it runs after the tool actually sets up the convars.
	local mw_admin_playing_cv = GetConVar("mw_admin_playing")
	local mw_net_perf_cv = GetConVar("mw_admin_network_performance_mode")
	hook.Add("Think", "MelonWars_cacheCvars", function() --TODO: We could probably just set these values when the convars change. Don't know why I thought this needed to be in a think hook.
		MelonWars.admin_playing = mw_admin_playing_cv:GetBool()
		MelonWars.net_perf_mode = mw_net_perf_cv:GetBool()
	end)
end)

--[[
local function MWSign( x )
	if x > 0 then return 1 end
	if x < 0 then return -1 end
	return 0
end

hook.Add( "Move", "MelonWars_CalcView", function( ply, mv )
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
end )
--]]