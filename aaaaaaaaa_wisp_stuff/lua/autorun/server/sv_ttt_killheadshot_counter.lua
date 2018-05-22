hook.Add("PlayerSpawn", "sv_ttt_killheadshot_counter.lua", function(ply)
	ply:SetNWInt("headshots", 0)
	ply:SetNWInt("kills", 0)
end)

hook.Add("DoPlayerDeath", "sv_ttt_killheadshot_counter.lua", function(ply, attacker, dmg)
	if not attacker:IsPlayer() then return end
	attacker:SetNWInt("kills", attacker:GetNWInt("kills") + 1)
	if ply:LastHitGroup() == HITGROUP_HEAD then
		attacker:SetNWInt("headshots", attacker:GetNWInt("headshots") + 1)
	end
end)

hook.Add("OnNPCKilled", "sv_ttt_killheadshot_counter.lua", function(npc, attacker, inflictor)
	if not attacker:IsPlayer() then return end
	attacker:SetNWInt("kills", attacker:GetNWInt("kills") + 1)
end)
