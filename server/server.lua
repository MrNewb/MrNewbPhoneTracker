RegisterNetEvent("MrNewbPhoneTracker:getCoord")
AddEventHandler("MrNewbPhoneTracker:getCoord", function(phoneNumber)
    local src = source
	local JobName = GetPlayerJobFW(src)
    local TargetSource = GetPlayerSource(phoneNumber)
    local GetPlayerCoords = GetPlayerCoords(TargetSource)
    if not JobName == Config.RequiredJob then return end
    if not TargetSource then return NotifyPlayer(src, "Unable to locate phone or it may be offline", "error") end
    if not GetPlayerCoords then return NotifyPlayer(src, "Unable to locate phone or it may be offline", "error") end

    TriggerClientEvent("MrNewbPhoneTracker:trackedvictim", TargetSource)
    TriggerClientEvent("MrNewbPhoneTracker:provideCoord", src, GetPlayerCoords)
    NotifyPlayer(src, "Phone has been pinged for 30 seconds", "success")
	if Config.Logs then Logs(src, " | Has pinged a phone ") end
end)