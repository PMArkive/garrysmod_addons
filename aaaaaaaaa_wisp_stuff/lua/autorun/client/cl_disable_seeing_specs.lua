local plymeta = FindMetaTable("Player")
oldGetObserverTarget = oldGetObserverTarget or plymeta.GetObserverTarget

-- hook.Add("HUDPaint", "cl_disable_seeing_specs.lua", function()
	-- local text_color = Color(255, 255, 255)
	-- local w = ScrW() * 0.032
	-- local h = ScrH()
	-- local names = ""
	-- local thing = LocalPlayer()
	-- local mytarget = oldGetObserverTarget(LocalPlayer())
	-- if IsPlayer(mytarget) then
		-- thing = mytarget
	-- end
	-- for k,v in ipairs(player.GetAll()) do
		-- if IsValid(v) then
			-- local target = oldGetObserverTarget(v)
			-- if IsPlayer(target) and target == thing then
				-- names = names .. "," .. v:Nick()
			-- end
		-- end
	-- end
	-- draw.SimpleText("Specs test: "..names, "HudHintTextLarge", w, h*0.32 + 30, text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
-- end)

-- function plymeta:GetObserverTarget()
	-- local target = oldGetObserverTarget(self)
	-- local lp = LocalPlayer()

	-- if lp:IsSpec() or lp ~= target then
		-- return target
	-- end

	-- return nil
-- end

--plymeta.GetObserverTarget = oldGetObserverTarget
-- plz no cheat
