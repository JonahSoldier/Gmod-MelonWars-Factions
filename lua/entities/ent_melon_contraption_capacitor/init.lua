AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.birth = CurTime()

	self.modelString = "models/props_junk/TrashBin01a.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.slowThinkTimer = 5

	self.population = 0

	self.captureSpeed = 0

	self.maxHP = 50
	self.shotOffset = Vector(0,0,15)

	self:Setup()

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 1000)

end


function ENT:SlowThink ( ent )
	local welds = constraint.FindConstraints( self, "Weld" )
	local suppliedEntities = {}
	for i, v in ipairs(welds) do
		local targEnt = (v.Ent1 ~= self and v.Ent1) or v.Ent2

		if not table.HasValue(suppliedEntities, targEnt) then
			if targEnt:GetClass() == "ent_melon_contraption_capacitor" then
				if targEnt.batteryConnections then
					for j, tEnt in ipairs(targEnt.batteryConnections) do
						if not table.HasValue(suppliedEntities, tEnt) then
							table.insert(suppliedEntities, tEnt)
						end
					end
				end
			elseif targEnt:GetNWInt("maxCharge", -1) >= 0 then
				table.insert(suppliedEntities, targEnt)
			end
		end
	end

	self.batteryConnections = suppliedEntities
end

function ENT:Shoot ( ent )
end

function ENT:Think ()
	local const = constraint.FindConstraints( self, "Weld" )
	if table.Count(const) == 0 then
		self:TakeDamage(5)
	end

	local selfTbl = self:GetTable()

	if CurTime() > selfTbl.nextSlowThink then
		self:SlowThink( self )
		selfTbl.nextSlowThink = CurTime() + selfTbl.slowThinkTimer
	end

	if selfTbl.batteryConnections then
		for i, v in ipairs(selfTbl.batteryConnections) do
			local ourEnergy = self:GetNWInt("mw_charge", -1)
			local targetEnergy = v:GetNWInt("mw_charge", -1)
			local targetMaxEnergy = v:GetNWInt("maxCharge", -1)
			local drainAmount = math.min(ourEnergy, targetMaxEnergy - targetEnergy)

			v:SetNWInt("mw_charge", targetEnergy + drainAmount)
			self:SetNWInt("mw_charge", ourEnergy - drainAmount)
		end
	end

	self:NextThink(CurTime() + 1)
	return true
end


function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end
