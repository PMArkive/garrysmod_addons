local function wlog(...)
	chat.AddText(Color(0,0,0), ...)
end

wlog(Color(255,255,255), "=== refreshed ==== "..os.date())

-- accessories (paint), trails(?), plymodels, donor plymodels, hats, misc

-- frame_items IS GLOBAL
if IsValid(frame_items) then frame_items:Remove() end

local color_generic_background = Color(108, 111, 114)
local model_bindings_cookie = "wisp_items_model_bindings"
local function ShouldUsePuffsBindings()
	return tobool(cookie.GetNumber(model_bindings_cookie, 0))
end

-- effectively global
--local frame_items
local _panel_root
local panel_items_base
local panel_preview_base
local sheet_items
local sheet_preview
local sheet_preview_options
local preview_self
local preview_item
local seq_scroll

local function _set_selected_sequence_button(button)
	local prev_button = seq_scroll.selected_button
	if IsValid(prev_button) then
		prev_button:SetImage(nil)
	end

	seq_scroll.selected_button = button
	button:SetImage("icon16/accept.png")
end

local function set_selected_sequence(seq)
	for k,v in ipairs(seq_scroll:GetCanvas():GetChildren()) do
		if k-1 == seq then -- children uses 1-based and sequences use 0-based
			_set_selected_sequence_button(v)
			return
		end
	end
end

local function make_sequences(ent)
	for k,v in ipairs(seq_scroll:GetCanvas():GetChildren()) do
		v:Remove()
	end

	local seq = ent:GetSequence()
	-- wlog("model sequence = "..seq)
	for k,v in pairs(ent:GetSequenceList() or {}) do
		local button = seq_scroll:Add("DButton")
		local act_name = ent:GetSequenceActivityName(k)
		local text
		if act_name ~= "" then
			text = v.."/"..act_name
		else
			text = v
		end
		button:SetText(text)
		button:Dock(TOP)
		if k == seq then
			_set_selected_sequence_button(button)
		end
		function button:DoClick()
			_set_selected_sequence_button(self)

			if not IsValid(ent) then return end

			-- if ent:GetSequence() == k then
				ent:ResetSequence(k)
			-- else
				-- ent:SetSequence(k)
			-- end
		end
		function button:DoRightClick()
			local menu = DermaMenu()
			menu:AddOption("Copy ", function()
				SetClipboardText(text)
			end)
			menu:AddOption("Copy sequence name"..(act_name ~= "" and " (left)" or ""), function()
				SetClipboardText(v)
			end)
			if act_name ~= "" then
				menu:AddOption("Copy activity name (right)", function()
					SetClipboardText(act_name == "" and " " or act_name)
				end)
			end
			menu:AddSpacer()
			menu:AddOption("Close", function() end)
			menu:Open()
		end
	end
end

local function preview__OnMouseReleased(self, mousecode)
	self:SetCursor("hand")
	return self:old_OnMouseReleased(mousecode)
end

local function preview__OnMousePressed(self, mousecode)
	self:SetCursor("blank")
	mousecode = MOUSE_RIGHT -- force the right click functionality
	return self:old_OnMousePressed(mousecode)
end

local function preview__FirstPersonControls(self)
	local x, y = self:CaptureMouse()

	local scale = self:GetFOV() / 180
	x = x * -0.5 * scale
	y = y * 0.5 * scale

	-- Look around
	self.aLookAngle = self.aLookAngle + Angle( y, x, 0 )

	local Movement = Vector( 0, 0, 0 )

	local puffs = ShouldUsePuffsBindings()
	local up     = puffs and KEY_E or KEY_W
	local left   = puffs and KEY_S or KEY_A
	local down   = puffs and KEY_D or KEY_S
	local right  = puffs and KEY_F or KEY_D
	local crouch = puffs and KEY_LSHIFT or KEY_LCONTROL

	-- TODO: Use actual key bindings, not hardcoded keys.
	if ( input.IsKeyDown( up ) || input.IsKeyDown( KEY_UP ) ) then Movement = Movement + self.aLookAngle:Forward() end
	if ( input.IsKeyDown( down ) || input.IsKeyDown( KEY_DOWN ) ) then Movement = Movement - self.aLookAngle:Forward() end
	if ( input.IsKeyDown( left ) || input.IsKeyDown( KEY_LEFT ) ) then Movement = Movement - self.aLookAngle:Right() end
	if ( input.IsKeyDown( right ) || input.IsKeyDown( KEY_RIGHT ) ) then Movement = Movement + self.aLookAngle:Right() end
	if ( input.IsKeyDown( KEY_SPACE ) ) then Movement = Movement + self.aLookAngle:Up() end
	if ( input.IsKeyDown( crouch ) ) then Movement = Movement - self.aLookAngle:Up() end


	local is_speed_down
	if puffs then
		is_speed_down = function()
			return input.IsKeyDown(KEY_V)
		end
	else
		is_speed_down = input.IsShiftDown
	end

	local speed = 0.5
	if ( is_speed_down() ) then speed = 1.0 end

	self.vCamPos = self.vCamPos + Movement * speed
end

local function preview_reset(preview)
	preview:SetLookAt(Vector(0,0,0))
	preview:SetCamPos(Vector(-55, 0, 40))
	preview.Entity:SetAngles(Angle(0, 180, 0))
	preview:Init()
end

local function Build_Tab_Generic(sheet, name, icon, noStretchX, noStretchY, tooltip)
	local panel = vgui.Create("DPanel", sheet)
	panel:SetBackgroundColor(color_generic_background)

	sheet:AddSheet(name, panel, icon, noStretchX, noStretchY, tooltip)
	sheet:InvalidateLayout(true) -- so we can actually retreive the tab's size while creating panels
	return panel
end

local function Build_Tab_AboutSettings(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"About & Settings",
		"icon16/emoticon_tongue.png",
		nil,
		nil,
		"Where it says ** made this and some settings for the addon"
	)

	local font = "DebugFixed"
	local text_x = 10

	local createdby_a = vgui.Create("DLabel", tab)
	createdby_a:SetFont(font)
	createdby_a:SetTextColor(Color(255, 255, 255, 255))
	createdby_a:SetText("Hi, this was made by ")
	createdby_a:SetPos(text_x, 0)
	createdby_a:SizeToContents()

	local createdby_b = vgui.Create("DLabel", tab)
	createdby_b:SetTextColor(Color(0, 255, 0, 255))
	createdby_b:SetFont(font)
	createdby_b:SetText("** (STEAM_0:0:**) <-- click me!")
	createdby_b:SetMouseInputEnabled(true)
	createdby_b:SetPos(text_x + createdby_a:GetContentSize(), 0)
	createdby_b:SizeToContents()
	function createdby_b:DoClick()
		gui.OpenURL("https://steamcommunity.com/profiles/**")
	end
	createdby_b:SetCursor("hand")
	function createdby_b:Paint(w, h)
		surface.SetDrawColor(createdby_b:GetTextColor())
		surface.DrawLine(0, h-1, w, h-1)
		-- return true
	end

	local model_bindings = vgui.Create("DCheckBoxLabel", tab)
	-- model_bindings:SetFont(font)
	model_bindings:SetText("Use **'s bindings for the model viewer?\n(ESDF > WASD, Shift=crouch, V=+speed)")
	model_bindings:SetValue(cookie.GetNumber(model_bindings_cookie, 0))
	model_bindings:SetPos(8, 20)
	function model_bindings:OnChange(enabled)
		cookie.Set(model_bindings_cookie, enabled and 1 or 0)
	end
end

local function __Build_Models(tab, sheet)

end

local function Build_Tab_PlayerModels(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Player Models",
		"icon16/user.png",
		nil,
		nil,
		"The player models that any player can use"
	)
end

local function Build_Tab_Hats(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Hats",
		"icon16/bricks.png",
		nil,
		nil,
		"hats, duh"
	)
end

local function Build_Tab_Other(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Other",
		"icon16/palette.png",
		nil,
		nil,
		"Model painting and other stuff"
	)
end

local function __Build_Model_Preview(tab)
	local preview = vgui.Create("DAdjustableModelPanel", tab)
	preview:Dock(FILL)
	preview:SetAnimated(true)
	-- preview:SetAnimSpeed(10)
	preview.old_LayoutEntity = preview.LayoutEntity
	function preview:LayoutEntity(Entity)
		if ( self.bAnimated ) then
			self:RunAnimation()
		end
	end
	-- God fucking bless Kogitsune
	-- https://gmod.facepunch.com/f/gmoddev/nomf/Looping-a-Sequence/1/#posteqioh
	function preview:RunAnimation()
		local ent = self.Entity
		if ent:GetCycle() == 1 then
			ent:SetCycle(0)
		else
			ent:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )
		end
	end
	preview.old_OnMousePressed = preview.OnMousePressed
	preview.old_OnMouseReleased = preview.OnMouseReleased
	preview.OnMousePressed = preview__OnMousePressed
	preview.OnMouseReleased = preview__OnMouseReleased
	preview.FirstPersonControls = preview__FirstPersonControls
	preview:InvalidateParent(true)

	local reset_position = vgui.Create("DButton", preview)
	reset_position:SetText("Reset Position")
	reset_position:SizeToContents()
	function reset_position:DoClick()
		preview_reset(preview)
	end

	local reset_sequence = vgui.Create("DButton", preview)
	reset_sequence:SetText("Reset Sequence")
	reset_sequence:SizeToContents()
	function reset_sequence:DoClick()
		local ent = preview.Entity

		local iSeq = ent:LookupSequence( "walk_all" )
		if ( iSeq <= 0 ) then iSeq = ent:LookupSequence( "WalkUnarmed_all" ) end
		if ( iSeq <= 0 ) then iSeq = ent:LookupSequence( "walk_all_moderate" ) end

		if ( iSeq <= 0 ) then iSeq = 1 end
		ent:ResetSequence( iSeq )

		set_selected_sequence(iSeq)
	end

	-- Keep our button sizes the same.
	-- (we know their sizes from the :SizeToContents() calls above)
	local pw, ph = reset_position:GetSize()
	local sw, sh = reset_sequence:GetSize()
	-- Using the size of the larger button.
	local maxw, maxh = math.max(pw, sw), math.max(ph, sh)
	reset_position:SetSize(maxw, maxh)
	reset_sequence:SetSize(maxw, maxh)
	-- panel-DPropertySheet-DTab-DPanel(from Build_Tab_Generic)
	local tabw, tabh = tab:GetParent():GetActiveTab():GetPanel():GetSize()
	reset_position:SetPos(tabw-maxw, tabh-maxh*2) -- second button space from the bottom
	reset_sequence:SetPos(tabw-maxw, tabh-maxh) -- first button space from the bototm

	local usage = vgui.Create("DLabel", preview)
	usage.preview = preview
	usage:SetText("")
	usage:SizeToContents()
	usage:SetPos(5, 0)
	usage.old_Think = usage.Think
	-- change the text if the cookie has changed (or first time thinking)
	function usage:Think()
		self:old_Think()
		if usage.puffs ~= ShouldUsePuffsBindings() then
			usage.puffs = ShouldUsePuffsBindings()
			usage:SetText(usage.puffs and "Hold Mouse1 & ESDF, shift, space, V" or "Hold Mouse1 & WASD, control, space, shift")
			usage:SizeToContents()
		end
	end

	return preview
end

local function Build_Tab_PreviewSelf(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Preview Self",
		"icon16/user.png",
		nil,
		nil,
		"Where you can view your model & items on you"
	)

	preview_self = __Build_Model_Preview(tab)
	local m = LocalPlayer():GetModel()
	-- local m = "models/player/t_leet.mdl"
	-- local m = "models/props_c17/oildrum001.mdl"
	preview_self:SetModel(m)
	preview_reset(preview_self)
end

local function Build_Tab_PreviewItem(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Preview Item",
		"icon16/new.png",
		nil,
		nil,
		"Where you can view items without applying them to yourself"
	)
	-- wlog(tostring(tab))
	-- tab:GetPanel():InvalidateLayout(true)

	preview_item = __Build_Model_Preview(tab)
	local m = LocalPlayer():GetModel()
	-- local m = "models/player/t_leet.mdl"
	-- local m = "models/props_c17/oildrum001.mdl"
	preview_item:SetModel(m)
	preview_reset(preview_item)
end

local function Build_Tab_Outfits(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Outfits",
		"icon16/disk.png",
		nil,
		nil,
		"Where you can save item combinations"
	)
end

local function Build_Tab_Sequences(sheet)
	local tab = Build_Tab_Generic(
		sheet,
		"Sequences",
		"icon16/pencil.png",
		nil,
		nil,
		"Where you can select your player model's animation/sequence"
	)

	seq_scroll = vgui.Create("DScrollPanel", tab)
	seq_scroll:Dock(FILL)

	-- local refresh = seq_scroll:Add("DButton")
	-- refresh:SetText("(REFRESH)")
	-- refresh:Dock(TOP)
	-- refresh:SetImage("icon16/arrow_refresh.png")
	-- -- refresh:SetColor(Color(0,0,0))
	-- function refresh:DoClick()

	-- end

	make_sequences(preview_self.Entity)
end

local function Build_Frame_Items()
	frame_items = vgui.Create("DFrame")
	frame_items:SetSize(910, 684)
	frame_items:SetTitle("  W I S P    I T E M S")
	frame_items:SetIcon("icon16/rainbow.png")
	frame_items:SetDeleteOnClose(false)
	-- frame_items:Center()
	frame_items:SetPos(54, 1)
	frame_items:MakePopup()

	_panel_root = vgui.Create("DPanel", frame_items)
	_panel_root:Dock(FILL)
	_panel_root:InvalidateParent(true)
	_panel_root:SetBackgroundColor(color_generic_background)

	-- should be 900,600
	local usable_width, usable_height = _panel_root:GetSize()
	-- wlog("_panel_root w,h = "..usable_width .. "," .. usable_height)

	panel_items_base = vgui.Create("DPanel", _panel_root)
	panel_items_base:Dock(FILL)
	-- panel_items_base:SetSize(usable_width/3*2, usable_height)
	panel_items_base:SetBackgroundColor(color_generic_background)

	sheet_items = vgui.Create("DPropertySheet", panel_items_base)
	sheet_items:Dock(FILL)
	-- sheet_items:DockMargin(0,0,0,0)
	sheet_items:InvalidateParent(true)
	
	local inner_frame = vgui.Create("DFrame", panel_items_base)
	local left,top,right,bottom = inner_frame:GetDockPadding()
	inner_frame:SetTitle("  C L I C K   M E   F O R   M O R E")
	inner_frame:SetIcon("icon16/cake.png")
	inner_frame:Dock(BOTTOM)
	-- inner_frame:DockMargin(0,0,0,0)
	inner_frame:SetSize(0, top-bottom)
	-- inner_frame:SetSize(0, usable_height/2)
	inner_frame:InvalidateParent(true)
	inner_frame:SetDeleteOnClose(false)
	inner_frame.btnClose:SetVisible(false)
	inner_frame.btnMinim:SetVisible(false)
	inner_frame.btnMaxim:SetVisible(false)
	-- inner_frame.btnClose:SetDisabled(true)
	-- inner_frame.btnClose:SetParent(inner_frame)
	-- -- inner_frame.btnMinim:SetDisabled(false)
	-- inner_frame.btnMinim:SetParent(inner_frame)
	-- inner_frame.btnMaxim:SetDisabled(false)
	-- -- inner_frame.btnMaxim:SetParent(inner_frame)
	-- function inner_frame.btnMinim:DoClick(button)
		-- inner_frame:SetSize(0, top+bottom)
		-- inner_frame.btnMinim:SetDisabled(true)
		-- inner_frame.btnMaxim:SetDisabled(false)
	-- end
	-- function inner_frame.btnMaxim:DoClick(button)
		-- inner_frame:SetSize(0, usable_height/2)
		-- inner_frame.btnMinim:SetDisabled(false)
		-- inner_frame.btnMaxim:SetDisabled(true)
	-- end
	-- inner_frame.old_OnStopDragging = inner_frame.OnStopDragging
	-- function inner_frame:OnStopDragging()
		-- wlog("eh")
		-- self:old_OnStopDragging()
		-- inner_frame:SetSize(0, usable_height/2)
		-- inner_frame.btnMinim:SetDisabled(false)
		-- inner_frame.btnMaxim:SetDisabled(true)
	-- end
	inner_frame.lblTitle:SetMouseInputEnabled(true)
	inner_frame.lblTitle:SetTextColor(Color(255,255,255))
	function inner_frame.lblTitle:DoClick()
		inner_frame.expanded = not inner_frame.expanded
		if inner_frame.expanded then
			inner_frame:SetTitle("  C L I C K   M E   F O R   < L E S S >")
			inner_frame:SetSize(0, usable_height/2)
		else
			inner_frame:SetTitle("  C L I C K   M E   F O R   < M O R E >")
			inner_frame:SetSize(0, top-bottom)
		end
		-- wlog("eh")
	end
	-- function inner_frame:OnClose()
		-- self:SetSize(0, 40)
		-- -- self:Dock(BOTTOM)
		-- self:SetVisible(true)
	-- end

	Build_Tab_AboutSettings(sheet_items)
	Build_Tab_PlayerModels(sheet_items)
	Build_Tab_Hats(sheet_items)
	Build_Tab_Other(sheet_items)
	-- Build_Tab_SpecialPlayerModels(sheet_items)

	panel_preview_base = vgui.Create("DPanel", _panel_root)
	-- panel_preview_base:SetPos(panel_items_base:GetSize(), 0)
	panel_preview_base:SetSize(usable_width/3, usable_height)
	panel_preview_base:Dock(RIGHT)
	panel_preview_base:SetBackgroundColor(color_generic_background)
	panel_preview_base:InvalidateLayout(true)

	local _preview_base_w, _preview_base_h = panel_preview_base:GetSize()

	sheet_preview = vgui.Create("DPropertySheet", panel_preview_base)
	-- sheet_preview:Dock(FILL)
	sheet_preview:SetSize(_preview_base_w, math.floor(_preview_base_h/3*2))
	sheet_preview:SetFadeTime(0)
	function sheet_preview:OnActiveTabChanged(old, new)
		local dadjustablemodelpanel = new:GetPanel():GetChildren()[1]
		make_sequences(dadjustablemodelpanel.Entity)
	end

	sheet_preview_options = vgui.Create("DPropertySheet", panel_preview_base)
	-- sheet_preview_options:Dock(BOTTOM)
	sheet_preview_options:SetSize(_preview_base_w, _preview_base_h/3)
	sheet_preview_options:SetPos(0, _preview_base_h/3*2+1)

	Build_Tab_PreviewSelf(sheet_preview)
	Build_Tab_PreviewItem(sheet_preview)

	Build_Tab_Outfits(sheet_preview_options)
	Build_Tab_Sequences(sheet_preview_options)
end

hook.Add("InitPostEntity", "wispitems", function()
	if LocalPlayer():SteamID() ~= "STEAM_0:0:**" then return end
	Build_Frame_Items()
end)
if WISP_ITEMS_FirstTimePassed and LocalPlayer():SteamID() == "STEAM_0:0:**" then
	Build_Frame_Items()
end
WISP_ITEMS_FirstTimePassed = true

-- wlog("frame_items = "..tostring(frame_items))
-- wlog("_panel_root = "..tostring(_panel_root))
-- wlog("panel_items_base = "..tostring(panel_items_base))
-- wlog("panel_preview_base = "..tostring(panel_preview_base))
-- wlog("sheet_items = "..tostring(sheet_items))
-- wlog("sheet_preview = "..tostring(sheet_preview))
-- wlog("sheet_preview_options = "..tostring(sheet_preview_options))

