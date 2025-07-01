

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Category = "MelonWars"

ENT.PrintName = "Buildspeed Multiplier"
ENT.Author = "JonahSoldier"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.IconOverride = "spawnicons/models/hunter/blocks/cube025x025x025.png"

ENT.AdminOnly = true
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "SpeedMult", {
		 KeyName = "speedmul",
		 Edit = {
			type = "Float",
			min = 0,
			max = 5,
			title = "Time Multiplier"
		}
	} )
	if SERVER then
		self:SetSpeedMult(1)
	end
end