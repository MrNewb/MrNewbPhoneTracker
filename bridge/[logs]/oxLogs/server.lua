if Config.Logs.OxLogs ~= true then return print("oxLogs Off SS") end

function logs(src, msg)
	if not Config.Logs.EnableLogs then 
		return 
	end
	
    if Config.Logs.OxLogs then
        lib.logger(src, GetCurrentResourceName(), msg)
        return
    end

end
