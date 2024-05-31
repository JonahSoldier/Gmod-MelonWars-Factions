AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include( "shared.lua" )

function ENT:Initialize()

	MelonWars.defaults ( self )

	self.modelString = "models/props_junk/plasticbucket001a.mdl"
	self.moveType = MOVETYPE_VPHYSICS
	self.canMove = true

	self.maxHP = 40
	self.speed = 70
	self.range = 250
	self.shotAngle = 15
	self.spread = 0
	self.damageDeal = 2
	self.shotSound = "weapons/shotgun/shotgun_fire6.wav"

	self.buildingDamageMultiplier = 0.7

	self.shotOffset = Vector(0,0,5)

	self.angularDamping = 10

	--self:SetPos(self:GetPos()+Vector(0,0,12))

	self.nextShot = CurTime()+2

	self.population = 3

	self.useBBoxPhys = true
	self:Setup()

	construct.SetPhysProp( self:GetOwner() , self, 0, nil,  { GravityToggle = true, Material = "ice" } )
end

function ENT:ModifyColor()
	self:SetColor(Color(self:GetColor().r/1.5, self:GetColor().g/1.5, self:GetColor().b/1.5, 255))
end

function ENT:SlowThink ( ent )
	--local vel = ent.phys:GetVelocity()
	--ent.phys:SetAngles( ent.Angles )
	--ent.phys:SetVelocity(vel)
	MelonWars.unitDefaultThink ( ent )

end

function ENT:PhysicsUpdate()

	local inclination = self:Align(self:GetAngles():Up(), Vector(0,0,1), 3000)
	self.phys:ApplyForceCenter( Vector(0,0,inclination*100))

	self:DefaultPhysicsUpdate()
end

function ENT:Shoot ( ent, forceTargetPos )
	if (ent.nextShot < CurTime()) then
		local pos = ent:GetPos()+ent.shotOffset
		--------------------------------------------------------Disparar
		if (forceTargetPos ~= nil or IsValid(ent.targetEntity)) then
			local targetPos
			if (IsValid(ent.targetEntity)) then
				targetPos = ent.targetEntity:GetPos()+ent.targetEntity:OBBCenter()
				if (ent.targetEntity:GetVar("shotOffset") ~= nil) then
					if (ent.targetEntity:GetVar("shotOffset") ~= Vector(0,0,0)) then
						targetPos = ent.targetEntity:GetPos()+ent.targetEntity:GetVar("shotOffset")
					end
				end
			else
				targetPos = forceTargetPos
			end

			local baseDir = targetPos-pos
			local right = Vector(baseDir.y, -baseDir.x, 0)
			local axis = right:Cross(baseDir):GetNormalized()
			local bulletCount = 5
			local baseAngle = baseDir:Angle()
			for i = 1, bulletCount do
				local rotatedDir = Angle(baseAngle.p, baseAngle.y, baseAngle.r)
				rotatedDir:RotateAroundAxis(axis, (i-math.Round(bulletCount/2))*self.shotAngle/bulletCount)
				local dir = rotatedDir:Forward()

				MelonWars.bullet(ent, pos, dir, ent.range*1.1, ent, nil, 0)
			end
			local effectdata = EffectData()
					effectdata:SetScale(1)
					effectdata:SetAngles( (baseDir):Angle())
					effectdata:SetOrigin( pos + (baseDir):GetNormalized()*10 )
				util.Effect( "MuzzleEffect", effectdata )
			sound.Play( ent.shotSound, pos )
		end
	end
end

function ENT:DeathEffect ( ent )
	MelonWars.defaultDeathEffect ( ent )
end