AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MW_Defaults ( self )

	self.modelString = "models/maxofs2d/hover_classic.mdl"
	self.materialString = ""

	self.deathSound = "ambient/explosions/explode_9.wav"

	self.careForFriendlyFire = false

	self.slowThinkTimer = 1

	self.population = 2

	self.sphereRadius = 9

	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	self.range = 80
	self.speed = 140
	self.damageDeal = 80
	self.maxHP = 25

	self.meleeAi = true

	self.dootChance = 0

	MW_Setup ( self )

	self:SetNWInt("mw_charge", 0)
	self:SetNWInt("maxCharge", 50)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r*1.3, self:GetColor().g*1.3, self:GetColor().b*1.3, 255))
end

function ENT:SkinMaterial()
	self:SetMaterial("")
end

function ENT:DeathEffect( ent )
	timer.Simple( 0.02, function()
		if (IsValid(ent)) then
			local pos = ent:GetPos()
			--Put script to delay slowthink and sap power here

			local foundEnts = ents.FindInSphere(pos, ent.range )
			for k, v in RandomPairs( foundEnts ) do
				if not (v:GetClass() == "ent_melon_emp") then

					if(v.nextSlowThink == nil or v.nextSlowThink < CurTime()) then
						v.nextSlowThink = CurTime()
					else
						v.nextSlowThink = v.nextSlowThink+15
					end
					--v:NextThink( v.nextSlowThink+15 )
					v.damage = 1

					if(v.speed ~= nil and not v.stunned) then
						local originalSpeed = v.speed
						v.speed = v.speed * 0.75

						v.stunned = true

						timer.Simple( 10, function()
							v.speed = originalSpeed
							v.stunned = false
						end)
					end

					if(v.Base == "ent_melon_energy_base") then
						if (mw_electric_network[v.network].energy > 1000) then
							mw_electric_network[v.network].energy = mw_electric_network[v.network].energy - 1000
						else
							mw_electric_network[v.network].energy = 0
						end

						for k, v in pairs(mw_electric_network[v.network].elements) do
							v:Energy_Set_State()
							if(v.nextSlowThink < CurTime()) then
								v.nextSlowThink = CurTime()
							else
								v.nextSlowThink = v.nextSlowThink+15
							end
							v:NextThink( v.nextSlowThink+15 )
						end
					end

					if v:GetNWInt("mw_charge")>1000 then
						v:SetNWInt("mw_charge", v:GetNWInt("mw_charge")-1000)
					else
						v:SetNWInt("mw_charge", 0)
					end
				end
			end

			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPos() )
			effectdata:SetNormal( game.GetWorld():GetUp() )
			effectdata:SetRadius( 80 )
			util.Effect( "AR2Explosion", effectdata )

			sound.Play("NPC_Vortigaunt.Explode", ent:GetPos(), 100, 80, 1)

			--NPC_Vortigaunt.Explode

			local pos1 = ent:GetPos()-- Set worldpos 1. Add to the hitpos the world normal.
			local pos2 = ent:GetPos()+Vector(0,0,-20) -- Set worldpos 2. Subtract from the hitpos the world normal.
			ent.fired = true
			ent:Remove()

			util.Decal("Scorch",pos1,pos2)
		end
	end)
end

function ENT:SlowThink ( ent )
	if (self:GetNWInt("mw_charge", 0) ~= 50) then
		self.canShoot = false
	else
		self.canShoot = true
	end

	MW_UnitDefaultThink ( ent )
end


function ENT:OnTakeDamage( damage )

	local effectData = EffectData()
	effectData:SetStart( self:GetPos())
	util.Effect( "StunstickImpact", effectData )

	if (self.canMove) then
		if ((damage:GetAttacker():GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0) or not damage:GetAttacker():GetVar('careForFriendlyFire')) and not damage:GetAttacker():IsPlayer()) then
			if (damage:GetAttacker():GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", 0)) then
				self.HP = self.HP - damage:GetDamage()/10
			else
				self.HP = self.HP - damage:GetDamage()
			end
			self:SetNWFloat( "health", self.HP )
			if (self.HP <= 0) then
				MW_Die (self)
			end
		end
	else
		--Negate damage
	end
end

function ENT:Shoot ( ent, forcedTargetPos)
	sound.Play("buttons/button8.wav", ent:GetPos())
	ent.forceExplode = (forcedTargetPos ~= nil)
	timer.Simple( 0.3, function()
		if not ent.forceExplode and not IsValid(ent.targetEntity) then
			ent.targetEntity = nil
			ent.nextSlowThink = CurTime()+0.1
			return false
		else
			if (ent.forceExplode or tostring( ent.targetEntity ) ~= "[NULL Entity]") then
			--util.BlastDamage( ent, ent, ent:GetPos(), 100, ent.damageDeal )
			--local effectdata = EffectData()
			--effectdata:SetOrigin( ent:GetPos() )
			--util.Effect( "Explosion", effectdata )
			--ent:Remove()
				ent:SetPos(ent:GetPos()+Vector(0,0,3))
				MW_Die ( ent )
			end
		end
	end )
end