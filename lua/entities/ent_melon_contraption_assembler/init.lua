AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:SetStats()
	self.modelString = "models/props_phx/construct/metal_plate4x4.mdl"
	self.maxHP = 100
	self.moveType = MOVETYPE_NONE
	self.connections = {}

	self.population = 1
	self:BarrackInitialize()
	self.population = 1
end

function ENT:Initialize()

	MelonWars.defaults ( self )

	self:SetStats()

	self:Setup()

	self:SetNWBool("active", false)
	--InciteConnections(self)
	--MelonWars.calculateConnections(self)
	--self:SetNWBool("canGive", false)
end

function ENT:Think(ent)
	--local energy = math.Round(self:GetNWInt("energy", 0))
	--local max = self:GetNWInt("maxenergy", 0)
	--self:SetNWString("message", "OverClock: "..energy.." / "..max)
	--MW_PullEnergy(self)
	local NST = self:GetNWFloat("nextSlowThink", 0)
	if (self:GetNWBool("active", false)) then
		--if (energy > 20) then
		--	self:SetNWFloat("overdrive", self:GetNWFloat("overdrive", 0)+0.125)
		--	self:SetNWInt("energy", self:GetNWInt("energy", 0)-20)
		--end
		if (NST < CurTime()+self:GetNWFloat("overdrive", 0)*3) then
			if (self.powerCost+MelonWars.teamUnits[self:GetNWInt("mw_melonTeam", 0)] <= cvars.Number("mw_admin_max_units")) then
				self:SetNWFloat("overdrive", 0)
				self:SetNWFloat("nextSlowThink", CurTime())
				self:SetNWBool("active", false)
				net.Start("RequestContraptionLoadToClient")
					net.WriteString(self.file)
					net.WriteEntity(self)
				net.Send(self.player)
			else
				self:SetNWFloat("nextSlowThink", CurTime()+1)
			end
		end
	end
end

function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end

function ENT:BarrackSlowThink()

end