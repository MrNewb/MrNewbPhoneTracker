if GetResourceState('qs-smartphone-pro') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
    local players = Bridge.Framework.GetPlayers()
    for _, v in pairs(players) do
        local identifier = Bridge.Framework.GetPlayerIdentifier(v)
        local search = exports['qs-smartphone-pro']:GetPhoneNumberFromIdentifier(identifier, false)
        if search == phoneNumber then
            return v
        end
    end
    return nil
end