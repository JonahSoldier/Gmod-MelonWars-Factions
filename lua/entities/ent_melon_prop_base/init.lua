 --[[
	Logic for base props is split between this File and ent_melon_wall. 
 	This isn't great but I can't be bothered to change it. Blame Marum if you don't like it.

	There used to be a lot of extra logic spread out for them in hooks and other entities as well, but I've removed all of the instances of this that I could find.
--]]

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include("shared.lua")

function ENT:PropDefaults( ent )

	ent.HP = 1

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

function ENT:OnTakeDamage( damage )
	local damageDone = damage:GetDamage()

	if damageDone <= 0 then return end

	local attacker = damage:GetAttacker()
	local isFriendly = MelonWars.sameTeam( attacker:GetNWInt("mw_melonTeam", -1), self:GetNWInt("mw_melonTeam", -1) )
	if not ( (not isFriendly or not attacker.careForFriendlyFire) and not attacker:IsPlayer() ) then return end

	local selfTbl = self:GetTable()
	local mul = attacker.buildingDamageMultiplier
	damageDone = damageDone * (mul or 1)

	if damage:GetDamageType() == DMG_BURN then
		damageDone = damageDone * 0.5
	end
	if isFriendly then
		damageDone = damageDone / 10
	end

	selfTbl.HP = selfTbl.HP - damageDone

	if selfTbl.HP <= 0 then
		self:PropDie()
	end
end

function ENT:OnRemove()
	if not SERVER then return end
	if not(self.HP == self.maxHP and CurTime() - self:GetCreationTime() < 30) then return end

	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	if selfTeam == -1 then return end

	if MelonWars.teamCredits[selfTeam] ~= nil then
		MelonWars.teamCredits[selfTeam] = MelonWars.teamCredits[selfTeam] + self.value
	end

	for i, v in ipairs( player.GetAll() ) do
		if v:GetInfoNum("mw_team", -1) == selfTeam then
			net.Start("MW_TeamCredits")
				net.WriteInt(MelonWars.teamCredits[selfTeam] ,32)
			net.Send(v)
			v:PrintMessage( HUD_PRINTTALK, "== " .. self.value .. " Water Refunded ==" )
		end
	end
end