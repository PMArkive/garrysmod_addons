--local ttt_round_tabsound = CreateClientConVar("ttt_round_tabsound", "1", true, true)

hook.Add("TTTBeginRound", "wisp - cl_roundalert_flash.lua", function()
    if not system.HasFocus() then
        system.FlashWindow()
        --if GetConVar("ttt_round_endstart_sounds"):GetBool() then
        --    --surface.PlaySound("radio/letsgo.wav")
        --    sound.PlayFile("sound/radio/letsgo.wav", "", function(alert)
        --        if IsValid(alert) then
        --            alert:Play()
        --        end
        --    end)
        --end
    end
end)
