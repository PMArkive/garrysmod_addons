-- disguiser toggle swaps to your previous weapon and holsters all your items (hopefully... and it doesn't work with trails...)

hook.Add("TTTToggleDisguiser", "sv_ttt_pointshop_disguiser.lua", function(ply, state)
	ply:ConCommand("lastinv") -- comment me out if you don't want to swap to your previous weapon

	if not ply.PS_Items then return end
	if state then
		for item_id, item in pairs(ply.PS_Items) do
			if item.Equipped then
				local ITEM = PS.Items[item_id]
				ITEM:OnHolster(ply, item.Modifiers)
			end
		end

		local mdl = GetRandomPlayerModel()
		ply:SetModel(mdl)
		--print(mdl)

		-- Always clear color state, may later be changed in TTTPlayerSetColor
		ply:SetColor(GAMEMODE:TTTPlayerColor(mdl))
	else
		for item_id, item in pairs(ply.PS_Items) do
			if item.Equipped then
				local ITEM = PS.Items[item_id]
				ITEM:OnEquip(ply, item.Modifiers)
			end
		end
	end
end, HOOK_MONITOR_LOW)
