AddCSLuaFile()


local function isClassInRange(pos, teamIndex, entClass, range)
	local rngSqr = range^2
	for _, v in ipairs( ents.FindByClass( entClass ) ) do
		if pos:DistToSqr( v:GetPos() ) < rngSqr then
			local vTeam = v:GetNWInt( "mw_melonTeam", 0 )
			if vTeam == teamIndex or MelonWars.teamGrid[vTeam][teamIndex] then
				return true
			end
		end
	end
	return false
end

function MelonWars.isInRange( pos, teamIndex )
	--Not a huge fan of this being hardcoded, but I can't be bothered to restructure it.
	local classes = {
		["ent_melon_main_building"] = 800,
		["ent_melon_station"] = 250,
		["ent_melon_main_unit"] = 250,
		["ent_melon_main_building_grand_war"] = 1600,
	}

	for k, v in pairs(classes) do
		if isClassInRange(pos, teamIndex, k, v) then
			return true
		end
	end

	local foundPoints = ents.FindByClass( "ent_melon_outpost_point" )
	local rngSqr = 600^2
	for _, v in ipairs( foundPoints ) do
		if pos:DistToSqr( v:GetPos() ) < rngSqr then
			local vTeam =  v:GetNWInt( "capTeam", 0 )
			local teamGridTeam = MelonWars.teamGrid[vTeam]
			if vTeam == teamIndex or (teamGridTeam and teamGridTeam[teamIndex]) then
				return true
			end
		end
	end

	return false
end

function MelonWars.noEnemyNear( pos, teamIndex )
	local foundEnts = ents.FindInSphere( pos, 300 )

	for _, v in ipairs( foundEnts ) do
		if v.Base == "ent_melon_base"then
			local vTeam = v:GetNWInt( "mw_melonTeam", 0 )
			if vTeam ~= 0 and vTeam ~= teamIndex and not MelonWars.teamGrid[vTeam][teamIndex] then
				return false
			end
		end
	end

	return true
end

function MelonWars.unitCost(unitIndex, attach)
	local cost
	attach = tobool(attach)

	if attach then
		cost = MelonWars.units[unitIndex].welded_cost
	else
		cost = MelonWars.units[unitIndex].cost
	end

	if (cost == -1) then
		cost = MelonWars.units[unitIndex].cost
		attach = false
	end

	attach = attach or MelonWars.units[unitIndex].contraptionPart
	attach = attach or (unitIndex >= MelonWars.unitlist_firstBuilding and unitIndex < MelonWars.unitlist_firstContraption)

	return cost, attach
end

function MelonWars.canSpawn( unitIndex, attach, mwTeam, position, pl, attachEnt )
	if unitIndex <= 0 then
		print(tostring(pl) .. " tried to spawn a non-existent unit: " .. tostring(unitIndex) )
		return false
	end

	if not cvars.Bool("mw_admin_playing") then
		pl:PrintMessage( HUD_PRINTTALK, "== The admin has paused the game! ==" )
		return false
	end

	if not(cvars.Bool("mw_admin_allow_free_placing") or MelonWars.noEnemyNear(position, mwTeam)) then
		pl:PrintMessage( HUD_PRINTTALK, "== Enemy too close! ==" )
		return false
	end

	local units = (SERVER and MelonWars.teamUnits[mwTeam]) or pl.mw_units or 0

	if units + MelonWars.units[unitIndex].population > cvars.Number("mw_admin_max_units") then
		pl:PrintMessage( HUD_PRINTTALK, "== Power max reached! ==" )
		return false
	end

	if not(pl.canPlace or SERVER) then --TODO: Should be checked on server too, but I'll do that later.
		pl:PrintMessage( HUD_PRINTTALK, "== What you're trying to spawn overlaps with something else! ==" )
		return false
	end

	local cost
	cost, attach = MelonWars.unitCost(unitIndex, attach)
	local credits = (SERVER and MelonWars.teamCredits[mwTeam]) or pl.mw_credits or 0

	if not(credits >= cost or not cvars.Bool("mw_admin_credit_cost") or mwTeam == 0) then
		pl:PrintMessage( HUD_PRINTTALK, "== Not enough resources! ==" )
		return false
	end

	if attach then
		--local canFloorSpawn = MelonWars.units[unit_index].spawnable_on_floor or not trace.Entity:IsWorld()
		--canFloorSpawn isn't super useful, given most matches happen on prop maps.
		local attClass = attachEnt:GetClass()
		local notPointOrWater = attClass ~= "ent_melon_outpost_point" and attClass ~= "ent_melon_cap_point" and attClass ~= "ent_melon_water_tank"
		local attTeam = attachEnt:GetNWInt("mw_melonTeam", 0)
		local entHasTeam = attTeam == mwTeam or attTeam == 0

		if not(notPointOrWater and entHasTeam) then
			pl:PrintMessage( HUD_PRINTTALK, "== Can't attach units onto non legalized props! ==" )
			return false
		end
	end

	if not(cvars.Bool("mw_admin_allow_free_placing") or MelonWars.units[unitIndex].buildAnywere or MelonWars.isInRange(position, mwTeam) or mwTeam == 0) then
		pl:PrintMessage( HUD_PRINTTALK, "== Too far from an outpost! ==" )
		return false
	end

	if attachEnt then
		if attachEnt.Base == "ent_melon_base" then
			return false
		end

		local attClass = attachEnt:GetClass()
		if attClass == "ent_melon_wall" and (not attach and MelonWars.units[unitIndex].welded_cost ~= -1 and unitIndex < MelonWars.unitlist_firstBuilding ) then
			pl:PrintMessage( HUD_PRINTTALK, "== Cant spawn mobile units directly on buildings! ==" )
			return false
		end
	end

	return true
end

function MelonWars.sameTeam(team1, team2)
	if (team1 == team2) then
		return true
	end
	if (team1 == 0 or team2 == 0) then
		return false
	end
	return MelonWars.teamGrid[team1][team2]
end