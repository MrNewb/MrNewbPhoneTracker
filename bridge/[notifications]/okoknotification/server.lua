if Config.Notify ~= "OKNotify" then return print("OKNotify SS Off") end

function notifyPlayer(src, msg, status)
	return TriggerClientEvent('okokNotify:Alert', src, 'Notification', msg, 3000, status, false)
end