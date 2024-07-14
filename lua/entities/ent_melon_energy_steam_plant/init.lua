AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/mechanics/roboticslarge/claw_hub_8l.mdl"
	self.maxHP = 100
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", false)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))

	MelonWars.energySetup ( self )
end

function ENT:Actuate()
	local on = self:GetNWBool("active", false)
	self:SetNWBool("active", not on)
end

local mw_admin_credits_cv = GetConVar("mw_admin_credit_cost")
function ENT:Think(ent)
	if self.spawned and MelonWars.admin_playing and self:GetNWBool("active", false) then
		local waterCost = 5
		local energyGain = 20
		local selfTeam = self:GetNWInt("mw_melonTeam", 0)
		if (MelonWars.teamCredits[selfTeam] >= waterCost or not mw_admin_credits_cv:GetBool()) and self:GivePower(energyGain) then
			if mw_admin_credits_cv:GetBool() then
				MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam]-waterCost
				MelonWars.updateClientCredits(selfTeam)
			end
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + Vector(0,0,55))
			util.Effect( "ManhackSparks", effectdata )
		end
		--self:Energy_Add_State()
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