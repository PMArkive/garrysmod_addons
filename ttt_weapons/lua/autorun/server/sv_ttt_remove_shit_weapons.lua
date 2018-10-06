hook.Add("PostGamemodeLoaded", "sv_ttt_remove_shit_weapons", function()
	-- check out ent_replace.lua in the TTT gamemode

	local _,ReplaceAmmo = debug.getupvalue(ents.TTT.ReplaceEntities, 1)
	local _,ReplaceAmmoSingle = debug.getupvalue(ReplaceAmmo, 2)
	local _,hl2_ammo_replace = debug.getupvalue(ReplaceAmmoSingle, 1)

	hl2_ammo_replace["item_box_buckshot"] = "item_ammo_smg1_ttt"
	hl2_ammo_replace["item_healthkit"] = "weapon_zm_mac10"
	hl2_ammo_replace["item_ammo_crossbow"] = "item_ammo_smg1_ttt"
	hl2_ammo_replace["item_box_buckshot_ttt"] = "item_ammo_smg1_ttt"

	local _,ReplaceWeapons = debug.getupvalue(ents.TTT.ReplaceEntities, 2)
	local _,ReplaceWeaponSingle = debug.getupvalue(ReplaceWeapons, 2)
	local _,hl2_weapon_replace = debug.getupvalue(ReplaceWeaponSingle, 1)

	hl2_weapon_replace["weapon_shotgun"] = "weapon_zm_mac10"
	hl2_weapon_replace["weapon_zm_shotgun"] = "weapon_zm_mac10"

	local _,ImportEntities = debug.getupvalue(ents.TTT.ProcessImportScript, 4)
	local _,classremap = debug.getupvalue(ImportEntities, 1)

	classremap["weapon_zm_shotgun"] = "weapon_zm_mac10"
	classremap["item_box_buckshot_ttt"] = "item_ammo_smg1_ttt"
	classremap["weapon_zm_sledge"] = "weapon_ttt_m16"
end)
