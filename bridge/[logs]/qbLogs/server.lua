if Config.Logs ~= "QbLogs" then return print("QbLogs SS Off") end

function logs(src, msg)
	return TriggerEvent('qb-log:server:CreateLog', GetCurrentResourceName(), GetCurrentResourceName(), 'red', msg)
end