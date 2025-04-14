RegisterNetEvent("MrNewbPhoneTracker:requestCoord", function()
    CreateInput()
end)

function DispatchData(coords)
	if not coords then return print("No data provided") end
    Bridge.Dispatch.SendAlert({
        coords = coords,
        ped = cache.ped,
        pedCoords = coords,
        blipData = {
            sprite = 161,
            color = 1,
            scale = 0.8
        },
        vehicle = nil,
        plate = nil,
        message = locales("Dispatch.Message"),
        code = locales("Dispatch.Code"),
        icon = locales("Dispatch.Icon"),
        jobs = {Config.RequireJob},
        time = 100000
    })
end

function CreateInput()
    local data = {
        {
            type = 'input',
            label = locales("InputMenu.Title"),
            description = locales("InputMenu.Description"),
            placeholder = locales("InputMenu.Placeholder"),
            icon = locales("InputMenu.Icon"),
            required = true,
        },
    }
    local inputData = Bridge.Input.Open(locales("InputMenu.Title"), data, false, locales("InputMenu.Submit"))
    if inputData and inputData[1] then
        local trimmedInput = string.gsub(inputData[1], "%s+", "")
        DebugInfo("Running Search For Number: " .. trimmedInput)
        local coords = lib.callback.await('MrNewbPhoneTracker_v2:Callback:GetCoord', false, trimmedInput)
        if not coords then return DebugInfo("No Coords Returned") end
        return DispatchData(coords)
    end
    return NotifyPlayer(locales("InputMenu.NoInput"), "error")
end