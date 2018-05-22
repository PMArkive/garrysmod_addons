hook.Add("TTTKarmaLow", "sv_ttt_karma_superadmin_protect", function(ply)
	if ply:IsSuperAdmin() then return false end
end)
