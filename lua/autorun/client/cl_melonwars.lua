if engine.ActiveGamemode() ~= "sandbox" then return end

mw_team_colors = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
mw_team_colors[0] = Color(100,100,100,255)

net.Receive( "MW_ReturnSelection", function( len, pl )
	local returnedSelectionID = net.ReadInt(20)

	if returnedSelectionID ~= LocalPlayer().mw_selectionID then return end
	local count = net.ReadUInt(16)

	for i = 0, count do
		local foundEntity = net.ReadEntity()
		if not table.HasValue(LocalPlayer().foundMelons, foundEntity) then
			table.insert(LocalPlayer().foundMelons, foundEntity)
		end
	end
end )

net.Receive( "MW_SelectContraption", function( len, pl )
	local count = net.ReadUInt( 16 )
	-- print("Receiving extra selections from the server ("..count..")")
	local v, hasMelonBase, canMove, isFound
	for i = 0, count do
		v = net.ReadEntity()
		hasMelonBase = v.Base == "ent_melon_base"
		canMove = cvars.Bool( "mw_admin_move_any_team", false ) or ( pl == nil or v:GetNWInt( "mw_melonTeam", -1 ) == pl:GetInfoNum( "mw_team", -1 ) )
		isFound = LocalPlayer().foundMelons[v]
		if hasMelonBase and canMove and not isFound then
			table.insert( LocalPlayer().foundMelons, v )
		end
	end
end )

net.Receive( "RestartQueue", function( len, pl )
	LocalPlayer().mw_spawntime = CurTime()
end )

mrtsMessageReceivingEntity = nil
mrtsMessageReceivingState = "idle"
mrtsNetworkBuffer = ""

net.Receive( "BeginContraptionSaveClient", function()
	mrtsMessageReceivingState = net.ReadString()
	mrtsMessageReceivingEntity = net.ReadEntity()
	mrtsNetworkBuffer = ""
end )

net.Receive( "ContraptionSaveClient", function()
	local last = net.ReadBool()
	local size = net.ReadUInt( 16 )
	local data = net.ReadData( size )
	mrtsNetworkBuffer = mrtsNetworkBuffer .. data
	if not last then return end
	local text = util.Decompress( mrtsNetworkBuffer )
	file.CreateDir( "melonwars/contraptions" )
	file.Write( "melonwars/contraptions/" .. mrtsMessageReceivingState .. ".txt", text )
	mrtsMessageReceivingEntity = nil
	mrtsMessageReceivingState = "idle"
	mrtsNetworkBuffer = ""
end )

net.Receive( "ContraptionValidateClient", function()
	local contrapFiles = file.Find("melonwars/contraptions/*.txt", "DATA")

	for i = 1, table.Count(contrapFiles) do
		timer.Simple( i * 0.1, function()
			local name = string.gsub(contrapFiles[i], ".txt", "") -- Removes .txt from the name, because other parts of the code add it back in later

			local text =  file.Read( "melonwars/contraptions/" .. contrapFiles[i], "DATA" )
			local compressed_text = util.Compress(text)
			if not compressed_text then compressed_text = text end

			local len = string.len( compressed_text )
			local send_size = 60000
			local parts = math.ceil( len / send_size )
			local start = 0

			-- 29 contrap files aren't reaching the serverside function properly (Out of 52, my contraptions are being used for testing.)
			-- ^^ I had a corrupted contraption file. It was hitting that then failing to do anything after it

			for ii = 1, parts do
				local endbyte = math.min( start + send_size, len )
				local size = endbyte - start
				local data = compressed_text:sub( start + 1, endbyte + 1 )
				net.Start( "ContraptionAutoValidate" )
					net.WriteBool( ii == parts )
					net.WriteUInt( size, 16 )
					net.WriteData( data, size )
					net.WriteString(name)
				net.SendToServer()

				start = endbyte
			end
			print("Validated " .. tostring(i) .. " contraption files")
		end)
	end
end )

local function ResourcesChanged( dif )
	local tool = LocalPlayer():GetTool()
	if tool == nil then return end
	if tool.Mode ~= "melon_universal_tool" then return end
	tool:IndicateIncome( dif )
end

net.Receive( "MW_TeamCredits", function()
	local previousCredits = LocalPlayer().mw_credits
	LocalPlayer().mw_credits = net.ReadInt( 32 )
	local newCredits = LocalPlayer().mw_credits
	if previousCredits == nil then return end
	local difference = newCredits - previousCredits
	if difference == 0 then return end
	ResourcesChanged( difference )
end )

net.Receive( "MW_TeamUnits", function()
	LocalPlayer().mw_units = net.ReadInt(16)
end )

net.Receive( "RequestContraptionLoadToClient", function()
	local _file = net.ReadString()
	local ent = net.ReadEntity()

	local text = file.Read(_file)
	local compressed_text = util.Compress( text )
	if not compressed_text then compressed_text = text end
	local len = string.len( compressed_text )
	local send_size = 60000
	local parts = math.ceil( len / send_size )
	local start = 0
	net.Start( "BeginContraptionLoad" )
		net.WriteEntity(ent)
	net.SendToServer()
	for i = 1, parts do
		local endbyte = math.min( start + send_size, len )
		local size = endbyte - start
		local data = compressed_text:sub( start + 1, endbyte + 1 )
		net.Start( "ContraptionLoad" )
			net.WriteBool( i == parts )
			net.WriteUInt( size, 16 )
			net.WriteData( data, size )
		net.SendToServer()
		start = endbyte
	end
end )

function MW_SickEffect(ent, amount)
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 1, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(1.0, 2.0) ) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( math.random(12, 18) )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(50)
			local vec = AngleRand():Forward() * math.random(10, 50)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec * 0.8 ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

function MW_SiloSmoke(ent, amount)
	local emitter = ParticleEmitter( ent:GetPos() ) -- Particle emitter in this position
	for i = 1, amount do -- SMOKE
		local part = emitter:Add( "effects/yellowflare", ent:GetPos() + Vector(math.random(-30, 30), math.random(-30, 30), 0) ) -- Create a new particle at pos
		if ( part ) then
			part:SetDieTime( math.Rand(1.0, 2.0) ) -- How long the particle should "live"
			part:SetColor(100, 255, 0)
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 255 ) -- Particle size at the end of its lifetime
			part:SetStartSize( math.random(10, 20) )
			part:SetEndSize( 0 ) -- Size when removed
			part:SetAirResistance(50)
			local vec = Vector(0,0,math.random(100, 500))
			vec.z = math.abs(vec.z)
			part:SetGravity( Vector(0,0,50) ) -- Gravity of the particle
			part:SetVelocity( vec ) -- Initial velocity of the particle
		end
	end
	emitter:Finish()
end

net.Receive( "MWControlUnit" , function(len, pl)
	local u = net.ReadEntity()
	LocalPlayer().controllingUnit = u
end)

net.Receive( "MW_UnitDecoration", function(len, pl)
	local entity = net.ReadEntity()
	local tbl = net.ReadTable()

	local prop = ClientsideModel( tbl.prop )
	prop:SetPos( entity:GetPos() + VectorRand( -3, 3 ) )
	prop:SetAngles(AngleRand())
	prop:SetModelScale(tbl.scale)
	prop:SetMoveParent(entity)
	local cdata = EffectData()
	cdata:SetEntity(prop)
	util.Effect("propspawn", cdata)
end)

net.Receive( "MWColourMod", function( _, pl )
	LocalPlayer().MWhasColourModifier = net.ReadBool()
	LocalPlayer().MWColourModifierTable = net.ReadTable()
	DrawColorModify(LocalPlayer().MWColourModifierTable)
end)

net.Receive( "MW_ClientModifySpawnTime", function( _, pl )
	local spawnTimeChange = net.ReadFloat()
	LocalPlayer().spawnTimeMult = 1 + spawnTimeChange
end )