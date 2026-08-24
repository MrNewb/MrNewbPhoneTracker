local trackerOpen = false
local activeBlip

local function showTrackedLocationOnMap(coords)
    if type(coords) ~= 'table' then return end

    local x = tonumber(coords.x or coords[1])
    local y = tonumber(coords.y or coords[2])
    local z = tonumber(coords.z or coords[3])
    if not x or not y or not z then return end

    SetNewWaypoint(x + 0.0, y + 0.0)

    if activeBlip and DoesBlipExist(activeBlip) then
        RemoveBlip(activeBlip)
    end

    activeBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(activeBlip, 161)
    SetBlipColour(activeBlip, 1)
    SetBlipScale(activeBlip, 0.8)
    SetBlipAsShortRange(activeBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(locale('Dispatch.Message'))
    EndTextCommandSetBlipName(activeBlip)

    bridge.notifications.notify({ title = locale('Dispatch.Code'), description = locale('Dispatch.Message'), type = 'inform', duration = 5000 })

    SetTimeout(100000, function()
        if activeBlip and DoesBlipExist(activeBlip) then
            RemoveBlip(activeBlip)
            activeBlip = nil
        end
    end)
end

local function closeTracker()
    if not trackerOpen then
        SetNuiFocus(false, false)
        return
    end
    trackerOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'TRACKER_STATE',
        data = { action = 'CLOSE' },
    })
end

local function openTracker()
    trackerOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'TRACKER_STATE',
        data = {
            action = 'OPEN',
            labels = {
                status = locale('Device.Status'),
                gps = locale('Device.Gps'),
                ping = locale('Device.Ping'),
                number = locale('Device.Number'),
                empty = locale('Device.Empty'),
                miss = locale('Restricted.Unabletolocate'),
                cooldown = locale('Device.Cooldown'),
                noItem = locale('Device.NoItem'),
            },
            cooldown = tonumber(Config.PingCooldown) or 10,
        },
    })
end

RegisterNetEvent('MrNewbPhoneTracker:Client:OpenTracker', function()
    if source ~= 65535 then return end
    openTracker()
end)

RegisterNUICallback('TRACKER_CLOSE', function(_, cb)
    closeTracker()
    cb({ ok = true })
end)

RegisterNUICallback('TRACKER_PING', function(data, cb)
    if not trackerOpen then
        cb({ ok = false, reason = 'miss' })
        return
    end

    if type(data) ~= 'table' or type(data.phoneNumber) ~= 'string' then
        cb({ ok = false, reason = 'empty' })
        return
    end

    local phoneNumber = data.phoneNumber:gsub('%s+', ''):gsub('%D', '')
    if phoneNumber == '' or #phoneNumber > 10 then
        cb({ ok = false, reason = 'empty' })
        return
    end

    if Config.Utility.Debug then
        print(('[MrNewbPhoneTracker] Searching for number %s'):format(phoneNumber))
    end

    local result = lib.callback.await('MrNewbPhoneTracker:Callback:PingNumber', false, phoneNumber)
    if type(result) ~= 'table' or not result.ok then
        if Config.Utility.Debug then
            print('[MrNewbPhoneTracker] Ping rejected', result and result.reason)
        end
        cb({
            ok = false,
            reason = type(result) == 'table' and result.reason or 'miss',
            wait = type(result) == 'table' and result.wait or nil,
        })
        return
    end

    cb({ ok = true, wait = result.wait })
    closeTracker()
    showTrackedLocationOnMap(result.coords)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    trackerOpen = false
    SetNuiFocus(false, false)
end)
