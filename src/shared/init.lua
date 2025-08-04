Bridge = exports.community_bridge:Bridge()

function locales(message)
    return Bridge.Language.Locale(message)
end

function DebugInfo(message)
    if not Config.Utility.Debug then return end
    Bridge.Prints.Debug(message)
end

if IsDuplicityVersion() then
    NotifyPlayer = Bridge.Notify.SendNotify

    function RegisterUsableItems()
        Bridge.Framework.RegisterUsableItem(Config.TrackerItem, function(src, itemData)
            DebugInfo("RegisterUsableItems")
            local playerjobname, _, __, ___ = Bridge.Framework.GetPlayerJob(src)
            DebugInfo("Player Job Name: " .. playerjobname.." | Required Job: " .. Config.RequiredJob)
            if playerjobname ~= Config.RequiredJob then return NotifyPlayer(src, locales("Restricted.JobLocked"), "error", 5000) end
            TriggerClientEvent("MrNewbPhoneTracker:requestCoord", src)
        end)
    end

    function CreateLog(src, message)
        return Bridge.Logs.Send(src, message)
    end

    AddEventHandler('onResourceStart', function(resource)
        if resource ~= GetCurrentResourceName() then return end
        RegisterUsableItems()
        Bridge.Version.VersionChecker("MrNewb/patchnotes", false, true, "MrNewbPhoneTracker", "MrNewb/MrNewbPhoneTracker")
    end)
else
    NotifyPlayer = Bridge.Notify.SendNotify
end
