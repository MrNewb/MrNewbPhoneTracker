local activePhone = nil

local phoneTypes = {
    ["gksphone"] = function(phoneNumber)
        if not phoneNumber then return false end
        return exports["gksphone"]:GetSourceByPhone(phoneNumber)
    end,
    ["lb-phone"] = function(phoneNumber)
        if not phoneNumber then return false end
        local playerID = exports["lb-phone"]:GetSourceFromNumber(phoneNumber)
        return playerID
    end,
    ["NPWD"] = function(phoneNumber)
        if not phoneNumber then return false end
        local players = Bridge.Framework.GetPlayers()
        for _, playerID in pairs(players) do
            local phoneData = exports.npwd.getPlayerData({ source = playerID })
            local meh = phoneData.phoneNumber
            if meh == phoneNumber then
                return playerID
            end
        end
        return false
    end,
    ["okokPhone"] = function(phoneNumber)
        if not phoneNumber then return false end
        local TargetSource = exports['okokPhone']:getSourceFromPhoneNumber(phoneNumber)
        if not TargetSource then return false end
        return TargetSource
    end,
    ["qs-smartphone"] = function(phoneNumber)
        if not phoneNumber then return false end
        local players = Bridge.Framework.GetPlayers()
        for _, v in pairs(players) do
            local playerPhoneNumber = exports['qs-base']:GetPlayerPhone(v)
            if playerPhoneNumber == phoneNumber then
                return v
            end
        end
        return false
    end,
    ["qb-phone"] = function(phoneNumber)
        if not phoneNumber then return false end
        local qb = exports['qb-core']:GetCoreObject()
        return qb.Functions.GetPlayerByPhone(phoneNumber)
    end,
    ["qs-smartphone-pro"] = function(phoneNumber)
        if not phoneNumber then return false end
        local players = Bridge.Framework.GetPlayers()
        for _, v in pairs(players) do
            local identifier = Bridge.Framework.GetPlayerIdentifier(v)
            local search = exports['qs-smartphone-pro']:GetPhoneNumberFromIdentifier(identifier, false)
            if search == phoneNumber then
                return v
            end
        end
        return false
    end,
    ["roadphone"] = function(phoneNumber)
        if not phoneNumber then return false end
        local Target = exports['roadphone']:getPlayerFromPhone(phoneNumber)
        if not Target then return false end
        return Target.source
    end,
    ["yseries"] = function(phoneNumber)
        if not phoneNumber then return false end
        local response = exports.yseries:GetPlayerSourceIdByPhoneNumber(phoneNumber)
        return response
    end,
}

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for phoneType, _func in pairs(phoneTypes) do
        if GetResourceState(phoneType) == 'started' then
            activePhone = phoneType
            break
        end
    end
end)

function GetPlayerSource(phoneNumber)
    if not phoneNumber then return false end
    if not activePhone then return false end
    return phoneTypes[activePhone](tostring(phoneNumber))
end