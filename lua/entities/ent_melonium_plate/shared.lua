AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Category = "MelonWars"

ENT.PrintName = "Melonium Plate"
ENT.Author = "JonahSoldier"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Editable = true
ENT.IconOverride = "spawnicons/models/hunter/plates/plate32x32.png"

ENT.AdminOnly = true --Can be set to an error model, which makes it hard to get rid of. Probably not something you want random players doing.

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "MWModel", {
		 KeyName = "mwModel",
		 Edit = {
			title = "Model",
			type = "Generic"
			--waitforenter = true --For some reason this makes it require you to input the text twice. Using SetModel without a valid model doesn't seem to cause issues so we're using that.
		}
	} )

	if SERVER then
		self:NetworkVarNotify( "MWModel", function(_, _, new)
			self:SetModel(new)
			self:PhysicsInit( SOLID_VPHYSICS )
			self:GetPhysicsObject():EnableMotion(false)
		end )
		timer.Simple(0, function()
			self:SetMWModel(self:GetModel())
		end)
	end
end