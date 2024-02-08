if Config.Notify.SDNotify ~= true then return print("SDNotify Off SS") end

function notifyPlayer(src, msg, status)
	TriggerClientEvent('sd-notify:Notify', src, "Notification", msg, 3000, status, 'top-right', false, false)
end