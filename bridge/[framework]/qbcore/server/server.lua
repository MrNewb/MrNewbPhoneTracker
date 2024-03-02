if Config.Framework ~= "qb" then return end
if Config.Debug then print("Framework Set To ", Config.Framework) end

local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerByID(identifier)
    local Player = QBCore.Functions.GetPlayerByCitizenId(identifier)
    local passedsrc = Player.PlayerData.source
    return passedsrc
end

function GetPlayerByPhoneNumber(phoneNumber)
    local Player = QBCore.Functions.GetPlayerByPhone(phoneNumber)
	if not Player then return nil end
    return Player.PlayerData.source
end

function GetPlayerFW(src)
    return QBCore.Functions.GetPlayer(src)
end

function GetPlayerJobFW(src)
    local Player = GetPlayerFW(src)
    return Player.PlayerData.job.name
end

QBCore.Functions.CreateUseableItem(Config.TrackerItem, function(source, item)
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
end, false)
--]]