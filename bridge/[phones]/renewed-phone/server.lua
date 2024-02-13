if Config.Phone ~= "RenewedPhone" then return print("RenewedPhone SS Off") end

function getPlayerCoords(TargetSource)
	if not TargetSource then return nil end
    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    return coords
end

function getPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
	local TargetSource = QBCore.Functions.GetPlayerByPhone(phoneNumber)
	if not TargetSource then return nil end
	return TargetSource.PlayerData.source
end