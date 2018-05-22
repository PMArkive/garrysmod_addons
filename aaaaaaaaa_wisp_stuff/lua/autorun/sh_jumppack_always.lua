local tickInterval = engine.TickInterval()
local ticksPerSecond = (1 / tickInterval)
local upMultiplier = (320 / ticksPerSecond)

--[[
local mapMultiplierFinished = false
local mapUpMultiplier = {
	["ttt_lockout_ve"] = (upMultiplier / 2),
	["ttt_green_hill_zone"] = (upMultiplier / 1.75),
}
]]

--[[
function ITEM:Move( pl, modifications, ply, data)
	if pl ~= ply then return end
	local bdata = data:GetButtons()
	if bit.band( bdata, IN_JUMP ) > 0 then
		if CLIENT then print("lmao", CurTime()) end
		data:SetVelocity( data:GetVelocity() + Vector(0,0,200)*FrameTime() )
	end
end
]]

local function blahblahthing()
	--[[
	if not mapMultiplierFinished then
		mapMultiplierFinished = true
		local new = mapUpMultiplier[game.GetMap()]
		if isnumber(new) then
			upMultiplier = new
		end
	end
	]]

	for _, plr in ipairs(player.GetHumans()) do
		if plr:KeyDown(IN_JUMP) then
			-- default up multiplier is 6 which is for 30-ticks
			plr:SetVelocity(plr:GetUp() * upMultiplier)
		end
	end
end

--hook.Remove("Tick", "Pointshop Jumpack Tick thing")
hook.Add("Tick", "wisp - sh_jumppack_always.lua", blahblahthing)
