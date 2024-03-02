if Config.Alert ~= "qs_Dispatch" then return end
if Config.Debug then print("Alert Set To ", Config.Alert) end

function DispatchData(data)
	if not data then return print("No data provided") end
	local playerData = exports['qs-dispatch']:GetPlayerInfo()

	TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
		job = { 'police' },
		callLocation = data.coords,
		callCode = { code = 'Phone Ping', snippet = '23-19' },
		message = data.message,
		flashes = false,
		image = image or nil,
		blip = {
			sprite = data.radius or 30,
			scale = data.scale or 1.0,
			colour = data.color or 1,
			flashes = data.flashes or true,
			text = data.message,
			time = (30 * 1000),
		}
	})
end