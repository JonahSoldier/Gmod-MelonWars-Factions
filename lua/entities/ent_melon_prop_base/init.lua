AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:PropDefaults( ent )

	ent.hp = 1
	ent:SetNWFloat( "maxhealth", 1 )
	ent:SetNWFloat( "health", 1 )

	ent.shotOffset = Vector(0,0,0)
	ent.modelString = "models/props_junk/watermelon01.mdl"
	ent.materialString = "models/debug/debugwhite"

	ent:SetMaterial( "Models/effects/comball_sphere" )

	ent.onFire = false

	ent.deathEffect = "cball_explode"

	ent.damage = 0

	ent.Angles = Angle(0,0,0)
end

function ENT:PropDefaultDeathEffect()
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( self.deathEffect, effectdata )
	sound.Play( self.deathSound, self:GetPos() )
	self:Remove()
end

function ENT:PropDie()
	if cvars.Bool( "mw_admin_immortality" ) then return end
	self:PropDefaultDeathEffect()
end
--[[
function ENT:OnTakeDamage( damage )
	if (damage:GetDamage() > 0) then
		if ((damage:GetAttacker():GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0) or not damage:GetAttacker():GetVar('careForFriendlyFire')) and not damage:GetAttacker():IsPlayer()) then
			local HP = self:GetNWFloat("health", 1) - damage:GetDamage()
			self:SetNWFloat( "health", HP )
			if (HP <= 0) then
				self:PropDie()
			end
		end
	end
end]]

function ENT:OnRemove()
	if (SERVER) then
		if (self:GetNWFloat("health", 1) == self:GetNWFloat("maxhealth", 1) and CurTime()-self:GetCreationTime() < 30) then
			if (MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] ~= nil) then
				MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] = MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)]+self.value
			end
			for k, v in pairs( player.GetAll() ) do
				if (self:GetNWInt("mw_melonTeam", 0) ~= 0) then
					if (v:GetInfo("mw_team") == tostring(self:GetNWInt("mw_melonTeam", 0))) then
						net.Start("MW_TeamCredits")
							net.WriteInt(MelonWars.teamCredits[self:GetNWInt("mw_melonTeam", 0)] ,32)
						net.Send(v)
						v:PrintMessage( HUD_PRINTTALK, "== "..self.value.." Water Refunded ==" )
					end
				end
			end
		end
	end
end