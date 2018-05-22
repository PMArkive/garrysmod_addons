--#NoSimplerr#

hook.Add("PlayerDeath", "AutoWant", function(victim, inflictor, attacker)
	-- print("PlayerDeath", victim, inflictor, attacker)
	if not (IsValid(attacker) and attacker:IsPlayer()) then
		-- maybe grab the attacker from the inflictor somehow?
		return
	end

	if victim == attacker then return end

	if !attacker.isCP or attacker:isCP() then
		-- ignore for now because sounds troublesome (dealing with civil protection that is...)
		return
	end

	local now = CurTime()

	local lastMurder = attacker.AutoWant_LastMurder
	if lastMurder and (now - lastMurder <= AutoWantConfig.MultiMurder_Time) and not attacker:isWanted() then
		if math.random(1, 100) <= AutoWantConfig.MultiMurder_Chance then
			attacker:wanted(NULL, AutoWantConfig.MultiMurder_Reason, AutoWantConfig.MultiMurder_WantedTime)
		end
	end

	attacker.AutoWant_LastMurder = now
end)

local function LockpickHook(ply, success, ent, isMaster)
	-- print("LockpickHook", success, ent)
	if ply:isWanted() or not success then
		-- /shrug
		return
	end

	local chance = math.random(1, 100)
	-- print(chance)
	if chance <= AutoWantConfig.Lockpick_Chance then
		-- print("wanting player")
		local wantedTime = isMaster and
			AutoWantConfig.MasterLockpick_WantedTime
			or
			AutoWantConfig.Lockpick_WantedTime
		ply:wanted(NULL, AutoWantConfig.Lockpick_Reason, wantedTime)
	end
end

-- handles the default lockpick
hook.Add("onLockpickCompleted", "AutoWant", LockpickHook)

local function master_lockpick_Succeed(self)
	-- print("Master lockpick Succeed - ", self)
	LockpickHook(self.Owner, true, nil, true)
	return self.orig_Succeed(self)
end

local function keypad_cracker_Succeed(self)
	-- print("Keypad cracker Succeed - ", self)

	local chance
	local wantedTime

	if self:GetClass() == "keypad_cracker" then
		chance = AutoWantConfig.KeypadCracker_Chance
		wantedTime = AutoWantConfig.KeypadCracker_WantedTime
	else
		chance = AutoWantConfig.ProKeypadCracker_Chance
		wantedTime = AutoWantConfig.ProKeypadCracker_WantedTime
	end

	if not self.Owner:isWanted() and math.random(1, 100) <= chance then
		self.Owner:wanted(NULL, AutoWantConfig.KeypadCracker_Reason, nil)
	end

	return self.orig_Succeed(self)
end

hook.Add("OnEntityCreated", "AutoWant - Overrides", function(ent)
	local class = ent:GetClass()

	if class == "master_lockpick" then
		timer.Simple(0, function()
			if not ent:IsValid() then return end
			ent.orig_Succeed = ent.Succeed
			ent.Succeed = master_lockpick_Succeed
		end)
	elseif class == "keypad_cracker" or class == "prokeypadcracker" then
		timer.Simple(0, function()
			if not ent:IsValid() then return end
			ent.orig_Succeed = ent.Succeed
			ent.Succeed = keypad_cracker_Succeed
		end)
	end
end)
