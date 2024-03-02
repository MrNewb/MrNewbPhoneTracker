if Config.Framework ~= "esx" then return end
if Config.Debug then print("Framework Set To ", Config.Framework) end

local ESX = exports["es_extended"]:getSharedObject()

local function findPlayerIdentifier(phoneNumber)
    local query = MySQL.scalar.await("SELECT identifier FROM users WHERE phone_number = @phoneNumber", {["@phoneNumber"] = phoneNumber})
    return query
end

function GetPlayerByPhoneNumber(phoneNumber)
    local identifier = findPlayerIdentifier(phoneNumber)
    if not identifier then return nil end
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    return xPlayer.source
end

function GetPlayerByID(identifier)
    local Player = ESX.GetPlayerFromIdentifier(identifier)
    return Player.source
end

function GetPlayerFW(src)
    return ESX.GetPlayerFromId(src)
end

function GetPlayerJobFW(src)
    local xPlayer = GetPlayerFW(src)
    return xPlayer.job.name
end

ESX.RegisterUsableItem(Config.TrackerItem, function(source)
    local src = source
    local JobName = GetPlayerJobFW(src)
    if not JobName == Config.RequiredJob then return NotifyPlayer(src, "You dont know how to use this.", "error") end
	TriggerClientEvent("MrNewbPhoneTracker:requestCoord", src)
end)
--[[
-- debugging command if needed
RegisterCommand("ping", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent("MrNewbPhoneTracker:requestCoord", src)
end, false)--]]