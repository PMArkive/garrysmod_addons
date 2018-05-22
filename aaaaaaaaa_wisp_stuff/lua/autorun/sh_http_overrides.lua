-- simple thing used to check what uses http

-- don't need it enabled unless testing
if true then return end

_OLD_HTTP = _OLD_HTTP or HTTP
local bool = false
function HTTP(t)
	if bool then
		--ErrorNoHalt("[HTTP_CATCH] "..t.method.." to "..t.url)
		PrintTable(t, 1)
	end
	return _OLD_HTTP(t)
end

_OLD_POST = _OLD_POST or http.Post
function http.Post(url, params, suc, fail, headers)
	if bool then
		--ErrorNoHalt("[HTTP_CATCH] POST to "..url.."\n")
		PrintTable({url=url, method="POST", headers=headers, params=params}, 1)
	end
	return _OLD_POST(url, params, suc, fail, headers)
end

_OLD_FETCH = _OLD_FETCH or http.Fetch
function http.Fetch(url, suc, fail, headers)
	if bool then
		--ErrorNoHalt("[HTTP_CATCH] GET to "..url.."\n")
		PrintTable({url=url, method="POST", headers=headers}, 1)
	end
	return _OLD_FETCH(url, suc, fail, headers)
end
