-- MADE BY **

pudl_workshop_connecting = CreateConVar("pudl_workshop_connecting", "", FCVAR_REPLICATED, "The workshop collection that should be downloaded on clients when they connect")
pudl_workshop_ingame_force = CreateConVar("pudl_workshop_ingame_force", "", FCVAR_REPLICATED, "The workshop collection that should be downloaded after clients are ingame")
pudl_workshop_ingame_optional = CreateConVar("pudl_workshop_ingame_optional", "", FCVAR_REPLICATED, "The workshop collection that should have optionally downloadable addons that clients can select from after they're ingame")

function Pudl_msg(...)
	-- yellow & white
	local msg = {Color(255, 255, 0), "[PUDL] ", Color(255, 255, 255)}
	table.Add(msg, {...})
	if SERVER then
		msg[#msg+1] = "\n"
		MsgC(unpack(msg))
	else
		chat.AddText(unpack(msg))
	end
end

local function build_post_data(count_name, items)
	local postData = {
		["format"] = "json",
		[count_name] = tostring(#items),
	}
	for k,v in pairs(items) do
		postData["publishedfileids["..(k-1).."]"] = v
	end
	return postData
end

-- callback(err, addons)
function Pudl_QueryAddons(ids, callback)
	if not istable(ids) then
		ids = {ids}
	end

	local postData = build_post_data("itemcount", ids)
	http.Post(
		"https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1",
		postData,
		function(resp, len, headers, code)
			if code ~= 200 then
				callback("Status code != 200")
				return
			end

			local data = util.JSONToTable(resp)
			if not data or not data.response then
				callback("Missing response?")
				return
			end

			local addons = {}

			for k,v in ipairs(data.response.publishedfiledetails) do
				addons[v.publishedfileid] = v
			end

			callback(nil, addons)
		end,
		function(err)
			callback(err)
		end
	)
end

-- callback(err, collections)
function Pudl_QueryCollections(ids, callback)
	if not istable(ids) then
		ids = {ids}
	end

	local postData = build_post_data("collectioncount", ids)
	http.Post(
		"https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1",
		postData,
		function(resp, len, headers, code)
			if code ~= 200 then
				callback("Status code != 200")
				return
			end

			local data = util.JSONToTable(resp)
			if not data or not data.response then
				callback("Missing response?")
				return
			end

			local collections = {}

			for k,v in ipairs(data.response.collectiondetails) do
				collections[v.publishedfileid] = v.children
			end

			callback(nil, collections)
		end,
		function(err)
			callback(err)
		end
	)
end
