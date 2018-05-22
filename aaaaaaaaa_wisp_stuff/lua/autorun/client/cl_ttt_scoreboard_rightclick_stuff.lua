
-- gross function
local function add(menu, stuff, skip_first)
	for k,v in ipairs(stuff) do
		if skip_first then
			skip_first = false
			continue
		end
	
		local first_of_v = v[1]
		if first_of_v == nil then
			-- spacer
			menu:AddSpacer()
		elseif istable(first_of_v) then
			-- add submenu and recurse with table
			local submenu,subimg = menu:AddSubMenu(first_of_v[1])
			subimg:SetImage("icon16/"..first_of_v[2]..".png")
			add(submenu, v, true)
		else
			-- regular option and stuff
			assert(isstring(first_of_v))
			local asdf = v[3]
			local cb
			
			if istable(asdf) then -- regular simple RunConsoleCommand args
				cb = function()
					RunConsoleCommand(asdf[1], asdf[2], asdf[3], asdf[4], asdf[5], asdf[6], asdf[7], asdf[8])
					surface.PlaySound("buttons/button9.wav")
				end
			elseif isfunction(asdf) then -- function to call on thing
				cb = function()
					asdf(menu)
					surface.PlaySound("buttons/button9.wav")
				end
			else -- string / popup
				assert(isstring(asdf))
				local title = asdf
				local onenter_cb = v[4]

				cb = function()
					local frame = vgui.Create("DFrame")
					frame:Center()
					frame:SetSize(500, 50)
					frame:SetTitle(title)
					frame:ShowCloseButton(true)
					frame:SetVisible(true)
					frame:MakePopup()
					frame:SetDraggable(true)
					local text = vgui.Create("DTextEntry", frame)
					text:SetPos(20, 25)
					text:SetTall(20)
					text:SetWide(450)
					text:SetEnterAllowed(true)
					text.OnEnter = function()
						onenter_cb(menu, frame, text)
						surface.PlaySound("buttons/button9.wav")
						--frame:SetVisible(false)
						frame:Close()
					end
				end
			end
			
			menu:AddOption(first_of_v, cb):SetImage("icon16/"..v[2]..".png")
		end
	end
end

-- this might not be needed - unknown at this time
local function _menu_paint(self, w, h)
	surface.SetDrawColor(bfscoreboard.adminMenuBGColor)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor( bfscoreboard.adminMenuBorderColor )
	surface.DrawRect(0, 0, w, 1)
	surface.DrawRect(0, h-1, w, 1)
	surface.DrawRect(0, 0, 1, h)
	surface.DrawRect(w-1, 0, 1, h)
end
local function add_menu_paint(menu)
	menu.Paint = _menu_paint
end

local function right_click_stuff(menu)
	-- http://www.famfamfam.com/lab/icons/silk/previews/index_abc.png

	surface.PlaySound("buttons/button9.wav")
	--local opt = DermaMenu()
	local ply = menu.Player
	local pid = "$"..ply:SteamID() -- so ulib/ulx can parse the exact user we want

	-- adding these to the top of the menu for admins
	if LocalPlayer():IsAdmin() then
		add(menu, {
			{"Friends", "group", {"ulx", "friends", pid}},
			{"Hours",   "clock", {"ulx", "hours", pid}},
			{}, -- spacer
		})
	end
	
	-- anybody can use these
	add(menu, {
		{"Copy Name",    "user_edit",     function() SetClipboardText(ply:Nick()) end},
		{"Copy SteamID", "computer_edit", function() SetClipboardText(ply:SteamID()) end},
		{"Open Profile", "world",         function() ply:ShowProfile() end},
	})

	if not IsValid(ply) or not LocalPlayer():IsAdmin() then
		return
	end

	-- only admins can see this stuff
	add(menu, {
		{"List JoinsDcs", "application_side_list", {"ulx", "listjoinsdcs"}},
		{}, -- spacer
		{"Open MOTD",     "information",           {"ulx", "openmotd", pid}},
		{}, -- spacer
		{ -- Admin submenu
			{"Admin", "medal_gold_1"}, -- {title, silk_icon}
			{"SlayNR",       "cut_red", {"ulx", "slaynr",  pid}},
			{"RemoveSlayNR", "cut",     {"ulx", "rslaynr", pid}},
			{"ImpairNR",     "wrench_orange", "ImpairNR Damage Amount", function(menu, frame, text)
				RunConsoleCommand("ulx", "impairnr", pid, text:GetValue())
			end},
			{"UnImpairNR", "wrench",  {"ulx", "impairnr", pid, "0"}},
			{"Slay Now",   "cross",   {"ulx", "slay",     pid}},
			{"Friends",    "group",   {"ulx", "friends",  pid}},
			{"Hours",      "clock",   {"ulx", "hours",    pid}},
			{"PermaBan",   "delete",  "Perma Ban Reason", function(menu, frame, text)
				RunConsoleCommand("ulx", "ban", pid, "0", text:GetValue())
			end},
			{"Kick", "user_delete",   "Kick reason", function(menu, frame, text)
				RunConsoleCommand("ulx", "kick", pid, text:GetValue())
			end},
			{"Reconnect", "connect",    {"ulx", "reconnect", pid}},
			{"AFK Kick",  "disconnect", {"ulx", "kick", pid, "AFK"}},
		},
		{ -- Super Admin submenu
			{"Super Admin", "award_star_silver_3"}, -- {title, silk_icon}
			{"1000 Karma",  "wand",         {"ulx", "karma",      pid, "1000"}},
			{"Respawn",     "heart",        {"ulx", "respawn",    pid}},
			{"SRespawn",    "heart_delete", {"ulx", "srespawn",   pid}},
			{"SRespawnTP",  "heart_add",    {"ulx", "srespawntp", pid}},
			{"Force",       "chart_bar",    "Force - type: traitor/innocent/detective",  function(menu, frame, text)
				RunConsoleCommand("ulx", "force", pid, text:GetValue())
			end},
			{"SForce", "chart_pie", "SForce - type: traitor/innocent/detective", function(menu, frame, text)
				RunConsoleCommand("ulx", "sforce", pid, text:GetValue())
			end},
			{"ForceNR", "chart_line", "ForceNR - type: traitor/detective/unmark",  function(menu, frame, text)
				RunConsoleCommand("ulx", "forcenr", pid, text:GetValue())
			end},
		},
		{ -- Chat submenu
			{"Chat",       "page_white_text"}, -- {title, silk_icon}
			{"Gag",        "sound_mute",     {"ulx", "gag",    pid}},
			{"UnGag",      "sound",          {"ulx", "ungag",  pid}},
			{"Mute",       "comment_delete", {"ulx", "mute",   pid}},
			{"UnMute",     "comment",        {"ulx", "unmute", pid}},
			{"Gimp",       "comment_delete", {"ulx", "gimp",   pid}},
			{"UnGimp",     "comments",       {"ulx", "ungimp", pid}},
			{"PermaGag",   "sound_none",     {"ulx", "pgag",   pid}},
			{"UnPermaGag", "sound_low",      {"ulx", "unpgag", pid}},
		},
		{ -- Fun submenu
			{"Fun",      "rainbow"}, -- {title, silk_icon}
			{"Slap",     "emoticon_surprised", {"ulx", "slap",     pid}},
			{"Rocket",   "transmit",           {"ulx", "rocket",   pid}},
			{"Explode",  "bomb",               {"ulx", "explode",  pid}},
			{"Shock",    "lightning",          {"ulx", "shock",    pid}},
			{"Launch",   "arrow_up",           {"ulx", "launch",   pid}},
			{"Freeze",   "control_pause_blue", {"ulx", "freeze",   pid}},
			{"UnFreeze", "control_play_blue",  {"ulx", "unfreeze", pid}},
			{"Set HP",   "pill_go",            "Health Amount", function(menu, frame, text)
				RunConsoleCommand("ulx", "hp", pid, text:GetValue())
			end},
			{"100 HP", "pill", {"ulx", "hp", pid, "100"}},
		},
		{ -- More Fun submenu
			{"More Fun",   "cake"}, -- {title, silk_icon}
			{"Jail",       "lock",          {"ulx", "jail",        pid}},
			{"JailTele",   "lock_go",       {"ulx", "jailtp",      pid}},
			{"UnJail",     "lock_open",     {"ulx", "unjail",      pid}},
			{"Ignite",     "lightbulb",     {"ulx", "ignite",      pid}},
			{"Ungnite",    "lightbulb_off", {"ulx", "unignite",    pid}},
			{"UngniteAll", "lightbulb_off", {"ulx", "unigniteall", pid}},
		},
		{ -- Teleport submenu
			{"Teleport",    "arrow_undo"}, -- {title, silk_icon}
			{"Tele",        "group_go",     {"ulx", "teleport",  pid}},
			{"Bring",       "group_go",     {"ulx", "bring",     pid}},
			{"GoTo",        "group_go",     {"ulx", "goto",      pid}},
			{"Return",      "group_go",     {"ulx", "return",    pid}},
			{"FreezeTele",  "weather_snow", {"ulx", "fteleport", pid}},
			{"FreezeBring", "weather_snow", {"ulx", "fbring",    pid}},
		},
		{ -- Watching Stuff submenu
			{"Watching Stuff", "report_magnify"}, -- {title, silk_icon}
			{"Watchlist",      "application_view_list", {"ulx", "watchlist"}},
			{"Watch",          "report_edit", "Watch Reason", function(menu, frame, text)
				RunConsoleCommand("ulx", "watch", pid, text:GetValue())
			end},
			{"UnWatch", "report_delete", {"ulx", "unwatch", pid}}, -- 
		},
		{ -- Spectate submenu
			{"Spectate",        "webcam"}, -- {title, silk_icon}
			{"ForceSpec",       "status_offline", {"ulx", "fspec", pid}},
			{"UnSpec",          "status_online",  {"ulx", "unspec", pid}},
			{"AdminSpec",       "film",           {"ulx", "spectate", pid}},
			{"ScreenGrab Menu", "photos",         {"screengrab"}},
		},
	})
end

hook.Add("TTTScoreboardMenu", "cl_ttt_scoreboard_rightclick_stuff", function(menu)
	--print("right clicked on scoreboard")
	if right_click_stuff(menu) == false then
		return true
	end
end)


