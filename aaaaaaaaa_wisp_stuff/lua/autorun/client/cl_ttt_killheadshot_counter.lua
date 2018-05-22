local ttt_killheadshot_counter = CreateClientConVar("ttt_killheadshot_counter", "1", true, true)
local text_color = Color(255, 255, 255)

hook.Add("HUDPaint", "cl_ttt_killheadshot_counter.lua", function()
	if --[[not ply:IsTerror() or]] not ttt_killheadshot_counter:GetBool() then return end
	local ply = LocalPlayer()
	local w = ScrW() * 0.032
	local h = ScrH()
	draw.SimpleText("Kills: "..ply:GetNWInt("kills"), "HudHintTextLarge", w, h*0.32, text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText("Headshots: "..ply:GetNWInt("headshots"), "HudHintTextLarge", w, h*0.32 + 15, text_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)

hook.Add("TTTSettingsTabs", "cl_ttt_killheadshot_counter.lua", function(dtabs)
	local dsettings = dtabs.Items[2].Panel

	local dgui = vgui.Create("DForm", dsettings)
	dgui:SetName("Enable Kills/Headshots text in the left")
	if dgui.TTTCustomUI_FormatForm then
		dgui:TTTCustomUI_FormatForm()
	end
	dgui:CheckBox("Enable Kills/Headshots text in the left", "ttt_killheadshot_counter")
	dsettings:AddItem(dgui)
	for k, v in pairs(dgui.Items) do
		for i, j in pairs(v:GetChildren()) do
			if j.Label.TTTCustomUI_FormatLabel then
				j.Label:TTTCustomUI_FormatLabel()
			end
		end
	end
	--dsettings:AddItem(dgui)
end)
