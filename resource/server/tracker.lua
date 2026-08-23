lib.locale()

local activePhone
local lastPingAt = {}

local phoneTypes = {
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

---@param phoneNumber string
---@return number|false
local function findPlayerByPhoneNumber(phoneNumber)
    if type(phoneNumber) ~= 'string' or phoneNumber == '' or not activePhone then return false end
    local lookup = phoneTypes[activePhone]
    if type(lookup) ~= 'function' then return false end

    local targetSource = lookup(phoneNumber)
    targetSource = tonumber(targetSource)
    if not targetSource or targetSource < 1 then return false end
    if GetPlayerPed(targetSource) == 0 then return false end
    return targetSource
end

local function hasRequiredJob(src)
    local requiredJob = Config.RequiredJob
    if type(requiredJob) == 'string' then return bridge.framework.hasJob(src, requiredJob) == true end
    if type(requiredJob) ~= 'table' then return false end

    for jobName, minGrade in pairs(requiredJob) do
        if type(jobName) == 'number' then
            if type(minGrade) == 'string' and bridge.framework.hasJob(src, minGrade) then return true end
        elseif type(jobName) == 'string' then
            if bridge.framework.hasJob(src, jobName, tonumber(minGrade) or 0) then return true end
        end
    end
    return false
end

local function getPingCooldownSeconds()
    local seconds = tonumber(Config.PingCooldown) or 10
    if seconds < 0 then return 0 end
    return math.floor(seconds)
end

local function getCooldownRemaining(src)
    local cooldownSeconds = getPingCooldownSeconds()
    if cooldownSeconds <= 0 then return 0 end
    local lastPing = lastPingAt[src]
    if not lastPing then return 0 end
    local remaining = cooldownSeconds - (os.time() - lastPing)
    if remaining <= 0 then return 0 end
    return remaining
end

---@param phoneNumber any
---@return string|false
local function sanitizePhoneNumber(phoneNumber)
    if type(phoneNumber) ~= 'string' then return false end
    phoneNumber = phoneNumber:gsub('%s+', '')
    if phoneNumber == '' or #phoneNumber > 10 or phoneNumber:find('[^%d]') then return false end
    return phoneNumber
end

lib.callback.register('MrNewbPhoneTracker:callback:getCoord', function(src, phoneNumber)
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

    local cleanNumber = sanitizePhoneNumber(phoneNumber)
    if not cleanNumber then
        return { ok = false, reason = 'empty' }
    end

    local cooldownRemaining = getCooldownRemaining(src)
    if cooldownRemaining > 0 then
        bridge.notifications.notify(src, { description = locale('Restricted.Cooldown'), type = 'error' })
        return { ok = false, reason = 'cooldown', wait = cooldownRemaining }
    end

    lastPingAt[src] = os.time()
    local cooldownSeconds = getPingCooldownSeconds()

    local targetSource = findPlayerByPhoneNumber(cleanNumber)
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
        print(('[MrNewbPhoneTracker] Player ID %s has pinged phone %s'):format(src, cleanNumber))
    end
    return { ok = true, coords = { x = x, y = y, z = z }, wait = cooldownSeconds }
end)

bridge.framework.registerItemUse(Config.TrackerItem, function(src)
    if Config.Utility.Debug then print(('[MrNewbPhoneTracker] RegisterUsableItems | src: %s'):format(src)) end

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

    TriggerClientEvent('MrNewbPhoneTracker:client:requestCoord', src)
end)

AddEventHandler('playerDropped', function()
    lastPingAt[source] = nil
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    exports[bridge.name]:VersionCheck('MrNewb/patchnotes', resourceName)

    for phoneType in pairs(phoneTypes) do
        if GetResourceState(phoneType) == 'started' then
            activePhone = phoneType
            break
        end
    end
end)
