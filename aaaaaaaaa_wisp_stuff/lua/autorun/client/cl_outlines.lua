local asdf = {}
--asdf["entity_class"] = {Color(red, green, blue, alpha), draw_for_detective, draw_for_traitor, draw_for_innocent, additional_check_function}

------------------------------- color --------- det - traitor - inno
asdf["ttt_beacon"]           = {Color(0,255,151), true, false, true}
asdf["ttt_health_station"]   = {Color(0,0,255),   true, false, false}
asdf["ttt_radio"]            = {Color(0,255,0),   false, true, false}
--asdf["ttt_slam_trip"]        = {Color(255,0,0),   false, true, false}
asdf["ttt_slam_tripmine"]    = {Color(255,0,0),   false, true, false}
--asdf["ttt_slam_satchel"]     = {Color(255,0,0),   false, true, false}
asdf["ttt_cse_proj"]         = {Color(0,0,255),   true, false, false} -- visualizer
asdf["ttt_briefcase"]        = {Color(0,0,255),   true, false, false}
asdf["ttt_c4"]               = {Color(255,0,0),   false, true, false}
asdf["ttt_detective_camera"] = {Color(0,0,255),   true, false, false}
asdf["ttt_death_station"]    = {Color(255,0,0),   false, true, false}
asdf["ttt_decoy"]            = {Color(96,96,96),  false, true, false}

--CONFIGURATION
local TraitorGlow = true --To draw the effect for traitors.
local DetectiveGlow = true --To draw the effect for detectives.

local TraitorGlowColor = Color(255, 0, 0) --The color for the traitor glow effect.
local DetectiveGlowColor = Color(0, 0, 255) --The color for the detective glow effect.

local TraitorGlowIntensity = 3 --How big the effect is for traitors.
local DetectiveGlowIntensity = 3 --How big the effect is for detectives.

local TraitorWall = true --Can traitors see other traitors through walls?
local DetectiveWall = false --Can detectives see other detectives through walls?
--END OF CONFIGURATION

local ttt_traitor_glow = CreateClientConVar("ttt_traitor_glow", "1", true, false)
local ttt_detective_glow = CreateClientConVar("ttt_detective_glow", "1", true, false)

local render = render
local cam = cam
local halo = halo

hook.Add("PostDrawOpaqueRenderables", "wisp - cl_outlines.lua", function() -- use this one for all the `render` stuff
	local me = LocalPlayer()
	if not (IsValid(me) and me.GetRole) then return end
	local role = me:GetRole()
	
	local ang = me:EyeAngles()
	local pos = (ang:Forward()*10) + me:EyePos()
	ang = Angle(ang.p+90, ang.y, 0)
	local scrw = ScrW()
	local scrh = ScrH()

	
	for k,v in pairs(asdf) do
		if (role == ROLE_DETECTIVE and not v[2]) or
		   (role == ROLE_TRAITOR   and not v[3]) or
		   (role == ROLE_INNOCENT  and not v[4])
		then
			continue
		end

		local entities = ents.FindByClass(k)
		if not pairs(entities) then
			continue
		end
		
		--halo.Add(ents.FindByClass(k), v[1], 0, 0, 1, true, true)

		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(15)
		render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetBlend(0)

		for k,v in pairs(entities) do
			v:DrawModel()
		end

		local color = v[1]
		render.SetBlend(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		cam.Start3D2D(pos, ang, 1)
			surface.SetDrawColor(color.r, color.g, color.b, color.a)
			surface.DrawRect(-scrw, -scrh, scrw*2, scrh*2)
		cam.End3D2D()
		
		for k,v in pairs(entities) do
			v:DrawModel()
		end

		render.SetBlend(0)
		render.SetStencilEnable(false)
	end
end)

hook.Add("PreDrawHalos", "wisp - cl_outlines.lua", function()
	local me = LocalPlayer()
	local role = me:GetRole()

	local traitors = {}
	local detectives = {}
	local t_glow = ttt_traitor_glow:GetInt() == 1
	local d_glow = ttt_detective_glow:GetInt() == 1

	if t_glow or d_glow then
		for k, v in pairs(player.GetAll()) do
			if v:IsActiveTraitor() and v ~= me then
				table.insert(traitors, v)
			elseif v:IsActiveDetective() and v ~= me then
				table.insert(detectives, v)
			end
		end

		--if me:IsActiveTraitor() --[[and TraitorGlow]] then
		if role == ROLE_TRAITOR then
			if t_glow then
				halo.Add(traitors, TraitorGlowColor, 0, 0, TraitorGlowIntensity, true, TraitorWall)
			end
		--elseif me:IsActiveDetective() --[[and DetectiveGlow]] then
		elseif role == ROLE_DETECTIVE then
			if d_glow then
				halo.Add(detectives, DetectiveGlowColor, 0, 0, DetectiveGlowIntensity, true, DetectiveWall)
			end
		end
	end
end)
--hook.Remove("PreDrawHalos", "wisp - cl_outlines.lua")







