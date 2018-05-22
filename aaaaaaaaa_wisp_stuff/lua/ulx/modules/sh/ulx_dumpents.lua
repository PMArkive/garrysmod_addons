local CATEGORY_NAME = "Misc"

local function b2str(b) -- tostring(b) would've worked
	if b then return "true" end
	return "false"
end

function ulx.dumpents(calling_ply)
	local filename = os.date("entdumps/%Y.%m.%d-%H.%M.%S.txt", os.time())

	if not file.Exists("entdumps", "DATA") then
		file.CreateDir("entdumps")
	end

	if file.Exists(filename, "DATA") then
		calling_ply:ChatPrint("File name already exists, not dumping!")
		return
	end

	calling_ply:ChatPrint("Starting entity dump!")
	calling_ply:ChatPrint("Dump file: " .. filename)

	local ents = ents.GetAll()
	local entnum = #ents

	file.Write(filename, "Total ents: " .. entnum .. "\r\n")

	local asdfasdf = "[%d] ['%s'|'%s'|'%s'|'%s']\r\n" ..
		"\tnpc: %s, ply: %s, ragdoll: %s,\r\n" ..
		"\tvehicle: %s, weapon: %s, world: %s, widget: %s,\r\n" ..
		"\tdormat: %s, constrained: %s, constraint: %s\r\n"

	calling_ply:ChatPrint("Starting entity dump loop!")

	for _, e in pairs(ents) do
		if IsValid(e) then--and e:EntIndex() >= 3 then
			local s = string.format(asdfasdf, e:EntIndex(), e:GetName(), e:GetClass(), e:GetModel(), e:GetMaterial(),
				b2str(e:IsNPC()), b2str(e:IsPlayer()), b2str(e:IsRagdoll()),
				b2str(e:IsVehicle()), b2str(e:IsWeapon()), b2str(e:IsWorld()), b2str(e:IsWidget()),
				b2str(e:IsDormant()), b2str(e:IsConstrained()), b2str(e:IsConstraint())
			)
			file.Append(filename, s)
		end
	end

	calling_ply:ChatPrint("Dumped " .. entnum .. " ents!")
end
local dumpents = ulx.command(CATEGORY_NAME, "ulx dumpents", ulx.dumpents, "!dumpents", true)
dumpents:defaultAccess("superadmin")
dumpents:help("Writes some entity information to a file.")
