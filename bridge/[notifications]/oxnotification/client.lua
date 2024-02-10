if Config.Notify ~= "OxNotify" then return print("OxNotify CS Off") end

function notifyPlayer(msg, status)
	return lib.notify({ title = 'Notification', description = msg, duration = 10000, type = status})
end