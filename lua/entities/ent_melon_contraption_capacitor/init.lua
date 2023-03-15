AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MW_Defaults ( self )

	self.birth = CurTime()

	self.modelString = "models/props_junk/TrashBin01a.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.slowThinkTimer = 1

	self.population = 0

	self.captureSpeed = 0

	self.maxHP = 50
	self.shotOffset = Vector(0,0,15)

	MW_Setup ( self )

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 1000)

end


function ENT:SlowThink ( ent )
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:Update (ent)

end

function ENT:Think ()
	if (self.damage > 0) then
		self.HP = self.HP-self.damage
		self:SetNWFloat( "health", self.HP )
		self.damage = 0
		if (self.HP <= 0) then
			MW_Die( self )
		end
	end

	local const = constraint.FindConstraints( self, "Weld" )
	if (table.Count(const) == 0) then
		self.damage = 5
	end

	local allConstraints = constraint.GetTable(self)
	local suppliedEntities = {}

	for k, v in pairs(allConstraints) do
		if(v.Type == "Weld") then
			--v:GetConstrainedPhysObjects()
			if(v.Ent1~=self) then
				--print(v.Ent1:GetNWInt("mw_charge", 0))
				if(v.Ent1:GetNWInt("mw_charge", -1)>=0 and v.Ent1:GetClass() ~= "ent_melon_contraption_capacitor") then
					table.insert(suppliedEntities, v.Ent1)
				else
					if(v.Ent1:GetClass() == "ent_melon_contraption_capacitor") then
						if(istable(v.Ent1.batteryConnections)) then
							table.Merge(suppliedEntities, v.Ent1.batteryConnections)
						end
					end
				end
			else
				--print(v.Ent2:GetNWInt("mw_charge", 0))
				if(v.Ent2:GetNWInt("mw_charge", -1)>=0 and v.Ent2:GetClass() ~= "ent_melon_contraption_capacitor") then
					table.insert(suppliedEntities, v.Ent2)
				else
					if(v.Ent2:GetClass() == "ent_melon_contraption_capacitor") then
						if(istable(v.Ent2.batteryConnections)) then
							--PrintTable(v.Ent2.batteryConnections)
							table.Merge(suppliedEntities, v.Ent2.batteryConnections)
						end
					end
				end
			end
		end
	end

	self.batteryConnections = suppliedEntities

	for k, v in pairs(suppliedEntities) do
		if(self:GetNWInt("mw_charge", -1)>v:GetNWInt("maxCharge", -1)-v:GetNWInt("mw_charge", -1)) then
			--this is really messy, but it takes away the difference between how much energy the target part
			--has and its maximum value
			self:SetNWInt("mw_charge", self:GetNWInt("mw_charge", -1)-(v:GetNWInt("maxCharge", -1)-v:GetNWInt("mw_charge", -1)))
			v:SetNWInt("mw_charge", v:GetNWInt("maxCharge", -1))
		else
			if(self:GetNWInt("mw_charge", -1)>0) then
				v:SetNWInt("mw_charge", v:GetNWInt("mw_charge", -1) + self:GetNWInt("mw_charge", -1))
				self:SetNWInt("mw_charge", 0)
			end
		end
	end

	self:NextThink(CurTime()+5)
	return true
end


function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end
