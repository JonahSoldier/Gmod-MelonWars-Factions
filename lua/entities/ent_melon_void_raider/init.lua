AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()
	MelonWars.defaults ( self )

	self.modelString = "models/props_junk/MetalBucket01a.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.maxHP = 10
	self.speed = 90
	self.range = 150

	self.shotOffset = Vector(0,0,0)

	self.ai_chases = false

	self.angularDamping = 10

	self.nextShot = CurTime()+0.5

	self.population = 2

	self.useBBoxPhys = true
	self.isAOE = true

	self:Setup()

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )

	self.backpack = ents.Create( "prop_physics" )

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
	MelonWars.unitDefaultThink ( ent )

	if self.targetEntity ~= nil then
		if self.targetEntity.moveType ~= MOVETYPE_NONE then
			ent:LoseTarget()
		else
			if self.targetEntity:GetClass() == "ent_melon_main_building" or self.targetEntity:GetClass() == "ent_melon_main_building_grand_war" then
				ent:LoseTarget()
			end
		end
	end

end

function ENT:PhysicsUpdate()
	local ang = self:GetAngles():Up()
	ang:Negate()
	local inclination = self:Align(ang, vector_up, 5000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination * 100))

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent, forceTargetPos )
	local entTbl = ent:GetTable()
	if not(entTbl.ai or CurTime() > entTbl.nextControlShoot) then return end
	if self.targetEntity.moveType ~= MOVETYPE_NONE then return end --targetEntity.canMove would be a little less jank, but it lets you capture contraption components.
	if self.targetEntity:GetClass() == "ent_melon_main_building" or self.targetEntity:GetClass() == "ent_melon_main_building_grand_war" then return end

	MelonWars.updatePopulation(entTbl.targetEntity.population * - 1, entTbl.targetEntity:GetNWInt("mw_melonTeam",-1))
	MelonWars.updatePopulation(entTbl.targetEntity.population, self:GetNWInt("mw_melonTeam",-1))

	entTbl.targetEntity:SetNWInt("mw_melonTeam", self:GetNWInt("mw_melonTeam", 0))
	entTbl.targetEntity:MelonSetColor( self:GetNWInt("mw_melonTeam", 0) )

	for i, v in ipairs( player.GetAll() ) do
		local pos = v:GetPos()
		sound.Play("ItemBattery.Touch", pos, 40, 90, 1)
		sound.Play("AlyxEMP.Discharge", pos, 40, 80, 1)
	end

	sound.Play("ItemBattery.Touch", ent:GetPos(), 100, 90, 1)
	sound.Play("AlyxEMP.Discharge", ent:GetPos(), 100, 80, 1)

	ent:Remove()
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end