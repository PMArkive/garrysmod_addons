hook.Add("PostGamemodeLoaded", "sv_ttt_karma_remove_damagefactor", function()
	local meta = FindMetaTable("Player")
	function meta:SetDamageFactor(x)
		return
	end
	function meta:GetDamageFactor()
		return 1.0
	end
end)
