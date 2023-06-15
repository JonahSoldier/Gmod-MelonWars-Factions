AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.energyDefaults ( self )

	self.modelString = "models/mechanics/roboticslarge/claw_hub_8l.mdl"
	self.maxHP = 100
	--self.Angles = Angle(0,0,0)
	--/local offset = Vector(0,0,50)
	--offset:Rotate(self:GetAngles())
	--self:SetPos(self:GetPos()+offset)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
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
	if (on) then
		self:SetNWBool("active", false)
		self:SetNWString("message", "Generator Off")
		self:Energy_Add_State()
	else
		self:SetNWBool("active", true)
	end
end

function ENT:Think(ent)
	if(self.spawned) then
		if(cvars.Bool("mw_admin_playing")) then
			local waterCost = 5
			local energyGain = 20
			if (self:GetNWBool("active", false)) then
				if (MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] >= waterCost or not cvars.Bool("mw_admin_credit_cost")) then
					if (self:GivePower(energyGain)) then
						if (cvars.Bool("mw_admin_credit_cost")) then
							MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)]-waterCost
							for k, v in pairs( player.GetAll() ) do
								if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
									net.Start("MW_TeamCredits")
										net.WriteInt(MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
									net.Send(v)
								end
							end
						end
						self:SetNWString("message", "Generating energy")
						local effectdata = EffectData()
						effectdata:SetOrigin( self:GetPos() + Vector(0,0,55))
						util.Effect( "ManhackSparks", effectdata )
					else
						self:SetNWString("message", "Energy full!")
					end
				end
			else
				self:SetNWString("message", "Generator Off")
			end
		end
		self:Energy_Add_State()
	end

	self:NextThink( CurTime()+1 )
	return true
end

function ENT:SlowThink(ent)

end

function ENT:Shoot ( ent )

end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end