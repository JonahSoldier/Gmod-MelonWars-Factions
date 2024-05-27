AddCSLuaFile()

local function isInRangeLoop( vector, teamIndex, entClass, buildDist )
	for _, v in ipairs( ents.FindByClass( entClass ) ) do
		if vector:Distance( v:GetPos() ) < buildDist and v:GetNWInt( "mw_melonTeam", 0 ) == teamIndex then
			return true
		end
	end
end

function MelonWars.isInRange( vector, teamIndex ) -- Why does this not just use findinsphere?
	local canBuild = false

	if isInRangeLoop( vector, teamIndex, "ent_melon_main_building", 800 ) then return true end
	if isInRangeLoop( vector, teamIndex, "ent_melon_station", 250 ) then return true end
	if isInRangeLoop( vector, teamIndex, "ent_melon_main_unit", 250 ) then return true end
	if isInRangeLoop( vector, teamIndex, "ent_melon_main_building_grand_war", 1600 ) then return true end

	local foundPoints = ents.FindByClass( "ent_melon_outpost_point" )

	for _, v in ipairs( foundPoints ) do
		if not canBuild and vector:Distance(v:GetPos()) < 600 then
			if MelonWars.teamGrid == nil or MelonWars.teamGrid[v:GetNWInt( "capTeam", 0 )] == nil or MelonWars.teamGrid[v:GetNWInt( "capTeam", 0 )][teamIndex] == nil then
				canBuild = v:GetNWInt( "capTeam", 0 ) == teamIndex
			elseif v:GetNWInt( "capTeam", 0 ) == teamIndex or MelonWars.teamGrid[v:GetNWInt( "capTeam", 0 )][teamIndex] then
				canBuild = true
			end
		end
	end

	return canBuild
end