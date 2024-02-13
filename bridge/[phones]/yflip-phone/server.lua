if Config.Phone ~= "yflip" then return print("yflip SS Off") end

function getPlayerCoords(TargetSource)
	if not TargetSource then return nil end
    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    return coords
end

function getPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
	local TargetSource = exports["yflip-phone"]:GetPhoneNumberByIdentifier('identifier')
	if not TargetSource then return nil end
	return TargetSource
end
