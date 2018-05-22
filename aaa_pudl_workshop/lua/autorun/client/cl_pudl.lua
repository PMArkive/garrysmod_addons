-- MADE BY **

local optional_addons_cache = nil
local force_addons_cache = nil

local function mount_addon(addon)
	print("[PUDL] Mounting " .. v.title)
	game.MountGMA("cache/workshop/" .. addon.hcontent_preview .. ".cache")
end

-- WorkshopEnd
-- hook.Add("WorkshopDownloadedFile", function(id, title)
	-- for k,v in pairs(optional_addons_cache) do
		-- if v.publishedfileid == id then
			-- mount_addon(v)
			-- return
		-- end
	-- end

	-- for k,v in pairs(force_addons_cache) do
		-- if v.publishedfileid == id then
			-- mount_addon(v)
			-- return
		-- end
	-- end
-- end)

-- local function build_post_data(count_name, items)
	-- local postData = {
		-- ["format"] = "json",
		-- [count_name] = tostring(#items),
	-- }
	-- for k,v in ipairs(items) do
		-- postData["publishedfileids["..(k-1).."]"] = v
	-- end
	-- return postData
-- end

-- local function test_getcollectiondetails()
	-- local ids = {
		-- "1",
		-- "1",
	-- }
	-- local postData = build_post_data("collectioncount", ids)
	-- http.Post("https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1", postData,
	-- function(resp, len, headers, code)
		-- print(" ")
		-- print(resp)
		-- print(len)
		-- PrintTable(headers)
		-- print(code)
		-- BIG_BOI = resp
	-- end,
	-- function(err)
		-- print(" ")
		-- print(err)
	-- end)
-- end

-- local function test_getpublishedfiledetails()
	-- local ids = {
		-- -- "1",
		-- "1",
		-- "1",
	-- }
	-- local postData = build_post_data("itemcount", ids)
	-- http.Post("https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1", postData,
	-- function(resp, len, headers, code)
		-- print(" ")
		-- print(resp)
		-- print(len)
		-- PrintTable(headers)
		-- print(code)
		-- BIG_BOI = resp
	-- end,
	-- function(err)
		-- print(" ")
		-- print(err)
	-- end)
-- end

-- BIG_BOI = BIG_BOI
-- if true then
	-- -- test_getcollectiondetails()
	-- -- test_getpublishedfiledetails()
-- end

local function force_addons_handler()
	-- what to do next I wonder

	for k,v in ipairs(force_addons_cache) do

	end
end

if IsValid(ASDFASDF) then ASDFASDF:Remove() ASDFASDF = nil end
local function open_optional_ui(collectionid, addons)
	local itemh = 60

	local frame = vgui.Create("DFrame")
	ASDFASDF = frame
	frame:SetSize(650, 524)
	frame:SetTitle("")
	frame:SetIcon("icon16/rainbow.png")
	-- frame:SetDraggable(false)
	frame:SetSizable(true)
	-- frame:ShowCloseButton(false)
	frame:MakePopup()

	local info_panel = vgui.Create("DPanel", frame)
	info_panel:Dock(TOP)
	info_panel:SetHeight(100)
	info_panel:SetBackgroundColor(Color(0,0,0,0))

	local info_text = vgui.Create("DLabel", info_panel)
	info_text:SetText("This is a list of optional addons.\nYou may have to restart your game.\nReopen with `!addons`")
	-- info_text:SetTextColor(Color(0,0,0))
	info_text:SetFont("DermaLarge")
	-- info_text:SizeToContents()
	-- info_text:SetSize(
	info_text:Dock(FILL)

	-- local panel = scrollpanel:Add("DPanel")
	-- panel:Dock(TOP)
	-- panel:SetSize(0, itemh)
	-- panel:DockMargin(0,0,0,5)
	local collection = vgui.Create("DButton", frame)
	collection.publishedfileid = collectionid
	collection:SetText("View entire collection")
	collection:SetTextColor(Color(0,0,0))
	collection:SetFont("DermaLarge")
	-- collection:SetSize(0, itemh)
	collection:SetHeight(itemh)
	collection:DockMargin(0,5,0,5)
	collection:Dock(TOP)
	function collection:DoClick()
		steamworks.ViewFile(self.publishedfileid)
	end

	local scrollpanel = vgui.Create("DScrollPanel", frame)
	scrollpanel:Dock(FILL)

	for k,v in ipairs(addons) do
		local panel = scrollpanel:Add("DPanel")
		panel:Dock(TOP)
		panel:SetSize(0, itemh)
		panel:DockMargin(0,0,0,5)
		if (k % 2) ~= 0 then
			panel:SetBackgroundColor(Color(0,255,255))
		else
			panel:SetBackgroundColor(Color(231, 231, 231))
		end

		local download = vgui.Create("DButton", panel)
		download.publishedfileid = v.publishedfileid
		download:SetText("sub")
		download:SetTextColor(Color(0,0,0))
		download:SetFont("DermaLarge")
		download:DockMargin(4,4,10,4)
		download:Dock(LEFT)
		function download:DoClick()
			steamworks.ViewFile(self.publishedfileid)
		end
		function download:Think()
			local is_disabled = steamworks.IsSubscribed(self.publishedfileid)
			self:SetDisabled(is_disabled)
			local color = Color(0,0,0)
			if is_disabled then
				color = Color(0,0,0,100)
			end
			self:SetTextColor(color)
		end

		local name = vgui.Create("DLabel", panel)
		name:SetText(v.title)
		name:SetTextColor(Color(0,0,0))
		name:SetFont("DermaLarge")
		name:SizeToContents()
		name:Dock(TOP)

		local size = vgui.Create("DLabel", panel)
		size:SetText(string.NiceSize(v.file_size))
		size:SetTextColor(Color(0,100,0))
		size:SetFont("DermaLarge")
		size:SizeToContents()
		size:Dock(BOTTOM)
	end
	-- print(scrollpanel:GetVBar().Enabled)

	frame:SetSize(650, 524)

	-- frame:InvalidateLayout(true)
	-- frame:InvalidateChildren(true)

	local blah = #addons
	-- if not scrollpanel:GetVBar().Enabled then
	if blah < 5 then
		frame:SetTall(frame:GetTall() - (5-blah)*(itemh+5))
	end

	frame:Center()
end

local function addons_handler(err, addons, action, special_addons)
	if err then
		Pudl_msg("Failed to retrieve addons - "..tostring(err))
		return
	end

	local force = {}
	local optional = {}

	for k,v in pairs(addons) do
		-- if steamworks.IsSubscribed(k) and not steamworks.ShouldMountAddon(k) then
			-- mount_addon(v)
		-- end
		if special_addons[k] then
			force[#force+1] = v
		else
			optional[#optional+1] = v
		end
	end

	if #force > 0 then
		force_addons_cache = force
		force_addons_handler()
	end

	if #optional > 0 then
		optional_addons_cache = optional
		local open = false
		if action == "chat" then
			open = true
		elseif action == "hudpaint" then
			for k,v in ipairs(optional) do
				if not steamworks.IsSubscribed(v.publishedfileid) then
					open = true
					break
				end
			end
		end

		if open then
			open_optional_ui(pudl_workshop_ingame_optional:GetString(), optional)
		end
	end
end

local function collections_handler(err, collections, action)
	if err then
		Pudl_msg("Failed to retrieve collections - "..tostring(err))
		return
	end

	local special_addons = {}

	local optional = collections[pudl_workshop_ingame_optional:GetString()] or {}
	for k,v in pairs(optional) do
		special_addons[v.publishedfileid] = false
	end

	local force = collections[pudl_workshop_ingame_force:GetString()] or {}
	for k,v in pairs(force) do
		special_addons[v.publishedfileid] = true
	end

	if pairs(special_addons) == nil then return end

	local array = {}
	for k,v in pairs(special_addons) do
		array[#array+1] = k
	end

	-- PrintTable(array)
	Pudl_QueryAddons(array, function(err, addons)
		addons_handler(err, addons, action, special_addons)
	end)
end

local function refresh_addons(action)
	local collections = {}
	local force = pudl_workshop_ingame_force:GetString()
	local optional = pudl_workshop_ingame_optional:GetString()
	if force ~= "" then
		table.insert(collections, force)
	end
	if optional ~= "" then
		table.insert(collections, optional)
	end

	if #collections < 1 then return end

	Pudl_QueryCollections(collections, function(err, collections)
		collections_handler(err, collections, action)
	end)
end

hook.Add("OnPlayerChat", "pudl", function(plr, text)
	if plr == LocalPlayer() then
		if string.StartWith(text, "/addons") or string.StartWith(text, "!addons") then
			refresh_addons("chat")
			timer.Simple(0, function() Pudl_msg("loading menu...") end)
		end
	end
end, HOOK_MONITOR_HIGH)

-- HUDPaint starts when the player is actaully there ingame.
hook.Add("HUDPaint", "pudl", function()
	hook.Remove("HUDPaint", "pudl")

	refresh_addons("hudpaint")

	-- open_optional_ui(1, {
		-- {
			-- publishedfileid = "184512071",
			-- hcontent_preview = "5555",
			-- title = "Metal Gear Solid 3: Big Boss Playermodel",
			-- file_size = 6984000,
		-- },
		-- {
			-- publishedfileid = "295788137",
			-- hcontent_preview = "6234",
			-- title = "WATCH_DOGS: Aiden Pearce Playermodel",
			-- file_size = 22070000,
		-- },
		-- {
			-- publishedfileid = "1293789956",
			-- hcontent_preview = "27787",
			-- title = "Wisp Kraft Model",
			-- file_size = 2872000,
		-- },
		-- {
			-- publishedfileid = "311035919",
			-- hcontent_preview = "2712787",
			-- title = "UNSC Marine Playermodel",
			-- file_size = 1258000,
		-- },
		-- {
			-- publishedfileid = "908040809",
			-- hcontent_preview = "27787",
			-- title = "Tohru P.M. & NPC",
			-- file_size = 3199000,
		-- },
	-- })
end)

-- net.Receive("pudl_ingame_downloads", function()
	-- local addons = {}
	-- local count = net.ReadUInt(16)

	-- if count == 0 then return end

	-- while count > 0 do
		-- count = count - 1
		-- local t = {}
		-- t.publishedfileid = net.ReadString()
		-- t.hcontent_preview = net.ReadString() -- the steamworks.Download previewid
		-- t.title = net.ReadString()
		-- t.file_size = net.ReadUInt(32)
		-- addons[#addons+1] = t
	-- end
-- end)
