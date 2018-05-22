hook.Add("TTTScoreboardColumns", "cl_ttt_scoreboard_mapname", function(self)
	--local PANEL = vgui.GetControlTable("TTTScoreboard")
	--PANEL
	if self.hostname then
		self.hostname:SetText( GetHostName() .. "  |  " .. game.GetMap())
		self.hostname:SetContentAlignment(6)
	end
end)
