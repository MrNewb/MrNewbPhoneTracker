if Config.Notify ~= "OKNotify" then return print("OKNotify CS Off") end

function notifyPlayer(msg, status)
	return exports['okokNotify']:Alert('Notification', msg, 10000, status, false)
end