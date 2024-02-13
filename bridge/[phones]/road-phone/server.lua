if Config.Phone ~= "RoadPhone" then return print("RoadPhone SS Off") end

function getPlayerCoords(TargetSource)
    if not TargetSource then return nil end

    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    return coords
end

function getPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local Target = exports['roadphone']:getPlayerFromPhone(phoneNumber)
    if not Target then return nil end
    return Target.source
end