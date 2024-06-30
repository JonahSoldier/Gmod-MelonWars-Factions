--[[
	J NOTE: This was taken from MRTS, I didn't write any of the code or comments.
	https://steamcommunity.com/sharedfiles/filedetails/?id=2406050145

	I'm not sure where it originally comes from. If you want to figure that out go
	ask Marum.
--]]

-- Shoutout to Raubana for making this and to Luabee Gaming for finding it!

--Render cool rings
--Code borrowed from Raubana. Thanks raub <3
local color_mask2 = Color(0, 0, 0, 0)
local function drawStencilSphere(pos, ref, compare_func, radius, color, detail)
	render.SetStencilReferenceValue(ref)
	render.SetStencilCompareFunction(compare_func)
	render.DrawSphere(pos, radius, detail, detail, color)
end

-- Call this before calling render.AddWorldRing()
function render.StartWorldRings()
	render.WORLD_RINGS = {}
	cam.IgnoreZ(false)
	render.SetStencilEnable(true)
	render.SetStencilTestMask(255)
	render.SetStencilWriteMask(255)
	render.ClearStencil()
	render.SetColorMaterial()
end

-- Args: pos = where, radius = how big, [thick = how thick, detail = how laggy]
-- Detail must be an odd number or it will look like shit.
function render.AddWorldRing(pos, radius, thick, detail)
	detail = detail or 25
	thick = thick or 10
	local z = {
		detail = detail,
		thick = thick,
		pos = pos,
		outer_r = radius,
		inner_r = math.max(radius - thick, 0)
	}

	table.insert(render.WORLD_RINGS, z)
end

-- Call this to actually draw the rings added with render.AddWorldRing()
function render.FinishWorldRings(color)
	local ply = LocalPlayer()
	local zones = render.WORLD_RINGS
	render.SetStencilZFailOperation(STENCILOPERATION_DECR)
	for i, zone in ipairs(zones) do
		drawStencilSphere(zone.pos, 1, STENCILCOMPARISONFUNCTION_ALWAYS, zone.outer_r, color_mask2, zone.detail) -- big
	end

	render.SetStencilZFailOperation(STENCILOPERATION_INCR)
	for i, zone in ipairs(zones) do
		drawStencilSphere(zone.pos, 1, STENCILCOMPARISONFUNCTION_ALWAYS, -zone.outer_r, color_mask2, zone.detail) -- big, inside-out
	end

	render.SetStencilZFailOperation(STENCILOPERATION_INCR)
	for i, zone in ipairs(zones) do
		drawStencilSphere(zone.pos, 1, STENCILCOMPARISONFUNCTION_ALWAYS, -zone.inner_r, color_mask2, zone.detail) -- small, inside-out
	end

	render.SetStencilZFailOperation(STENCILOPERATION_DECR)
	for i, zone in ipairs(zones) do
		drawStencilSphere(zone.pos, 1, STENCILCOMPARISONFUNCTION_ALWAYS, zone.inner_r, color_mask2, zone.detail) -- small
	end

	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	local cam_pos = ply:EyePos()
	local cam_angle = ply:EyeAngles()
	local cam_normal = cam_angle:Forward()
	cam.IgnoreZ(true)
	render.SetStencilReferenceValue(1)
	render.DrawQuadEasy(cam_pos + cam_normal * 10, -cam_normal, 10000, 10000, color, cam_angle.roll)
	cam.IgnoreZ(false)
	render.SetStencilEnable(false)
end
