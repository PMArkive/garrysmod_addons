local xbans = {}

local function OnRowRightClick( self, LineID, line )
	local menu = DermaMenu()
	menu:SetSkin(xgui.settings.skin)
	menu:AddOption( "Open Profile...", function()
		if not line:IsValid() then return end
		local bandata = xgui.data.bans.cache[LineID]
		if not bandata then return end
		local sid64 = util.SteamIDTo64(bandata.steamID)
		gui.OpenURL("https://steamcommunity.com/profiles/"..sid64)
	end)
	menu:AddOption( "Details...", function()
		if not line:IsValid() then return end
		xbans.ShowBanDetailsWindow( xgui.data.bans.cache[LineID] )
	end )
	menu:AddOption( "Edit Ban...", function()
		if not line:IsValid() then return end
		xgui.ShowBanWindow( nil, line:GetValue( 5 ), nil, true, xgui.data.bans.cache[LineID] )
	end )
	menu:AddOption( "Remove", function()
		if not line:IsValid() then return end
		xbans.RemoveBan( line:GetValue( 5 ), xgui.data.bans.cache[LineID] )
	end )
	menu:Open()
end

for k,v in pairs(xgui.null:GetChildren()) do
	if v.banlist then
		xbans = v
		xbans.banlist.OnRowRightClick = OnRowRightClick
		break
	end
end
