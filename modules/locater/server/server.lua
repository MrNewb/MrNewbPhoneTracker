Bridge.Callback.Register('MrNewbPhoneTracker_v2:Callback:GetCoord', function(src, phoneNumber)
    local playerjobname, _, __, ___ = Bridge.Framework.GetPlayerJob(src)
    if playerjobname ~= Config.RequiredJob then return false end
    local TargetSource = GetPlayerSource(phoneNumber)
    if not TargetSource then return false, Bridge.Notify.SendNotify(src, locales("Restricted.Unabletolocate"), "error", 5000) end
    local TargetPed = GetPlayerPed(TargetSource)
    if not TargetPed then return false, Bridge.Notify.SendNotify(src, locales("Restricted.Unabletolocate"), "error", 5000) end
    local GetPlayerCoords = GetEntityCoords(TargetPed)
    if not TargetSource or not GetPlayerCoords then return false, Bridge.Notify.SendNotify(src, locales("Restricted.Unabletolocate"), "error", 5000) end
    CreateLog(src, "Player ID " .. src .. " has pinged a phone " .. phoneNumber)
    return GetPlayerCoords
end)