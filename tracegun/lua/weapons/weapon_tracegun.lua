
AddCSLuaFile()

SWEP.PrintName = "Trace Gun"
SWEP.Author = "**"
SWEP.Purpose = "Trace your shot for some reason"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel		= Model("models/weapons/c_toolgun.mdl")
SWEP.WorldModel		= Model("models/weapons/w_toolgun.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
-- SWEP.AdminOnly = true
SWEP.ShootSound = Sound( "Airboat.FireGunRevDown" )

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 0.1 )

	self:EmitSound( self.ShootSound )
	-- self:ShootEffects( self )

	-- if ( !SERVER ) then return end
	-- self:ShootBullet( 1, 1, 0 )

	self:ShootEffects()

	if SERVER then return end
	if self.Owner ~= LocalPlayer() then return end
	if not IsFirstTimePredicted() then return end

	local start = self.Owner:GetShootPos()
	local dir = self.Owner:GetAimVector()

	local tr = util.TraceLine({
		start = start,
		endpos = start + dir * 100000,
		filter = player.GetAll(),
	})

	print("\n\n")
	PrintTable(tr)

	self:DoImpactEffect(tr)
end

-- local starting = false
-- concommand.Add("memes", function(ply, cmd, args, argStr)
	-- hook.Remove("Tick", "memes")
	-- local asdf = table.Copy(lines)
	-- local units_per_sec = 600
	-- local units_per_tick = units_per_sec * engine.TickInterval()

	-- local current
-- end)

-- hook.Add("Tick", "memes", function()
	
-- end)

lines = lines or {
	
}
hook.Add("PreDrawEffects", "thing", function()
	local linecolor = Color(255,255,0)
	for k,v in ipairs(lines) do
		-- print(v[1],v[2])
		render.DrawLine(v[1], v[2], linecolor, false)
	end
end)
TR = TR
function SWEP:DoImpactEffect( tr, nDamageType )
	-- if ( tr.HitSky ) then return true end

	TR = tr
	table.Empty(lines)
	table.insert(lines, {tr.StartPos, tr.HitPos})

	local players = player.GetAll()

	for i=1,300 do
		local ang = tr.Normal:Angle()
		ang:RotateAroundAxis(tr.HitNormal, 180)
		local dir = ang:Forward()*-1

		tr = util.TraceLine({start=tr.HitPos, endpos=tr.HitPos+(dir*100000), filter=players})
		table.insert(lines, {tr.StartPos, tr.HitPos})
	end

	-- timer.Create("delet_lines", 5, 1, function() table.Empty(lines) end)

	return true
end

function SWEP:SecondaryAttack()
	table.Empty(lines)
end

function SWEP:ShouldDropOnDie()
	return false
end
