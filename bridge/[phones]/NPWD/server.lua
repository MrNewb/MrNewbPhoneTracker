if Config.Phone ~= "NPWD" then return end
if Config.Debug then print("Phone Set To ", Config.Phone) end

function GetPlayerCoords(TargetSource)
	if not TargetSource then return nil end
    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    return coords
end

function GetPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
	local TargetSource = GetPlayerByPhoneNumber(phoneNumber)
	if not TargetSource then return nil end
	return TargetSource
end