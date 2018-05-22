hook.Add("PlayerSay", "sv_random_chat_commands.lua", function(sender, text, team)
	if text == "/shrug" then
		return "¯\\_(ツ)_/¯"
	elseif text == "/shrug " then
		return "¯\\_(ツ)_/¯"
	elseif string.StartWith(text, "/shrug ") then
		--print(string.Trim(string.Trim(text:sub(8)) .. " ¯\\_(ツ)_/¯"))
		return string.Trim(string.Trim(text:sub(8)) .. " ¯\\_(ツ)_/¯")
	end
end, HOOK_HIGH)
