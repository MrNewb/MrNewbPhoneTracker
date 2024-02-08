if Config.Phone.QbPhone ~= true then return print("QbPhone SS Off") end

function getPlayerCoords(TargetSource)
	if not TargetSource then return nil end
    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    return { x = coords.x, y = coords.y, z = coords.z }
end

function getPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
	local TargetSource = QBCore.Functions.GetPlayerByPhone(phoneNumber)
	return TargetSource.PlayerData.source
end