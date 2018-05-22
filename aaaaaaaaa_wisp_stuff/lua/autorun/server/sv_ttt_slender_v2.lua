-- ttt_slender_v2 - longer light thing
	-- ents.FireTargets
	-- ents.GetMapCreatedEntity(number)
	-- Entity:MapCreationID()
	-- ttt_traitor_button - MapCreationID 156x
		-- info
			-- RemoveOnPress 1
			-- spawnflags 0
			-- wait -1
		-- My Output - Target Ent - Target Input - Delay - Only Once
		-- OnPressed - AllLight   - Turn Off     - 1.00  - Yes
		-- OnPressed - thump      - PlaySound    - 1.00  - Yes
		-- OnPressed - thump      - PlaySound    - 4.00  - Yes
		-- OnPressed - thump      - PlaySound    - 7.00  - Yes
		-- OnPressed - thump      - PlaySound    - 10.00 - Yes
		-- OnPressed - thump      - PlaySound    - 13.00 - Yes
		-- OnPressed - thump      - PlaySound    - 16.00 - Yes
		-- OnPressed - thump      - PlaySound    - 19.00 - Yes
		-- OnPressed - thump      - PlaySound    - 22.00 - Yes
		-- OnPressed - thump      - PlaySound    - 25.00 - Yes
		-- OnPressed - AllLight   - Turn On      - 31.00 - Yes
		-- OnUser4   - thump      - PlaySound    - 28.00 - Yes
	-- AllLight
		-- all of the lights on the map are named AllLight so all are targetted
	-- thump - MapCreationID 156x
		-- ambient/machines/thumper_hit.wav

hook.Add("TTTPrepareRound", "traitor_button_slender_repressable", function()
	if game.GetMap()) ~= "ttt_slender_v2" then return end
	for k,v in pairs(ents.FindByClass("ttt_traitor_button")) do
		v.RemoveOnPress = false -- so we can press the button again
		v.RawDelay = 50 -- doesn't do anything but sure why not
		v:SetDelay(50) -- before the button can be reactivated
		v.TriggerOutput = function() end -- so the button can't trigger map stuff
	end
end)

hook.Add("TTTTraitorButtonActivated", "traitor_button_slender_triggers", function(button, ply)
	if game.GetMap()) ~= "ttt_slender_v2" then return end
	for k,v in ipairs(ents.FindByName("AllLight")) do
		v:Fire("TurnOff", "", 1.00)
		v:Fire("TurnOn", "", 43.00)
	end
	
	local thump = ents.FindByName("thump")[1]
	thump:Fire("PlaySound", "", 1.00)
	thump:Fire("PlaySound", "", 4.00)
	thump:Fire("PlaySound", "", 7.00)
	thump:Fire("PlaySound", "", 10.00)
	thump:Fire("PlaySound", "", 13.00)
	thump:Fire("PlaySound", "", 16.00)
	thump:Fire("PlaySound", "", 19.00)
	thump:Fire("PlaySound", "", 22.00)
	thump:Fire("PlaySound", "", 25.00)
	thump:Fire("PlaySound", "", 28.00)
	thump:Fire("PlaySound", "", 31.00)
	thump:Fire("PlaySound", "", 34.00)
	thump:Fire("PlaySound", "", 37.00)
	--thump:Fire("PlaySound", "", 40.00)
end)
