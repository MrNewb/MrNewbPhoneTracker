if Config.Phone ~= "OldQsPhone" then return end
if Config.Debug then print("Phone Set To ", Config.Phone) end

function GetPlayerCoords(TargetSource)
	if not TargetSource then return nil end
    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    if Config.Debug then print("TargetSource",TargetSource) end
    return coords
end

function GetPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
	local TargetSource = GetPlayerByPhoneNumber(phoneNumber)
    if Config.Debug then print("TargetSource",TargetSource) end
	if not TargetSource then return nil end
	return TargetSource
end