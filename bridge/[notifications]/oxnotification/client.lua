if Config.Notify ~= "ox" then return end
if Config.Debug then print("OxNotification CS On") end

function NotifyPlayer(msg, status)
	return lib.notify({ title = 'Notification', description = msg, duration = 10000, type = status})
end