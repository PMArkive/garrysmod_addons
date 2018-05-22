hook.Add("PostGamemodeLoaded", "wisp - sh_ttt_remove_announceversion.lua", function()
	origAnnounceVersion = AnnounceVersion
	AnnounceVersion = function() end
end)
