
-- SID64 is used over the "regular" SID because every bot has "BOT" as SID.
-- The SID64 of bots are unique though.

hook.Add("InitPostEntity", "sh_pdata_sid64", function()
	local meta = FindMetaTable( "Player" )

	meta.old_GetPData = meta.old_GetPData or meta.GetPData
	meta.old_SetPData = meta.old_SetPData or meta.SetPData
	meta.old_RemovePData = meta.old_RemovePData or meta.RemovePData

	if ( !sql.TableExists( "playerpdatasid64" ) ) then

		sql.Query( "CREATE TABLE IF NOT EXISTS playerpdatasid64 ( infoid TEXT NOT NULL PRIMARY KEY, value TEXT );" )

	end

	--[[---------------------------------------------------------
		GetPData
		Saves persist data for this player
	-----------------------------------------------------------]]
	function meta:GetPData( name, default )

		name = Format( "%s[%s]", self:SteamID64(), name )
		local val = sql.QueryValue( "SELECT value FROM playerpdatasid64 WHERE infoid = " .. SQLStr( name ) .. " LIMIT 1" )
		if ( val == nil ) then return default end

		return val

	end

	--[[---------------------------------------------------------
		SetPData
		Set persistant data
	-----------------------------------------------------------]]
	function meta:SetPData( name, value )

		name = Format( "%s[%s]", self:SteamID64(), name )
		sql.Query( "REPLACE INTO playerpdatasid64 ( infoid, value ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( value ) .. " )" )

	end

	--[[---------------------------------------------------------
		RemovePData
		Remove persistant data
	-----------------------------------------------------------]]
	function meta:RemovePData( name )

		name = Format( "%s[%s]", self:SteamID64(), name )
		sql.Query( "DELETE FROM playerpdatasid64 WHERE infoid = " .. SQLStr( name ) )

	end

	util.old_GetPData = util.old_GetPData or util.GetPData
	util.old_SetPData = util.old_SetPData or util.SetPData
	util.old_RemovePData = util.old_RemovePData or util.RemovePData

	--[[---------------------------------------------------------
	   Name: GetPData( steamid, name, default )
	   Desc: Gets the persistant data from a player by steamid
	-----------------------------------------------------------]]
	function util.GetPData( steamid, name, default )

		name = Format( "%s[%s]", util.SteamIDTo64( steamid ), name )
		local val = sql.QueryValue( "SELECT value FROM playerpdatasid64 WHERE infoid = " .. SQLStr(name) .. " LIMIT 1" )
		if ( val == nil ) then return default end
		
		return val
		
	end

	--[[---------------------------------------------------------
	   Name: SetPData( steamid, name, value )
	   Desc: Sets the persistant data of a player by steamid
	-----------------------------------------------------------]]
	function util.SetPData( steamid, name, value )

		name = Format( "%s[%s]", util.SteamIDTo64( steamid ), name )
		sql.Query( "REPLACE INTO playerpdatasid64 ( infoid, value ) VALUES ( "..SQLStr(name)..", "..SQLStr(value).." )" )
		
	end

	--[[---------------------------------------------------------
	   Name: RemovePData( steamid, name )
	   Desc: Removes the persistant data from a player by steamid
	-----------------------------------------------------------]]
	function util.RemovePData( steamid, name )

		name = Format( "%s[%s]", util.SteamIDTo64( steamid ), name )
		sql.Query( "DELETE FROM playerpdatasid64 WHERE infoid = "..SQLStr(name) )
		
	end
end)
