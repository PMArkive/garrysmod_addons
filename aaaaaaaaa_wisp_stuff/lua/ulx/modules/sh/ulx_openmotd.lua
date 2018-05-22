function ulx.openmotd(calling_ply, target_plys)
	for k,v in pairs(target_plys) do
		ULib.clientRPC( v, "ulx.showMotdMenu", v:SteamID() )
	end

	ulx.fancyLogAdmin(calling_ply, true, "#A opened the MOTD on #T", target_plys)
end
local openmotd = ulx.command("Misc", "ulx openmotd", ulx.openmotd, "!openmotd")
openmotd:addParam{ type=ULib.cmds.PlayersArg, ULib.cmds.optional }
openmotd:defaultAccess("mod")
openmotd:help("Opens the MOTD window on the players and on the caller if there is not any arguments.")
