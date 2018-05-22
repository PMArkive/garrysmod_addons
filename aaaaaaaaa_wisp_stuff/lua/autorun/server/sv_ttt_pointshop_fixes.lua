-- fuck the pointshop
-- such a huge pain in the ass

hook.Add("TTTPlayerSetColor", "wisp - sv_ttt_pointshop_fixes.lua", function(model)
	return 1 -- returning any value blocks ttt from setting a color or something
end, HOOK_HIGH)

hook.Add("TTTPlayerColor", "wisp - sv_ttt_pointshop_fixes.lua", function(ply)
	return Color(61, 86, 105) -- default color
end, HOOK_HIGH)

hook.Add("PlayerSetModel", "wisp - sv_ttt_pointshop_fixes.lua", function(ply)
	--if true then return 1 end
	if not ply.PS_Items then return end
	for k,v in pairs(ply.PS_Items) do
		if v.Model and v.Equipped then
			return 1 -- returning any value blocks ttt from setting a random model
		end
	end
end, HOOK_HIGH)

-- if timer.Exists("fuck trails - sv_ttt_pointshop_fixes.lua") then
	-- timer.Remove("fuck trails - sv_ttt_pointshop_fixes.lua")
-- end
-- timer.Create("fuck trails - sv_ttt_pointshop_fixes.lua", 1, 0, function()
	-- for k,v in pairs(player.GetAll()) do
		-- if not IsValid(v) then return end
		-- if not v:IsTerror() and not v:Alive() then
			-- for item_id, item in pairs(v.PS_Items or {}) do
				-- if item.Equipped then
					-- local ITEM = PS.Items[item_id]
					-- if ITEM.Category == "Trails" then
						-- -- PrintTable(ITEM)
						-- -- print("holstering")
						-- ITEM:OnHolster(v, item.Modifiers)
					-- end
				-- end
			-- end
		-- end
	-- end
-- end)

local function FixPointshopPlayermodel()
	timer.Simple(1, function()
		for k,v in pairs(player.GetAll()) do
			if not IsValid(v) then return end
			for item_id, item in pairs(v.PS_Items or {}) do
				local ITEM = PS.Items[item_id]
				if item.Equipped then
					ITEM:OnEquip(v, item.Modifiers)
				end
			end
		end
	end)
end

hook.Add("TTTPrepareRound", "PS ReEquip sv_ttt_pointshop_fixes", FixPointshopPlayermodel)
hook.Add("TTTBeginRound", "PS ReEquip sv_ttt_pointshop_fixes", FixPointshopPlayermodel)
