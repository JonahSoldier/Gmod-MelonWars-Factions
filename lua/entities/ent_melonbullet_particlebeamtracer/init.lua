AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

PrecacheParticleSystem("explosion_huge_c")

function ENT:Initialize()
	self:SetModel("models/hunter/misc/sphere025x025.mdl")
	self:SetMaterial("models/props_combine/stasisshield_sheet")

	self.deathSound = "ambient/explosions/explode_9.wav"

	self.careForFriendlyFire = false
	self.speed = 100
	self.damageDeal = 250
	self.targetPos = vector_origin

	self:SetColor(Color(100,100,100, 255))
	util.SpriteTrail(self, 0, color_white, true, 10, 1, 2000, 1 / 32, "sprites/tp_beam001")

	self.mwBulletIndestructible = true
end

function ENT:Think()
	local selfTeam = self:GetNWInt("mw_melonTeam", -1)
	local selfPos = self:GetPos()
	for i, v in ipairs( ents.FindInSphere(selfPos, 2 ) ) do
		if v.Base == "ent_melon_prop_base" and not MelonWars.sameTeam(selfTeam, v:GetNWInt("mw_melonTeam", -1)) then
			self:Explode()
			return
		end
	end

	local target = self:GetNWEntity("target", nil)
	if self.targetPos == vector_origin and IsValid(target) then
		self.targetPos = target:GetPos()
	end
	if self.targetPos == vector_origin then
		self:Remove()
		return
	end

	local targetVec = self.targetPos
	local dirVec = (targetVec-selfPos)
	self:SetPos( selfPos + dirVec:GetNormalized() * self.speed )
	self:SetAngles( dirVec:Angle() )

	local distSqr = selfPos:DistToSqr(self.targetPos)
	if distSqr < (self.speed * 1.5) ^ 2 and self:IsValid() then
		self:SetPos(self.targetPos)
		self:Explode()
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:Explode()
	timer.Simple( 12.5, function()
		if not self:IsValid() then return end
			util.BlastDamage( self, self, self:GetPos(), 450, self.damageDeal )

			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetRadius(450)
			effectdata:SetNormal(vector_up)
			util.Effect("AR2Explosion", effectdata) 
			ParticleEffect( "explosion_huge_c", self:GetPos(), angle_zero )

			for i, v in ipairs( player.GetAll() ) do
				sound.Play( "k_lab2.Barney_Explosion", v:GetPos(), 75, 100, 1 )
			end
			self:Remove()
		end	)
end