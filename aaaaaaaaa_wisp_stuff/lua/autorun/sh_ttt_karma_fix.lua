local karmacolors = {
   max  = Color(255, 255, 255, 255),
   high = Color(255, 240, 135, 255),
   med  = Color(245, 220, 60, 255),
   low  = Color(255, 180, 0, 255),
   min  = Color(255, 130, 0, 255),
}

hook.Add("PostGamemodeLoaded", "fix that karma thing - sh_ttt_karma_fix.lua", function()
   function util.KarmaToString(karma)
      -- we use a max of 1337 but want colors to think 1000 is the max
      local maxkarma = 1000 --GetGlobalInt("ttt_karma_max", 1000)

      if karma > maxkarma * 0.89 then
         return "karma_max", karmacolors.max
      elseif karma > maxkarma * 0.8 then
         return "karma_high", karmacolors.high
      elseif karma > maxkarma * 0.65 then
         return "karma_med", karmacolors.med
      elseif karma > maxkarma * 0.5 then
         return "karma_low", karmacolors.low
      else
         return "karma_min", karmacolors.min
      end
   end
end)
