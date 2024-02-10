if not Config.Notify == "QBNotify" then return print("QBNotify SS Off") end

function notifyPlayer(src, msg, status)
	return TriggerClientEvent('QBCore:Notify', src, msg, status)
end