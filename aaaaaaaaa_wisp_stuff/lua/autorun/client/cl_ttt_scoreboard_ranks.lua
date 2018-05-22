
local function firstToUpper(s)
	-- return s:sub(1,1):upper()..s:sub(2)
	return s
end

hook.Add("TTTScoreboardColorForPlayer", "cl_ttt_scoreboard_ranks", function(ply)
	local color = Wisp_GetPlayerColor(ply)
	if color then
		return color
	end
end)

hook.Add("TTTScoreboardColumns", "cl_ttt_scoreboard_ranks", function(self)
	if KARMA.IsEnabled() then
		--self:AddColumn("", function() return "" end, 50)
		--self:AddColumn("", function() return "" end, 50)
	end
	self:AddColumn("Rank", function(ply, thing)
		local rank = ply:GetUserGroup()
		local color = Wisp_GetPlayerColor(ply)
		if color then
			thing:SetColor(color)
		end
		return firstToUpper(rank)
	end, 100)
end)
