
local function asdf()
	SH_TTT_WEAPON_OVERRIDES = true

	local SWEP = util.WeaponForClass("weapon_ttt_knife")
	SWEP.Primary.Damage = 1000
	SWEP.DeploySpeed = 1.19
	SWEP.CanBuy = nil -- Remove it from the T menu.

	local SWEP = util.WeaponForClass("weapon_zm_shotgun") -- Auto Shotty
	if SWEP then
		SWEP.Primary.Cone = 0.15
		SWEP.Primary.Damage = 10
		SWEP.AutoSpawnable = false
	end
	
	local ENT = scripted_ents.GetStored("item_box_buckshot_ttt")
	if SWEP then
		ENT.AutoSpawnable = false
	end
	
	local SWEP = util.WeaponForClass("weapon_ttt_g3") -- Stupid fucking gun
	if SWEP then
		SWEP.AutoSpawnable = false
	end

	local SWEP = util.WeaponForClass("weapon_ttt_sg550") -- Stupid fucking gun2
	if SWEP then
		SWEP.AutoSpawnable = false
	end
	
	local SWEP = util.WeaponForClass("weapon_ttt_aug") -- Stupid fucking gun3
	if SWEP then
		SWEP.AutoSpawnable = false
	end
	
	local SWEP = util.WeaponForClass("weapon_ttt_p90") -- Stupid fucking gun4
	if SWEP then
		SWEP.AutoSpawnable = false
	end
	
	local SWEP = util.WeaponForClass("weapon_ttt_p228g") -- Stupid fucking gun5
	if SWEP then
		SWEP.AutoSpawnable = false
	end
	
	local SWEP = util.WeaponForClass("weapon_ttt_sg552") -- Stupid fucking gun6
	if SWEP then
		SWEP.AutoSpawnable = false
	end

	local SWEP = util.WeaponForClass("weapon_zm_sledge") -- HUGE
	SWEP.Primary.Damage = 8
	SWEP.Primary.Delay = 0.08
	SWEP.Primary.DefaultClip = 150
	SWEP.Primary.Recoil = 1.85
	SWEP.AutoSpawnable = false
	
	local SWEP = util.WeaponForClass("weapon_zm_rifle")
	SWEP.Primary.Cone = 0 --.004
	
	local SWEP = util.WeaponForClass("weapon_ttt_glock")
	SWEP.Primary.Recoil	= 0.85
	SWEP.Primary.Cone = 0.033 -- vanilla is 0.028
	SWEP.Primary.ClipSize = 25 -- vanilla is 20
	SWEP.Primary.DefaultClip = 25 -- vanilla is 20
	SWEP.Primary.ClipMax = 75 -- vanilla is 60
	
	local SWEP = util.WeaponForClass("weapon_zm_mac10")
	SWEP.Primary.Recoil      = 1.17 --**--1.15
	SWEP.Primary.Damage      = 13 -- 12
	SWEP.Primary.Delay       = 0.073 -- previous 0.065
	SWEP.Primary.Cone        = 0.032 --0.03, Previous 0.052
	
	local SWEP = util.WeaponForClass("weapon_ttt_glock")
	SWEP.HeadshotMultiplier = 2.00
	
	local SWEP = util.WeaponForClass("weapon_ttt_m16")
	function SWEP:AdjustMouseSensitivity()
		return (self:GetIronsights() and 0.4) or nil
	end
end

if SERVER then
	local health_station_heart_sound = Sound("zelda/tp_get_heart.wav")

	hook.Add("EntityEmitSound", "sh_ttt_weapons_overrides.lua", function(data)
		if data.Entity:GetClass() == "ttt_health_station" then
			if data.SoundName == "items/medshotno1.wav" then
				-- this is the out-of-health sound
				return
			end
			data.SoundName = health_station_heart_sound
			data.OriginalSoundName = health_station_heart_sound
			return true
		end
	end)
end

if SH_TTT_WEAPON_OVERRIDES then
	asdf()
end

hook.Add("InitPostEntity", "sh_ttt_weapons_overrides.lua", asdf)
