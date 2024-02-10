RegisterNetEvent("MrNewbPhoneTracker:requestCoord", function()
    local data = {}
    data.title = 'Ping Phone Tower For Phone'
    data.options1 = 'Phone Number'
    CreateInput(data)
end)

function ReturnedInput(data)
	if not data.inputted1 then return end
	TriggerServerEvent("MrNewbPhoneTracker:getCoord", data.inputted1)
end

RegisterNetEvent('MrNewbPhoneTracker:provideCoord', function(coords)
    local data = {}
    data.message = "Pinged Phone"
    data.description = "Pinged Phone"
    data.icon = 'fa-solid fa-phone'
    data.coords = coords
    data.gender = false
    data.radius = 30
    data.sprite = 817
    data.color = 1
    data.scale = 0.8
    data.length = 5
    data.shortrange = true
	DispatchData(data)
end)

RegisterNetEvent('MrNewbPhoneTracker:trackedvictim', function()
	local ped = (cache.ped or PlayerPedId())
	local pedcoord = GetEntityCoords(ped)
	PlaySoundFromCoord(-1, "Drill_Pin_Break", pedcoord.x,pedcoord.y,pedcoord.z, "DLC_HEIST_FLEECA_SOUNDSET", true, 5, false)
	Wait(3000)
	PlaySoundFromCoord(-1, "Drill_Pin_Break", pedcoord.x,pedcoord.y,pedcoord.z, "DLC_HEIST_FLEECA_SOUNDSET", true, 5, false)
end)