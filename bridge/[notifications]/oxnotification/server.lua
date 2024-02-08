if Config.Notify.OxNotify ~= true then return print("OxNotify SS Off") end

function notifyPlayer(src, msg, status)
	TriggerClientEvent('ox_lib:notify', src, { title = "Name Change", description = msg, duration = 10000, type = status })
end