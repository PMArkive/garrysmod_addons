
local function thing()
	Derma_DrawBackgroundBlurOrig = Derma_DrawBackgroundBlurOrig or Derma_DrawBackgroundBlur
	Derma_DrawBackgroundBlur = function(panel, starttime)
		if panel.ClassName == "DPointShopMenu" then
			return
		end
		Derma_DrawBackgroundBlurOrig(panel, starttime)
	end
end
if Derma_DrawBackgroundBlurOrig then
	thing()
end
hook.Add("PostGamemodeLoaded", "wisp - cl_disable_pointshop_blur.lua", thing)
