if Config.Alert ~= "cd_Dispatch" then return end
if Config.Debug then print("Alert Set To ", Config.Alert) end

function DispatchData(data)
	if not data then return print("No data provided") end
	local cd_data = exports['cd_dispatch']:GetPlayerInfo()
	TriggerServerEvent('cd_dispatch:AddNotification', {
		job_table = {'police', }, 
		coords = data.coords,
		title = data.message,
		message = data.message, 
		flash = 0,
		unique_id = cd_data.unique_id,
		sound = 1,
		blip = {
			sprite = data.sprite or 198, 
			scale = data.scale or 1.0, 
			colour = data.color or 1,
			flashes = false, 
			text = data.message,
			time = data.length or 5,
			radius = data.radius or 30,
		}
	})
end
