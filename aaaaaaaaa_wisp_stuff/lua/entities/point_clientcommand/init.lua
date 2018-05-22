ENT.Type = "point"

function ENT:AcceptInput( name, pActivator, pCaller, data )
	if name == "Command" then
		return true
	end
end
