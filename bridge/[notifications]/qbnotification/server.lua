if Config.Notify.QBNotify ~= true then return print("QBNotify Off SS") end

function notifyPlayer(src, msg, status)
	TriggerClientEvent('QBCore:Notify', src, msg, status)
end