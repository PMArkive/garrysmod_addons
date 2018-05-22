local things = {
	"team",
	"all",
}

function ulx.fsay(calling_ply, target_plys, team_chat, s)
	for k,v in pairs(target_plys) do
		v:Say(s, team_chat == "team")
	end

	ulx.fancyLogAdmin(calling_ply, true, "#A made #T say `"..s.."` in "..(team_chat and "team-chat" or "all-chat"), target_plys)
end
local fsay = ulx.command("Misc", "ulx fsay", ulx.fsay, "!fsay", true)
fsay:addParam{ type=ULib.cmds.PlayersArg }
fsay:addParam{ type=ULib.cmds.StringArg, completes=things }
fsay:addParam{ type=ULib.cmds.StringArg, ULib.cmds.takeRestOfLine }
fsay:defaultAccess("superadmin")

function ulx.fcom(calling_ply, target_plys, s)
	for k,v in pairs(target_plys) do
		v:ConCommand(s)
	end

	ulx.fancyLogAdmin(calling_ply, true, "#A made #T run `"..s.."`", target_plys)
end
local fcom = ulx.command("Misc", "ulx fcom", ulx.fcom, "!fcom", true)
fcom:addParam{ type=ULib.cmds.PlayersArg }
fcom:addParam{ type=ULib.cmds.StringArg, ULib.cmds.takeRestOfLine }
fcom:defaultAccess("superadmin")
