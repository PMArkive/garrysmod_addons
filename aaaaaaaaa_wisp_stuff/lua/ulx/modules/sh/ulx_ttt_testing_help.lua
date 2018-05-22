--ULX_TTT_PAUSE = false

--local prev_idle_limit

function ulx.tttpause(calling_ply, should_unpause)
	-- if ULX_TTT_PAUSE then
		-- if should_unpause then
			-- -- unpause
			-- ULX_TTT_PAUSE = false
			-- ulx.fancyLogAdmin(calling_ply, "#A unpaused the server.")
		-- else
			-- -- complain about already being paused
			-- ULib.tsayError(calling_ply, "Server is already paused - try !tttunpause.", true)
		-- end
	-- else
		-- if should_unpause then
			-- -- complain about not being paused
			-- ULib.tsayError(calling_ply, "Server is not paused - can't unpause.", true)
		-- else
			-- -- pause server
			-- ULX_TTT_PAUSE = true
			-- ulx.fancyLogAdmin(calling_ply, "#A paused the server.")
		-- end
	-- end
	
	if should_unpause then
		--if prev_idle_limit then
		--	SetGlobalInt("ttt_idle_limit", prev_idle_limit)
		--end
		StartWinChecks()
		ulx.fancyLogAdmin(calling_ply, "#A unpaused the server.")
	else
		--prev_idle_limit = GetGlobalInt("ttt_idle_limit", 300)
		SetGlobalInt("ttt_idle_limit", 60000) -- reset at the next round start
		StopWinChecks()
		ulx.fancyLogAdmin(calling_ply, "#A paused the server.")
	end
end
local tttpause = ulx.command("Misc", "ulx tttpause", ulx.tttpause, "!tttpause")
tttpause:addParam{ type=ULib.cmds.BoolArg, invisible=true }
tttpause:defaultAccess("superadmin")
tttpause:help("Freezes the timer and shit on the server and prevents the round from ending.")
tttpause:setOpposite("ulx tttunpause", { _, true }, "!tttunpause", true)

-- quick round start
-- auto bot spawn?
-- auto bot freeze?
-- auto server lock?

