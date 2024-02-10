if Config.Logs ~= "OxLogs" then return print("OxLogs SS Off") end

function logs(src, msg)
	return lib.logger(src, GetCurrentResourceName(), msg)
end
