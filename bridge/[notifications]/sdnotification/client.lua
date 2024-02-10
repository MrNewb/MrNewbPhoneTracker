if Config.Notify ~= "SDNotify" then return print("SDNotify CS Off") end

function notifyPlayer(msg, status)
	return exports['sd-notify']:Notify("Notification", msg, 3000, status, 'top-right', false, false)
end