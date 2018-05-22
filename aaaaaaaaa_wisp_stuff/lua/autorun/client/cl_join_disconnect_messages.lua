 net.Receive("join_disconnect_messages", function()
	local thing = net.ReadTable()
	-- for k,v in pairs(thing) do
		-- if istable(v) then
			-- thing[k] = Color(v[1], v[2], v[3])
		-- end
	-- end
	chat.AddText(unpack(thing))
end)