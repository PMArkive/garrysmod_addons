
local def_color = Color(200, 200, 200)--Color(255, 255, 0)
local bracket_color = Color(192, 192, 192)
local white_color = Color(255, 255, 255)
local name_color = Color(66, 183, 87)

local function firstToUpper(s)
	-- return s:sub(1,1):upper()..s:sub(2)
	return s
end

local use_serverlog = false

util.AddNetworkString("join_disconnect_messages")

STEAMID_TO_AUTHED_TABLE = STEAMID_TO_AUTHED_TABLE or {}
STEAMID_TO_IP_TABLE = STEAMID_TO_IP_TABLE or {}

hook.Add("PlayerAuthed", "sv_steamid_join_thing.lua", function(ply, steamid, uniqueid)
	local ip = "localhost"
	local nick = ply:Nick()
	local group = ply:GetUserGroup()
	local color = Wisp_GetPlayerColor_sid_group(steamid, group)

	if not ply:IsBot() then
		STEAMID_TO_AUTHED_TABLE[steamid] = true
		ip = ply:IPAddress()
		-- we store the ip like the player_connect hook incase the map changes (changelevel)
		-- a changelevel will not run the player through a PlayerConnect/player_connect hook ONLY a PlayerAuthed
		-- in short: connect - ip stored - changelevel - lua state lost - no ip for player in table on player_disconnect
		STEAMID_TO_IP_TABLE[steamid] = ip
	end

	local message = Format("[PlayerAuthed] \"%s\" <%s> (%s)", nick, steamid, ip)
	if use_serverlog then
		ServerLog(message.."\n")
	else
		print(message)
	end

	net.Start("join_disconnect_messages")
	if color then
		local tag = Wisp_GetPlayerTagOrRank_sid_group(steamid, group)
		net.WriteTable({color, "[", tag, "] ", name_color, nick, white_color, " (" .. steamid .. ")", def_color, " has joined the server."})
	else
		net.WriteTable({name_color, nick, white_color, " (" .. steamid .. ")", def_color, " has joined the server."})
	end
	net.Broadcast()
end)

hook.Add("CheckPassword", "sv_steamid_join_thing.lua", function(sid64, ip, svPass, clPass, name)
	local message = Format("[CheckPassword] \"%s\" <%s> (%s)", name, util.SteamIDFrom64(sid64), ip)
	if use_serverlog then
		ServerLog(message.."\n")
	else
		print(message)
	end
end, HOOK_LOW_MONITOR)

gameevent.Listen( "player_connect" )
hook.Add("player_connect", "sv_steamid_join_thing.lua", function(data)
	local name = data.name -- Same as Player:Nick()
	local steamid = data.networkid -- Same as Player:SteamID()
	local ip = data.address -- Same as Player:IPAddress()
	local id = data.userid -- Same as Player:UserID()
	local bot = tobool(data.bot) -- Same as Player:IsBot()
	local index = data.index -- Same as Player:EntIndex()

	if tobool(bot) then
		local message = Format("[PlayerConnect] \"%s\" <%s> (localhost)", name, steamid)
		if use_serverlog then
			ServerLog(message.."\n")
		else
			print(message)
		end

		net.Start("join_disconnect_messages")
		net.WriteTable({name_color, name, white_color, " (" .. steamid .. ")", def_color, " has joined the server."})
		net.Broadcast()
	else
		STEAMID_TO_IP_TABLE[steamid] = ip
	end
end)

gameevent.Listen( "player_disconnect" )
hook.Add("player_disconnect", "sv_steamid_join_thing.lua", function(data)
	local name = data.name -- Same as Player:Nick()
	local steamid = data.networkid -- Same as Player:SteamID()
	local id = data.userid -- Same as Player:UserID()
	local bot = tobool(data.bot) -- Same as Player:IsBot()
	local reason = data.reason -- Text reason for disconnected such as "Kicked by console!", "Timed out!", etc...

	local ip = "localhost"
	local group = "user"

	if not tobool(bot) then
		ip = STEAMID_TO_IP_TABLE[steamid]
		STEAMID_TO_IP_TABLE[steamid] = nil

		group = ULib.ucl.getUserInfoFromID(steamid)
		if group and group ~= "" then
			group = group.group
		else
			group = "user"
		end
	end

	local message = Format("[PlayerDisconnect] \"%s\" <%s> (%s)", name, steamid, ip)
	if use_serverlog then
		ServerLog(message.."\n")
	else
		print(message)
	end

	if tobool(bot) or STEAMID_TO_AUTHED_TABLE[steamid] then
		STEAMID_TO_AUTHED_TABLE[steamid] = nil

		local color = Wisp_GetPlayerColor_sid_group(steamid, group)
		net.Start("join_disconnect_messages")
		if color then
			local tag = Wisp_GetPlayerTagOrRank_sid_group(steamid, group)
			net.WriteTable({color, "[", tag, "] ", name_color, name, white_color, " (" .. steamid .. ")", def_color, " has left the server."})
		else
			net.WriteTable({name_color, name, white_color, " (" .. steamid .. ")", def_color, " has left the server."})
		end
		net.Broadcast()
	end
end)
