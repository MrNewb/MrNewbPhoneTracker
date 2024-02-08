if Config.Notify.OKNotify ~= true then return print("OKNotify Off SS") end

function notifyPlayer(src, msg, status)
	TriggerClientEvent('okokNotify:Alert', src, 'Notification', msg, 3000, status, false)
end