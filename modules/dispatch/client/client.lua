function DispatchData(coords)
	if not coords then return print("No data provided") end
    Bridge.Dispatch.SendAlert({
        coords = coords,
        ped = PlayerPedId(),
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

RegisterNetEvent("MrNewbPhoneTracker:requestCoord", function()
    if source ~= 65535 then return end
    CreateInput()
end)