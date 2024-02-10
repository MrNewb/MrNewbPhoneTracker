if Config.Notify ~= "QBNotify" then return print("QBNotify CS Off") end

function notifyPlayer(msg, status)
	return QBCore.Functions.Notify(msg, status, 10000)
end