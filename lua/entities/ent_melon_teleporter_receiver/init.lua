AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_lab/teleplatform.mdl"
	self.maxHP = 75
	self.range = 250
	--self.Angles = Angle(0,0,0)
	--self:SetPos(self:GetPos()+Vector(0,0,10))
	self.shotOffset = Vector(0,0,10)
	--self.sphereRadius = 50

	self.moveType = MOVETYPE_NONE
	--self.canMove = false
	self.population = 1

	MW_Setup ( self )

	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	timer.Simple(0.5, function () self:ConnectToBarrack() end)
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/2+100, self:GetColor().g/2+100, self:GetColor().b/2+100, 255))
end

function ENT:SlowThink(ent)
	--PrintTable(self.rallyPoints)
end

function ENT:Shoot ( ent )
	--MW_DefaultShoot ( ent )
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end

function ENT:ConnectToBarrack()
	local connected = false
	local entities = ents.FindInSphere( self:GetPos(), self.range )
	--------------------------------------------------------Disparar
	local foundEntities = {}


	for k, v in pairs(entities) do
		if ((v.Base == "ent_melon_base") and v:GetNWInt("mw_melonTeam", 0) == self:GetNWInt("mw_melonTeam", 0)) then -- si no es un aliado
			table.insert(foundEntities, v)
		end
	end

	local closestEntity = nil
	local closestDistance = 0
	for k, v in pairs(foundEntities) do
		if ((closestEntity == nil or self:GetPos():DistToSqr( v:GetPos() ) < closestDistance) and v~=self) then
			closestEntity = v
			closestDistance = self:GetPos():DistToSqr( v:GetPos() )
		end
	end
	
	print(closestEntity)
	if (closestEntity ~= nil) then
		self.connection = closestEntity
	else
		for k, v in pairs(player.GetAll()) do
			if (v:GetInfoNum("mw_team", 0) == self:GetNWInt("mw_melonTeam", 0)) then
				v:PrintMessage( HUD_PRINTTALK, "== Receivers require nearby units to build! ==" )
			end
		end
		self:Remove()
	end

end


function ENT:OnRemove()
	MW_UpdatePopulation(-self.population, self:GetNWInt("mw_melonTeam", 0))
end