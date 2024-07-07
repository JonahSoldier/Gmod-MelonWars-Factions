ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "ZoneTeam")
	self:NetworkVar( "Float", 1, "ZoneRadius")
end