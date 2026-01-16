Bridge = exports.community_bridge:Bridge()

function locales(message)
    return Bridge.Language.Locale(message)
end

function DebugInfo(message)
    if not Config.Utility.Debug then return end
    Bridge.Prints.Debug(message)
end

if not IsDuplicityVersion() then return end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", resource)
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", "community_bridge")
end)