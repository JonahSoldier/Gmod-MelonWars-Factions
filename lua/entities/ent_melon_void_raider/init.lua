AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()

	MW_Defaults ( self )

	self.modelString = "models/props_junk/MetalBucket01a.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true
	
	self.maxHP = 10
	self.speed = 90
	self.range = 150
	
	self.shotOffset = Vector(0,0,0)

	self.ai_chases = false

	self.angularDamping = 10
	
	--self:SetPos(self:GetPos()+Vector(0,0,12))
	
	self.nextShot = CurTime()+0.5

	self.population = 2

	MW_Setup ( self )

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )

	self.backpack = ents.Create( "prop_physics" )
	if not IsValid( self.backpack ) then return end

	self.backpack:SetModel("models/Items/car_battery01.mdl")
	self.backpack:SetParent(self)

	self.backpack:SetLocalAngles(Angle(0,180,90))
	self.backpack:SetLocalPos(Vector(0,3.5,0))
	self.backpack:SetColor( self.color ) 
	
	self.backpack:Spawn()

	self.backpack:SetMaterial(self.materialString)
	self.backpack:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))

	self.backpack:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	--local vel = ent.phys:GetVelocity()
	--ent.phys:SetAngles( ent.Angles )
	--ent.phys:SetVelocity(vel)
	MW_UnitDefaultThink ( ent )

	if(self.targetEntity ~= nil) then
		if(self.targetEntity.moveType ~= MOVETYPE_NONE) then
			ent:LoseTarget()
		else
			if(self.targetEntity:GetClass() == "ent_melon_main_building" or self.targetEntity:GetClass() == "ent_melon_main_building_grand_war") then
				ent:LoseTarget()
			end
		end
	end

end

function ENT:PhysicsUpdate()

	local inclination = self:Align(self:GetAngles():Up()*-1, Vector(0,0,1), 1000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination*100))

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent, forceTargetPos )
	if (ent.ai or CurTime() > ent.nextControlShoot) then
		if(ent.targetEntity.moveType == MOVETYPE_NONE) then
			if(self.targetEntity:GetClass() ~= "ent_melon_main_building" and self.targetEntity:GetClass() ~= "ent_melon_main_building_grand_war") then

				MW_UpdatePopulation(ent.targetEntity.population*-1, ent.targetEntity:GetNWInt("mw_melonTeam",-1))
				MW_UpdatePopulation(ent.targetEntity.population, self:GetNWInt("mw_melonTeam",-1))

				ent.targetEntity:SetNWInt("mw_melonTeam", self:GetNWInt("mw_melonTeam", 0))
				ent.targetEntity:MelonSetColor( self:GetNWInt("mw_melonTeam", 0) )

				for k, v in pairs( player.GetAll() ) do
					sound.Play("ItemBattery.Touch", v:GetPos(), 40, 90, 1)
					sound.Play("AlyxEMP.Discharge", v:GetPos(), 40, 80, 1)
				end
			
				sound.Play("ItemBattery.Touch", ent:GetPos(), 100, 90, 1)
				sound.Play("AlyxEMP.Discharge", ent:GetPos(), 100, 80, 1)
			
				ent:Remove()	
			end		
		end

	end
end

function ENT:DeathEffect ( ent )
	MW_DefaultDeathEffect ( ent )
end