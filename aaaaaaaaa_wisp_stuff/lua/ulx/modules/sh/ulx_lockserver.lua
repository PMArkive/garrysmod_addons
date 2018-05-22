ULX_LOCKSERVER_BOOL = false

-- Add a fake server-has-quit-thing maybe?

local okay_ranks = {
	-- "owner",
	-- "dev",
	"superadmin",
	"admin",
	"mod",
	"donor",
	"trusted",
}

local function should_allow_in(steamid)
	local info = ULib.ucl.getUserInfoFromID(steamid)
	if not info or not info.group then
		return false
	end
	return table.HasValue(okay_ranks, info.group)
end

local function delayed_kickid(steamid)
	timer.Simple(0, function()
		game.KickID(steamid, "Server is locked - you can't join")
	end)
end

if SERVER then
	hook.Add("CheckPassword", "ulx_lockserver.lua", function(steamid64, ip, svPassword, clPassword, nick)
		if not ULX_LOCKSERVER_BOOL then return end
		if not should_allow_in(util.SteamIDFrom64(steamid64)) then
			return false, "Server is locked - you can't join"
		end
	end)

	hook.Add("PlayerAuthed", "ulx_lockserver.lua", function(ply, steamid, uniqueid)
		if not ULX_LOCKSERVER_BOOL then return end
		if ply:IsBot() then return end
		if not should_allow_in(steamid) then
			delayed_kickid(steamid)
		end
	end)

	hook.Add("PlayerInitialSpawn", "ulx_lockserver.lua", function(ply)
		if not ULX_LOCKSERVER_BOOL then return end
		if ply:IsBot() then return end
		if not should_allow_in(ply:SteamID()) then
			delayed_kickid(ply:SteamID())
		end
	end)
end

function ulx.lockserver(calling_ply, should_unlock)
	if ULX_LOCKSERVER_BOOL then
		if should_unlock then
			-- unlock
			ULX_LOCKSERVER_BOOL = false
			ulx.fancyLogAdmin(calling_ply, "#A unlocked the server - any rank can join.")
		else
			-- complain about already being locked
			ULib.tsayError(calling_ply, "Server is already locked - try !unlockserver.", true)
		end
	else
		if should_unlock then
			-- complain about not being locked
			ULib.tsayError(calling_ply, "Server is not locked - can't unlock.", true)
		else
			-- lock server
			ULX_LOCKSERVER_BOOL = true
			ulx.fancyLogAdmin(calling_ply, "#A locked the server - only staff, donors, and trusted can join.")
		end
	end
end
local lockserver = ulx.command("Misc", "ulx lockserver", ulx.lockserver, "!lockserver")
lockserver:addParam{ type=ULib.cmds.BoolArg, invisible=true }
lockserver:defaultAccess("superadmin")
lockserver:help("Locks the server unless you have a non-user rank.")
lockserver:setOpposite("ulx unlockserver", { _, true }, "!unlockserver", true)
