if Config.Notify ~= "OxNotify" then return print("OxNotify SS Off") end

function notifyPlayer(src, msg, status)
	return TriggerClientEvent('ox_lib:notify', src, { title = "Notification", description = msg, duration = 10000, type = status })
end