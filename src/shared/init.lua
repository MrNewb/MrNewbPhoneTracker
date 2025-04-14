Bridge = exports.community_bridge:Bridge()

function locales(message)
    return Bridge.Language.Locale(message)
end

function DebugInfo(message)
    if not Config.Utility.Debug then return end
    Bridge.Prints.Debug(message)
end

if IsDuplicityVersion() then
    function NotifyPlayer(src, message, _type, time)
        if not message or not _type then return end
        DebugInfo("NotifyPlayer"..src.." | "..message.." | ".._type.." | "..time)
        return Bridge.Notify.SendNotify(src, message, _type, time)
    end

    function RegisterUsableItems()
        Bridge.Framework.RegisterUsableItem(Config.TrackerItem, function(src, itemData)
            DebugInfo("RegisterUsableItems")
            local playerjobname, _, __, ___ = Bridge.Framework.GetPlayerJob(src)
            DebugInfo("Player Job Name: " .. playerjobname.." | Required Job: " .. Config.RequiredJob)
            if playerjobname ~= Config.RequiredJob then return NotifyPlayer(src, locale("Restricted.JobLocked"), "error", 5000) end
            TriggerClientEvent("MrNewbPhoneTracker:requestCoord", src)
        end)
    end

    function CreateLog(src, message)
        return Bridge.Logs.Send(src, message)
    end

    AddEventHandler('onResourceStart', function(resource)
        if resource ~= GetCurrentResourceName() then return end
        RegisterUsableItems()
        Bridge.Version.VersionChecker("MrNewbScripts/MrNewbPhoneTracker", false)
    end)
else
    function NotifyPlayer(message, _type, time)
        if not message or not _type then return end
        return Bridge.Notify.SendNotify(message, _type, time)
    end
end