-- MADE BY **

PUDL_HAS_THUNK = PUDL_HAS_THUNK -- handle file refreshes
PUDL_NOT_FIRST_MAP = PUDL_NOT_FIRST_MAP

util.AddNetworkString("pudl_ingame_downloads")

-- to handle getting the addons done with and stuff with the Think
-- Think seems to be called at least once even if hibernate...
-- dunno
local last_sv_hibernate_think

hook.Add("Initialize", "pudl", function()
	-- test_http("Initialize")
	last_sv_hibernate_think = GetConVar("sv_hibernate_think"):GetString()
	RunConsoleCommand("sv_hibernate_think", "1")

	-- Some magic to check if this is right after server-start.
	-- ISteamHTTP isn't setup until Think.
	-- And callbacks aren't called if ISteamHTTP isn't setup.
	-- > HTTP failed - ISteamHTTP isn't available!
	http.Fetch("", function() Pudl_msg("huh?") end, function(e)
		if e ~= "invalid url" then
			Pudl_msg("HUHHHHH?")
		end

		PUDL_NOT_FIRST_MAP = true
		-- pudl_dont_touch:SetBool(true)
	end)
end)

local function add_connecting_addons(err, collections, connecting)
	RunConsoleCommand("sv_hibernate_think", last_sv_hibernate_think)

	if err then
		Pudl_msg("Failed to retrieve connecting addons - "..tostring(err))
		return
	end

	for _,collection in pairs(collections) do
		for _,addon in pairs(collection) do
			local workshopid = addon.publishedfileid
			resource.AddWorkshop(workshopid)
			Pudl_msg("Added Connecting addon - "..tostring(workshopid))
		end
	end

	if connecting then
		local name = "pudl_connecting_"..connecting..".txt"
		Pudl_msg("saving connecting addons to data/"..name)
		file.Write(name, util.TableToJSON(collections))
	end
end

hook.Add("Think", "pudl", function()
	hook.Remove("Think", "pudl")
	if PUDL_HAS_THUNK then
		Pudl_msg("Already thunky so no more | "..os.date())
		return
	end
	PUDL_HAS_THUNK = true

	Pudl_msg("Starting")

	local connecting = pudl_workshop_connecting:GetString()
	if connecting == "" then
		Pudl_msg("no connecting collection set")
		return
	end

	if PUDL_NOT_FIRST_MAP then
		local name = "pudl_connecting_"..connecting..".txt"
		local content = file.Read(name)
		if content and content ~= "" then
			Pudl_msg("reloading connecting addons from data/"..name)
			add_connecting_addons(nil, util.JSONToTable(content))
			return
		else
			Pudl_msg("missing file data/"..name)
		end
	end

	Pudl_msg("querying collection "..connecting)
	Pudl_QueryCollections(connecting, function(err, collections) 
		add_connecting_addons(err, collections, connecting)
	end)
end)

