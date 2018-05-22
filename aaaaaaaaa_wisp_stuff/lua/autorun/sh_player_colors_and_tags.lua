local Color = Color

WISP_RANK_COLORS = {}
WISP_PLAYER_COLORS = {}
WISP_CHATTAGS = {}

-- WISP_RANK_COLORS["owner"] = Color(230, 32, 32)--( 255, 0, 0 )
WISP_RANK_COLORS["superadmin"] = Color( 0, 255, 255 ) --(255, 0, 0)
-- WISP_RANK_COLORS["dev"] = Color(160, 82, 45)--( 204, 102, 0 )
WISP_RANK_COLORS["admin"] = Color(0, 127, 255)--Color( 0, 128, 255 )
WISP_RANK_COLORS["mod"] = Color(255, 0, 255) --(96, 80, 220) --( 127, 0, 255 ) --(0, 255, 0)
WISP_RANK_COLORS["donor"] = Color(46, 204, 113)--Color( 0, 255, 0 )
WISP_RANK_COLORS["trusted"] = Color(131, 137, 150)--Color( 128, 128, 128 )
WISP_RANK_COLORS["admin"] = Color(0, 107, 215) --(220, 180, 0)

WISP_PLAYER_COLORS["STEAM_1:0:**"] = Color(230, 32, 32) -- **
WISP_CHATTAGS["STEAM_1:0:**"] = "**" -- **

function Wisp_GetPlayerColor_sid_group(sid, group)
	local color = WISP_PLAYER_COLORS[sid]
	if color then
		return color
	end
	return WISP_RANK_COLORS[group]
end

function Wisp_GetPlayerColor(ply)
	return Wisp_GetPlayerColor_sid_group(ply:SteamID(), ply:GetUserGroup())
end

function Wisp_GetPlayerTagOrRank_sid_group(sid, group)
	local tag = WISP_CHATTAGS[sid]
	if not tag then
		tag = group
	end
	return tag
end

function Wisp_GetPlayerTag(ply)
	return Wisp_GetPlayerTag_sid(ply:SteamID())
end

if CLIENT then
	local insert = table.insert
	--local COLOR_WHITE = COLOR_WHITE

	local function firstToUpper(s)
		-- return s:sub(1,1):upper()..s:sub(2)
		return s
	end

	hook.Add("OnPlayerChat", "sh_player_colors_and_tags", function(ply, strText, bTeamOnly, bPlayerIsDead)
		local tab = {}

		if bPlayerIsDead or (ply.IsGhost and ply:IsGhost()) then
			insert(tab, Color(255, 30, 40))
			insert(tab, "*DEAD* ")
		end

		if bTeamOnly then
			insert(tab, Color(30, 160, 40))
			insert(tab, "(TEAM) ")
		end

		if IsValid(ply) then
			local sid = ply:SteamID()
			local tag = WISP_CHATTAGS[sid]
			local group = ply:GetUserGroup()

			if not tag then
				if group ~= "user" then
					tag = firstToUpper(group)
				end
			end

			if tag then
				local color = Wisp_GetPlayerColor(ply)
				if not color then
					color = COLOR_WHITE
				end
				insert(tab, color)
				insert(tab, "[" .. tag .. "] ")
			end

			insert(tab, Color(0, 201, 0))
			insert(tab, ply:Nick())
		else
			insert(tab, "Console")
		end

		insert(tab, COLOR_WHITE)
		insert(tab, ": "..strText)
		chat.AddText(unpack(tab))
		return true
	end)
end
