-- only used for testing
if true then return end

hook.Add("PostGamemodeLoaded", "ausdofikjasdklfjkl", function()
	print("[asdfasdfasdf] goign to dump strings in 30 seconds")
	timer.Simple(30, function()
		print("[asdfasdfasdf] aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaFUCK")
		local t = ""
		for k,v in pairs(net.Receivers) do
			t = t .. "\n" .. k
		end
		print(#t)
		if SERVER then
			file.Write("netstrings_sv.txt", t)
		else
			file.Write("netstrings_cl.txt", t)
		end
	end)
end)