if Config.Logs.QbLogs ~= true then return print("QbLogs Off SS") end

function logs(src, msg)
	if not Config.Logs.EnableLogs then 
		return
	end

    if Config.Logs.QbLogs then
        TriggerEvent('qb-log:server:CreateLog', GetCurrentResourceName(), GetCurrentResourceName(), 'red', msg)
		return
    end

end
