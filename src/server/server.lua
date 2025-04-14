lib.callback.register('MrNewbPhoneTracker_v2:Callback:GetCoord', function(source, phoneNumber)
    local src = source
    local playerjobname, _, __, ___ = Bridge.Framework.GetPlayerJob(src)
    if playerjobname ~= Config.RequiredJob then return false end
    local TargetSource = GetPlayerSource(phoneNumber)
    if not TargetSource then return false, NotifyPlayer(src, locales("Restricted.Unabletolocate"), "error", 5000) end
    local TargetPed = GetPlayerPed(TargetSource)
    if not TargetPed then return false, NotifyPlayer(src, locales("Restricted.Unabletolocate"), "error", 5000) end
    local GetPlayerCoords = GetEntityCoords(TargetPed)
    if not TargetSource or not GetPlayerCoords then return false, NotifyPlayer(src, locales("Restricted.Unabletolocate"), "error", 5000) end
    CreateLog(src, "Player ID " .. src .. " has pinged a phone " .. phoneNumber)
    return GetPlayerCoords
end)