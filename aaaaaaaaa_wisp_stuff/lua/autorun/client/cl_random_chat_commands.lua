hook.Add("OnPlayerChat", "wisp - cl_random_commands.lua", function(plr, text)
	if plr == LocalPlayer() then
		if string.StartWith(text, "!stopsound") then
			RunConsoleCommand("stopsound")
		elseif string.StartWith(text, "!invis") then
			RunConsoleCommand("record", "invis")
			RunConsoleCommand("stop")
		elseif string.StartWith(text, "!mapname") then
			timer.Simple(0, function()
				chat.AddText(Color(255, 255, 255), "Map name = ", Color(0, 200, 0), game.GetMap())
			end)
		end
	end
end)
