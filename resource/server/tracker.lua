local startedPhoneResource
local lastPingTime = {}

local findSourceByPhoneResource = {
    ['gksphone'] = function(phoneNumber)
        for _, playerId in pairs(bridge.framework.getPlayers()) do
            if tostring(exports['gksphone']:GetPhoneBySource(playerId) or '') == phoneNumber then return playerId end
        end
        return false
    end,
    ['lb-phone'] = function(phoneNumber)
        return exports['lb-phone']:GetSourceFromNumber(phoneNumber)
    end,
    ['NPWD'] = function(phoneNumber)
        for _, playerId in pairs(bridge.framework.getPlayers()) do
            local phoneData = exports.npwd.getPlayerData({ source = playerId })
            if phoneData and tostring(phoneData.phoneNumber or '') == phoneNumber then return playerId end
        end
        return false
    end,
    ['okokPhone'] = function(phoneNumber)
        for _, playerId in pairs(bridge.framework.getPlayers()) do
            if tostring(exports.okokPhone:getPhoneNumberFromSource(playerId) or '') == phoneNumber then return playerId end
        end
        return false
    end,
    ['qs-smartphone'] = function(phoneNumber)
        for _, playerId in pairs(bridge.framework.getPlayers()) do
            if tostring(exports['qs-base']:GetPlayerPhone(playerId) or '') == phoneNumber then return playerId end
        end
        return false
    end,
    ['qb-phone'] = OpenFindSourceByCharPhone,
    ['qs-smartphone-pro'] = function(phoneNumber)
        for _, playerId in pairs(bridge.framework.getPlayers()) do
            local identifier = bridge.framework.getIdentifier(playerId)
            if tostring(exports['qs-smartphone-pro']:GetPhoneNumberFromIdentifier(identifier, false) or '') == phoneNumber then return playerId end
        end
        return false
    end,
    ['roadphone'] = function(phoneNumber)
        local target = exports['roadphone']:getPlayerFromPhone(phoneNumber)
        return target and target.source or false
    end,
    ['yseries'] = function(phoneNumber)
        for _, playerId in pairs(bridge.framework.getPlayers()) do
            if tostring(exports.yseries:GetPhoneNumberBySourceId(playerId) or '') == phoneNumber then return playerId end
        end
        return false
    end,
}

local function findPlayerByPhoneNumber(phoneNumber)
    if type(phoneNumber) ~= 'string' or phoneNumber == '' or not startedPhoneResource then return false end
    local findSource = findSourceByPhoneResource[startedPhoneResource]
    if type(findSource) ~= 'function' then return false end

    local targetSource = tonumber(findSource(phoneNumber))
    if not targetSource or targetSource < 1 then return false end

    local targetPed = GetPlayerPed(targetSource)
    if targetPed == 0 or not DoesEntityExist(targetPed) then return false end
    return targetSource
end

local function hasRequiredJob(src)
    local requiredJob = Config.RequiredJob
    if type(requiredJob) == 'string' then return bridge.framework.hasJob(src, requiredJob) == true end
    if type(requiredJob) ~= 'table' then return false end

    if requiredJob[1] then
        for index = 1, #requiredJob do
            local jobName = requiredJob[index]
            if type(jobName) == 'string' and bridge.framework.hasJob(src, jobName) then return true end
        end
        return false
    end

    for jobName, minimumGrade in pairs(requiredJob) do
        if type(jobName) == 'string' and bridge.framework.hasJob(src, jobName, tonumber(minimumGrade) or 0) then
            return true
        end
    end
    return false
end

local function getPingCooldownSeconds()
    local seconds = tonumber(Config.PingCooldown) or 10
    if seconds < 0 then return 0 end
    return math.floor(seconds)
end

local function sanitizePhoneNumber(phoneNumber)
    if type(phoneNumber) ~= 'string' then return false end
    phoneNumber = phoneNumber:gsub('%s+', '')
    if phoneNumber == '' or #phoneNumber > 10 or phoneNumber:find('[^%d]') then return false end
    return phoneNumber
end

lib.callback.register('MrNewbPhoneTracker:Callback:PingNumber', function(src, phoneNumber)
    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then
        return { ok = false, reason = 'miss' }
    end
    if not hasRequiredJob(src) then
        return { ok = false, reason = 'miss' }
    end
    if type(Config.TrackerItem) ~= 'string' or Config.TrackerItem == '' then
        return { ok = false, reason = 'miss' }
    end
    if not bridge.inventory.hasItem(src, Config.TrackerItem, 1) then
        bridge.notifications.notify(src, { description = locale('Restricted.NoItem'), type = 'error' })
        return { ok = false, reason = 'noitem' }
    end

    local sanitizedNumber = sanitizePhoneNumber(phoneNumber)
    if not sanitizedNumber then
        return { ok = false, reason = 'empty' }
    end

    local cooldownSeconds = getPingCooldownSeconds()
    local lastPing = lastPingTime[src]
    local remaining = 0
    if cooldownSeconds > 0 and lastPing then
        remaining = cooldownSeconds - (os.time() - lastPing)
        if remaining < 0 then remaining = 0 end
    end
    if remaining > 0 then
        bridge.notifications.notify(src, { description = locale('Restricted.Cooldown'), type = 'error' })
        return { ok = false, reason = 'cooldown', wait = remaining }
    end

    lastPingTime[src] = os.time()

    local targetSource = findPlayerByPhoneNumber(sanitizedNumber)
    if not targetSource then
        bridge.notifications.notify(src, { description = locale('Restricted.Unabletolocate'), type = 'error' })
        return { ok = false, reason = 'miss', wait = cooldownSeconds }
    end

    local targetPed = GetPlayerPed(targetSource)
    if targetPed == 0 or not DoesEntityExist(targetPed) then
        bridge.notifications.notify(src, { description = locale('Restricted.Unabletolocate'), type = 'error' })
        return { ok = false, reason = 'miss', wait = cooldownSeconds }
    end

    local coords = GetEntityCoords(targetPed)
    local x = coords and coords.x
    local y = coords and coords.y
    local z = coords and coords.z
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then
        bridge.notifications.notify(src, { description = locale('Restricted.Unabletolocate'), type = 'error' })
        return { ok = false, reason = 'miss', wait = cooldownSeconds }
    end

    if Config.Utility.Debug then
        print(('[MrNewbPhoneTracker] Player %s pinged phone %s'):format(src, sanitizedNumber))
    end
    return { ok = true, coords = { x = x, y = y, z = z }, wait = cooldownSeconds }
end)

bridge.framework.registerItemUse(Config.TrackerItem, function(src)
    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then return end

    if not hasRequiredJob(src) then
        bridge.notifications.notify(src, { description = locale('Restricted.JobLocked'), type = 'error' })
        return
    end

    if type(Config.TrackerItem) ~= 'string' or Config.TrackerItem == '' then return end
    if not bridge.inventory.hasItem(src, Config.TrackerItem, 1) then
        bridge.notifications.notify(src, { description = locale('Restricted.NoItem'), type = 'error' })
        return
    end

    TriggerClientEvent('MrNewbPhoneTracker:Client:OpenTracker', src)
end)

AddEventHandler('playerDropped', function()
    lastPingTime[source] = nil
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    exports[bridge.name]:VersionCheck('MrNewb/patchnotes', resourceName)

    for phoneResource in pairs(findSourceByPhoneResource) do
        if GetResourceState(phoneResource) == 'started' then
            startedPhoneResource = phoneResource
            break
        end
    end
end)
