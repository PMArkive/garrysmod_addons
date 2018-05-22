local function asdf()
   -- print('asdfasdf')
   CL_TTT_CROSSHAIR_CHANGES = true
   -- local sights_opacity = CreateConVar("ttt_ironsights_crosshair_opacity", "0.8", FCVAR_ARCHIVE)
   -- local crosshair_brightness = CreateConVar("ttt_crosshair_brightness", "1.0", FCVAR_ARCHIVE)
   -- local crosshair_size = CreateConVar("ttt_crosshair_size", "1.0", FCVAR_ARCHIVE)
   local disable_crosshair = CreateConVar("ttt_disable_crosshair", "0", FCVAR_ARCHIVE)
   -- local black_in_white

   local weapon_tttbase = util.WeaponForClass("weapon_tttbase")
   function weapon_tttbase:DrawHUD()
      if self.HUDHelp then
         self:DrawHelp()
      end

      local client = LocalPlayer()
      if disable_crosshair:GetBool() or (not IsValid(client)) then return end

      -- local sights = (not self.NoSights) and self:GetIronsights()

      local x = math.floor(ScrW() / 2.0)
      local y = math.floor(ScrH() / 2.0)
      -- local scale = math.max(0.2,  10 * self:GetPrimaryCone())

      -- local LastShootTime = self:LastShootTime()
      -- scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

      -- local alpha = sights and sights_opacity:GetFloat() or 1
      -- local bright = crosshair_brightness:GetFloat() or 1

      -- somehow it seems this can be called before my player metatable
      -- additions have loaded
      -- if client.IsTraitor and client:IsTraitor() then
         -- surface.SetDrawColor(255 * 1,
                              -- 50 * 1,
                              -- 50 * 1,
                              -- 255 * 1)
      -- else
         surface.SetDrawColor(0,
                              255 * 1,
                              0,
                              255 * 1)
      -- end

      local crosshair_size = 2
      local scale = 0.2
      local gap = math.floor(20 * scale)
      local length = math.floor(gap + (25 * crosshair_size) * scale)
      -- local gap = math.floor(20 * scale * (sights and 0.8 or 1))
      -- local length = math.floor(gap + (25 * crosshair_size:GetFloat()) * scale)

      -- local w,h = ScrW()/2, ScrH()/2
      -- local half_gap = 10
      -- local thing_len = 16

      -- local horx,hory = 

      -- surface.SetDrawColor(0,0,0,255)

      -- surface.DrawRect(w-2, h-2, 4, 4)

      -- surface.DrawRect(w-thing_len-half_gap-2, h-2, thing_len+4, 4)
      -- surface.DrawRect(w+half_gap-1, h-2, thing_len+4, 4)
      -- surface.DrawRect(w-2, h-thing_len-half_gap-2, 4, thing_len+4)
      -- surface.DrawRect(w-2, h+half_gap-1, 4, thing_len+4)

      -- surface.DrawLine( x - length-1, y-1, x - gap+2, y+1 )
      -- surface.DrawLine( x + length+1, y-1, x + gap-1, y+1 )
      -- surface.DrawLine( x-1, y - length-1, x+1, y - gap+1 )
      -- surface.DrawLine( x-1, y + length+1, x+1, y + gap-1 )
      -- surface.DrawRect( x - length - 1, y-1, 

      -- surface.SetDrawColor(255,255,255,255)

      -- surface.DrawRect(w-1, h-1, 2, 2)

      -- surface.DrawRect(w-thing_len-half_gap-2, h-1, thing_len, 2)
      -- surface.DrawRect(w+half_gap-1, h-1``, thing_len, 2)
      -- surface.DrawRect(w-1, h-thing_len-half_gap-2, 2, thing_len)
      -- surface.DrawRect(w-1, h+half_gap-1, 2, thing_len)

      -- surface.DrawRect(x-12, y-1, length, 2)
      -- surface.DrawRect(x+12, y-1, length, 2)
      -- surface.DrawRect(x-1, y-12, 2, length)
      -- surface.DrawRect(x-1, y+12, 2, length)
      surface.DrawLine( x - length, y, x - gap, y )
      surface.DrawLine( x + length, y, x + gap+1, y )
      surface.DrawLine( x, y - length, x, y - gap )
      surface.DrawLine( x, y + length, x, y + gap+1 )
   end
end

if CL_TTT_CROSSHAIR_CHANGES then
   asdf()
end

hook.Add("PostGamemodeLoaded", "sh_ttt_weapons_overrides.lua", asdf)
