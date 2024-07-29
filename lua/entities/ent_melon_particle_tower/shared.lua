ENT.Type = "anim"
ENT.Base = "ent_melon_energy_base"

ENT.Spawnable = false
ENT.AdminSpawnable = false


function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Fired")

	if CLIENT then
		self:NetworkVarNotify("Fired", function(ent, name, old, new)
			if not tobool(new) or new == old then return end

			self.lastAttack = CurTime()
			self:AttackParticle()
		end)
	end
end