--local did = 0
hook.Add("Think", "sv_disable_seeing_specs.lua", function()
	--if true then return end
	local all_players = player.GetAll()--{}
	local terrors = {}
	local specs = {}
	local round_state = nil

	for k,v in pairs(all_players --[[player.GetAll()]]) do
		if IsValid(v) then
			--all_players[#all_players + 1] = v
			if v:Team() == TEAM_TERROR then
				terrors[#terrors + 1] = v
			else
				specs[#specs + 1] = v
			end
		end
	end

	if #terrors < 1 or #specs < 1 then
		return
	end
	
	if GetRoundState() == ROUND_POST then
		for _,spec in ipairs(specs) do
			if spec.propspec then
				for k,v in ipairs(all_players) do
					if v ~= spec then
						-- allow everyone to see propspecs in postround
						spec:SetPreventTransmit(v, false)
					end
				end
			else
				for k,v in ipairs(all_players) do
					if v ~= spec then
						spec:SetPreventTransmit(v, true)
					end
				end
			end
		end
	else
		for _,spec in ipairs(specs) do
			for k,v in ipairs(all_players) do
				if v ~= spec then
					spec:SetPreventTransmit(v, true)
				end
			end
		end
	end

	for _,terror in ipairs(terrors) do
		for k,v in ipairs(terrors) do
			if terror ~= v then
				terror:SetPreventTransmit(v, false)
			end
		end
	end

	-- for _,spec in ipairs(specs) do
		-- local send_spec_to_terrors = false
		-- if spec.propspec then
			-- for k,v in ipairs(specs) do
				-- if v ~= spec then
					-- spec:SetPreventTransmit(v, false) -- allow specs to see other specs
				-- end
			-- end
			-- if GetRoundState() == ROUND_POST then
				-- send_spec_to_terrors = true
			-- end
		-- end
		-- for k,v in ipairs(terrors) do
			-- --if did < 1 then print("test"..did) did = did + 1 end
			-- spec:SetPreventTransmit(v, not send_spec_to_terrors)
		-- end
	-- end
end)
