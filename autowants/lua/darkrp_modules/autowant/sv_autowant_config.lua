--#NoSimplerr#

AutoWantConfig = {}

AutoWantConfig.WantedActor = "Police" -- "Who" made the player wanted.

AutoWantConfig.MultiMurder_Time = 120 -- if time between kills is less than this then ply:wanted()
AutoWantConfig.MultiMurder_Chance = 40
AutoWantConfig.MultiMurder_WantedTime = nil -- nil = uses GAMEMODE.Config.wantedtime
AutoWantConfig.MultiMurder_Reason = "Murder"

AutoWantConfig.Lockpick_Chance = 45
AutoWantConfig.Lockpick_WantedTime = nil -- nil = uses GAMEMODE.Config.wantedtime
AutoWantConfig.Lockpick_Reason = "Raiding"

AutoWantConfig.MasterLockpick_Chance = 40
AutoWantConfig.MasterLockpick_WantedTime = nil -- nil = uses GAMEMODE.Config.wantedtime

AutoWantConfig.KeypadCracker_Chance = 45
AutoWantConfig.KeypadCracker_WantedTime = nil -- nil = uses GAMEMODE.Config.wantedtime
AutoWantConfig.KeypadCracker_Reason = "Raiding"

AutoWantConfig.ProKeypadCracker_Chance = 40
AutoWantConfig.ProKeypadCracker_WantedTime = nil -- nil = uses GAMEMODE.Config.wantedtime
