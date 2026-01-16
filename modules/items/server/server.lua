Bridge.Framework.RegisterUsableItem(Config.TrackerItem, function(src, itemData)
    DebugInfo("RegisterUsableItems")
    local playerjobname, _, __, ___ = Bridge.Framework.GetPlayerJob(src)
    DebugInfo("Player Job Name: " .. playerjobname.." | Required Job: " .. Config.RequiredJob)
    if playerjobname ~= Config.RequiredJob then return Bridge.Notify.SendNotify(src, locales("Restricted.JobLocked"), "error", 5000) end
    TriggerClientEvent("MrNewbPhoneTracker:requestCoord", src)
end)