AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_buildings/watertower_001c.mdl"
	self.maxHP = 100
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", true)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))

	self.maxWater = 4000
	--self.waterGenerated = 0
	self:SetNWInt("waterGenerated", 0)

	MelonWars.energySetup ( self )
end

function ENT:Actuate()
	local on = self:GetNWBool("active", false)
	self:SetNWBool("active", not on)
end

function ENT:Think(ent)
	if self.spawned and cvars.Bool("mw_admin_playing") then
		local waterGain = 5
		local energyCost = 5
		local waterGenerated = self:GetNWInt("waterGenerated", 0)
		if self.maxWater > waterGenerated then
			if self:GetNWBool("active", false) and self:DrainPower(energyCost) then
				local selfTeam = self:GetNWInt("mw_melonTeam", 0)
				MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam] + waterGain

				self.value = math.max(self.value - waterGain, 0)
				self:SetNWInt("waterGenerated", waterGenerated + waterGain)
				for i, v in pairs( player.GetAll() ) do
					if v:GetInfoNum("mw_team", -1) == selfTeam then
						net.Start("MW_TeamCredits")
							net.WriteInt(MelonWars.teamCredits[selfTeam] ,32)
						net.Send(v)
					end
				end
			end
			--self:Energy_Add_State()
		else
			self:SetColor(Color(150,150,150,255))

			self.HP = self.HP-10
			self:SetNWFloat( "health", self.HP )
			if self.HP <= 0 then
				MelonWars.die( self )
			end
		end
	end
	self:NextThink( CurTime() + 1 )
	return true
end

function ENT:SlowThink(ent)
end

function ENT:Shoot ( ent )
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end