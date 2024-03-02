if Config.Alert ~= "PsDispatch" then return end
if Config.Debug then print("Alert Set To ", Config.Alert) end

function DispatchData(data)
	if not data then return print("No data provided") end
	exports['ps-dispatch']:CustomAlert({
		message = data.message,
		description = data.description,
		icon = data.icon or 'fa-solid fa-phone',
		coords = data.coords,
		gender = data.gender or false,
		radius = data.radius or 30,
		sprite = data.sprite or 198,
		color = data.color or 1,
		scale = data.scale or 1.0,
		length = data.length or 5,
	})
end