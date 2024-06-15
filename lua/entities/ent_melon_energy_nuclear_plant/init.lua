AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/props_combine/combine_booth_med01a.mdl"
	self.maxHP = 1000
	self.moveType = MOVETYPE_NONE
	self.canMove = false

	self:SetNWBool("active", false)

	self.population = 0
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,30))
	self.shotOffset = Vector(0,0,30)

	MelonWars.energySetup ( self )
end

function ENT:Actuate()
	local on = self:GetNWBool("active", false)
	self:SetNWBool("active", not on)
end

local mw_admin_playing_cv = GetConVar("mw_admin_playing")
local mw_admin_credits_cv = GetConVar("mw_admin_credit_cost")
function ENT:Think(ent)
	if self.spawned and mw_admin_playing_cv:GetBool() and self:GetNWBool("active", false) then
		local waterCost = 15
		local energyGain = 100
		local selfTeam = self:GetNWInt("mw_melonTeam", 0)
		if (MelonWars.teamCredits[selfTeam] >= waterCost or not mw_admin_credits_cv:GetBool()) and self:GivePower(energyGain) then
			if mw_admin_credits_cv:GetBool() then
				MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam]-waterCost
				for i, v in ipairs( player.GetAll() ) do
					if v:GetInfoNum("mw_team") == selfTeam then
						net.Start("MW_TeamCredits")
							net.WriteInt(MelonWars.teamCredits[selfTeam] ,32)
						net.Send(v)
					end
				end
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
	timer.Simple( 0.02, function()
		if (IsValid(ent)) then
			util.BlastDamage( ent, ent, ent:GetPos(), 600, 800 )
			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			util.Effect( "VortDispel", effectdata )

			local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,0,300))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,300,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(300,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,-300,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-300,0,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(150,150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-150,150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(150,-150,0))
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(-150,-150,0))
				util.Effect( "Explosion", effectdata )

			local pos1 = ent:GetPos()-- Set worldpos 1. Add to the hitpos the world normal.
			local pos2 = ent:GetPos()+Vector(0,0,-20) -- Set worldpos 2. Subtract from the hitpos the world normal.
			ent.fired = true
			ent:Remove()

			util.Decal("Scorch",pos1,pos2)
		end
	end)
end