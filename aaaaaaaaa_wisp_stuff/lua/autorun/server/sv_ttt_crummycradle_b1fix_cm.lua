-- deletes the bottles?

local bad = {
	"models/props_junk/physics_trash",
	"models/props_wasteland/controlroom_chair001a.mdl",
	"models/props/cs_militia/barstool01.mdl",
	"models/props/cs_militia/bottle02.mdl",
	"models/props_junk/garbage_glassbottle003a.mdl",
	"models/props_junk/glassbottle01a.mdl",
	"models/props/cs_militia/caseofbeer01.mdl"
}

-- there's problems with lots of models
hook.Add("TTTPrepareRound", "crummycradle_remove_shit_props", function()
	if game.GetMap()) ~= "ttt_crummycradle_b1fix_cm" then return end
	for _,model in ipairs(bad) do
		for _, ent in ipairs(ents.FindByModel(model)) do
			ent:Remove()
		end
	end
end)
