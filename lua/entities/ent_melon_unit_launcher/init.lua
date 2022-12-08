AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Energy_Defaults ( self )

	self.modelString = "models/props_citizen_tech/steamengine001a.mdl"
	self.speed = 320
	self.spread = 0
	self.damageDeal = 0
	self.maxHP = 200
	self.minRange = 750
	self.range = 5000
	self.shotSound = "HeadcrabCanister.LaunchSound"
	self.energyCost = 1000
	self.shotOffset = Vector(0,0,30)
	
	self.careForWalls = true
	self.nextShot = CurTime()+2
	self.fireDelay = 15
	self.canMove = false
	self.canBeSelected = true
	self.moveType = MOVETYPE_NONE
	
	self.slowThinkTimer = 0.2
	self.capacity = 0
	self:SetNWVector("energyPos", Vector(0,0,20))


	self:SetNWInt("maxunits", 10)
	self:SetNWInt("count", 0)
	self.canEatUnits = true
	self.idsInside = {}


	MW_Energy_Setup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableMotion(false)

	for i=0, 9 do
		self:SetNWString("class"..i, "")
		self:SetNWFloat("hp"..i, 0)
		self:SetNWInt("energy"..i, 0)
		self:SetNWInt("value"..i, 0)
		self:SetNWInt("entindex"..i, 0)
	end
end

function ENT:PhysicsCollide( data, physobj )
	local hitEntity = data.HitEntity
	if (hitEntity:IsWorld()) then return end
	if (not table.HasValue(self.idsInside, hitEntity:EntIndex())) then
		self:AbsorbUnit(hitEntity)
	else
		print("Preventing absorbtion, value already in list")
	end
end

function ENT:AbsorbUnit(unit)
	if (self.canEatUnits and unit:GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", -1)) then
		if (unit.Base == "ent_melon_base" and unit.canMove == true and unit:GetClass() ~= "ent_melon_engine" and unit:GetClass() ~= "ent_melon_engine_large" and unit:GetClass() ~= "ent_melon_wheel" and unit:GetClass() ~= "ent_melon_main_unit") then
			if (unit.population <= self:GetNWInt("maxunits", 0) - self:GetNWInt("count", 0)) then
				local index = self:GetNWInt("count", 0)
				self:SetNWInt("count", index+unit.population)
				self:SetNWString("class"..index, unit:GetClass())
				self:SetNWFloat("hp"..index, unit:GetNWFloat("health", 0))
				self:SetNWInt("value"..index, unit.value)
				self:SetNWInt("energy"..index, unit:GetNWInt("mw_charge", 0))
				self:SetNWInt("entindex"..index, unit:EntIndex())
				MW_UpdatePopulation(unit.population, self:GetNWInt("mw_melonTeam", 0))
				--self.population = self.population+unit.population
				unit.fired = true

				table.insert(self.idsInside, unit:EntIndex())

				unit:Remove()

				sound.Play("items/ammocrate_close.wav", self:GetPos())
			end
		end
	end
end

function ENT:Actuate()
	self:FreeUnits()
end

function ENT:FreeUnits()
	if (self:GetNWInt("count", 0) > 0) then
		local count = 0
		for i=0, 9 do
			if (self:GetNWString("class"..i, "") ~= "") then
				count = count+1

				local class = self:GetNWString("class"..i, "")
				local pos = self:GetPos()+self:GetRight()*Vector(-98.1,-98.1,-98.1)- Vector(0,0,120) + Vector(math.random(-10,10),math.random(-10,10), count*10)

				--(count%3-1)*15*(40+count*5) 

				local value = self:GetNWInt("value"..i, 0)
				local hp = self:GetNWInt("hp"..i, 0)
				local energy = self:GetNWInt("energy"..i, 0)
				local entIndex = self:GetNWInt("entindex"..i, 0)
				local _team = self:GetNWInt("mw_melonTeam", -1)

				local newMarine = ents.Create( class )
				if not IsValid( newMarine ) then return end -- Check whether we successfully made an entity, if not - bail

				newMarine:SetPos(pos)
				
				--sound.Play( "garrysmod/content_downloaded.wav", trace.HitPos, 60, 90, 1 )
				--sound.Play( "garrysmod/content_downloaded.wav", pl:GetPos(), 60, 90, 1 )
				mw_melonTeam = _team

				newMarine:Spawn()
				
				newMarine:Ini(_team, false)
				newMarine.fired = true
				
				local pl = self:GetOwner()

				pl.mw_melonTeam = _team
				
				newMarine:SetOwner(pl)

				newMarine.value = value
				newMarine:SetNWFloat("Health", hp)

				if (energy > 0) then
					newMarine:SetNWInt("mw_charge", energy)
				end
				
				undo.Create("Melon Marine")
				 undo.AddEntity( newMarine )
				 undo.SetPlayer( pl)
				undo.Finish()

				table.RemoveByValue(self.idsInside, entIndex)

				self:SetNWString("class"..i, "")
				self:SetNWInt("value"..i, 0)
				self:SetNWInt("hp"..i, 0)
				self:SetNWInt("energy"..i, 0)
				self:SetNWInt("entindex"..i, 0)
			end
		end
		self:SetNWInt("count", 0)
		sound.Play( "doors/door_metal_medium_open1.wav", self:GetPos() )
	end
end

function ENT:OnRemove()
	MW_UpdatePopulation(-self.population, self:GetNWInt("mw_melonTeam", 0))
	self:FreeUnits()
end

function ENT:SlowThink ( ent )
	local pos = (ent:GetPos()+Vector(0,0,180))	
	local energyCost = 500
	if (mw_electric_network[self.network].energy >= energyCost) then
		if (ent.ai or CurTime() > ent.nextControlShoot) then
			--------------------------------------------------------Disparar
			if (forcedTargetPos ~= nil) then
				local targets = ents.FindInSphere( forcedTargetPos, 3 )
				ent.targetEntity = nil
				for k, v in pairs(targets) do
					if (not ent:SameTeam(v)) then
						ent.targetEntity = v
						break;
					end
				end
			end

			
			if (ent.nextShot < CurTime()) then
			
				if (ent.targetPos ~= Vector(0,0,0) ) then
					if ((ent.targetPos-ent:GetPos()):LengthSqr() < ent.range*ent.range) then
						if((ent.targetPos-ent:GetPos()):LengthSqr() > ent.minRange*ent.minRange) then


							local foundBuilding = false
							local buildingDetect = ents.FindInSphere( ent.targetPos, 600 )

							for k, v in pairs(buildingDetect) do
								if (v.moveType == MOVETYPE_NONE and v:GetNWInt("mw_melonTeam", 0) ~= self:GetNWInt("mw_melonTeam", 0)) then
									foundBuilding = true
								end
							end
							
							if(not foundBuilding) then
								ent:Shoot( ent, ent.targetPos)
								self:DrainPower(500)
								ent.targetPos = Vector(0,0,0)
							else
								for k, v in pairs(player.GetAll()) do
									if (v:GetInfoNum("mw_team", 0) == self:GetNWInt("mw_melonTeam", 0)) then
										v:PrintMessage( HUD_PRINTTALK, "== Unit launcher target position too close to an enemy building! ==" )
									end
								end
								ent.targetPos = Vector(0,0,0)
							end
						end
					end			
				end
			end
		end
	end
	self:Energy_Set_State()
end

function ENT:Shoot(ent, forcedTargetPos)

	
	for k, v in pairs( player.GetAll() ) do
		sound.Play( ent.shotSound, v:GetPos() )
	end
		
	--ent.targetEntity:GetPos()


	local bullet = ents.Create( "ent_melonbullet_unit_shell" )
	if not IsValid( bullet ) then return end -- Check whether we successfully made an entity, if not - bail
	bullet:SetPos( ent:GetPos() + Vector(0,0,200) )
	bullet:SetNWInt("mw_melonTeam",self.mw_melonTeam)
	bullet:Spawn()
	bullet:SetNWVector("targetPos", forcedTargetPos)
	bullet.owner = ent

	bullet:SetNWInt("count", self:GetNWInt("count", 0))
	bullet.idsInside = self.idsInside

	for i=0, 9 do
		bullet:SetNWString("class"..i, self:GetNWString("class"..i, 0))
		bullet:SetNWFloat("hp"..i, self:GetNWFloat("hp"..i, 0))
		bullet:SetNWInt("energy"..i, self:GetNWInt("energy"..i, 0))
		bullet:SetNWInt("value"..i, self:GetNWInt("value"..i, 0))
		bullet:SetNWInt("entindex"..i, self:GetNWInt("entindex"..i, 0))

		self:SetNWString("class"..i, "")
		self:SetNWInt("value"..i, 0)
		self:SetNWInt("hp"..i, 0)
		self:SetNWInt("energy"..i, 0)
		self:SetNWInt("entindex"..i, 0)
	end

	self.idsInside = {}
	self:SetNWInt("count", 0)

	ent.fired = true
	ent.nextShot = CurTime()+ent.fireDelay

end




function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

/*


				if (IsValid(ent.targetEntity)and ent.targetEntity ~= ent) then
					if ((ent.targetEntity:GetPos()-ent:GetPos()):LengthSqr() < ent.range*ent.range) then
						local tr = util.TraceLine( {
							start = pos,
							endpos = ent.targetEntity:GetPos()+ent.targetEntity:GetVar("shotOffset", Vector(0,0,0)),
							filter = function( foundEntity ) if (foundEntity.Base ~= "ent_melon_base" and foundEntity:GetNWInt("mw_melonTeam", 0) == ent:GetNWInt("mw_melonTeam", 1)or foundEntity:GetClass() == "prop_physics" and foundEntity ~= ent.targetEntity) then return true end end
							})
						if  (tr ~= nil and tostring(tr.Entity) == '[NULL Entity]') then
							ent:Shoot( ent, ent.targetPos)
							self:DrainPower(1000)
						end
					end			
				end


*/