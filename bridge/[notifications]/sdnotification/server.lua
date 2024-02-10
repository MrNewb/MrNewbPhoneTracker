if Config.Notify ~= "SDNotify" then return print("SDNotify SS Off") end

function notifyPlayer(src, msg, status)
	return TriggerClientEvent('sd-notify:Notify', src, "Notification", msg, 3000, status, 'top-right', false, false)
end