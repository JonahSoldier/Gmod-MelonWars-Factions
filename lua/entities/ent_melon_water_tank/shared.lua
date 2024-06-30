ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Category = "MelonWars"

ENT.PrintName = "Water Tank"
ENT.Author = "Marum"
ENT.Contact = "don`t"
ENT.Purpose = "Annoy"
ENT.Instructions = "Spawn a whole bunch"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "WaterValue", {
		 KeyName = "waterval",
		 Edit = {
			type = "Int",
			min = 1,
			max = 10000,
			title = "Water Value"
		}
	} )
	if SERVER then
		self:SetWaterValue(GetConVar("mw_water_tank_value"):GetInt())
	end
end

if SERVER then --As far as I'm aware there isn't any direct way to restrict editing of specific variables or specific entities, so we're doing it this way.
	hook.Add("CanEditVariable", "MW_RestrictWaterTankEditing", function( ent, ply)
		if ent:GetClass() == "ent_melon_water_tank" then
			return ply:IsAdmin()
		end
	end)
end