QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("MrNewbPhoneTracker:getCoord")
AddEventHandler("MrNewbPhoneTracker:getCoord", function(phoneNumber)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local JobName = Player.PlayerData.job.name
    local TargetSource = getPlayerSource(phoneNumber)
    local GetPlayerCoords = getPlayerCoords(TargetSource)
    if not Player then return end
    if not JobName == Config.RequiredJob then return end
    if not TargetSource then return notifyPlayer(src, "Unable to locate phone or it may be offline", "error") end
    if not GetPlayerCoords then return notifyPlayer(src, "Unable to locate phone or it may be offline", "error") end

    TriggerClientEvent('MrNewbPhoneTracker:trackedvictim', TargetSource)
    TriggerClientEvent('MrNewbPhoneTracker:provideCoord', src, GetPlayerCoords)
    notifyPlayer(src, "Phone has been pinged for 30 seconds", "success")
	if logs then
		logs(src, " | Has pinged a phone ")
	end
end)

QBCore.Functions.CreateUseableItem(Config.TrackerItem, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local JobName = Player.PlayerData.job.name
    if not Player then return end
    if not JobName == Config.RequiredJob then return notifyPlayer(src, "You dont know how to use this.", "error") end
    TriggerClientEvent("MrNewbPhoneTracker:requestCoord", src)
end)