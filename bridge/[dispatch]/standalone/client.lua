if Config.Alert.Standalone ~= true then return end

function DispatchData(data)
	if not data then return print("No data provided") end
	local coords = data.coords
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, data.sprite)
	SetBlipAsShortRange(blip, data.shortrange)
	SetBlipScale(blip, data.scale)
	SetBlipColour(blip, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(data.message)
	EndTextCommandSetBlipName(blip)
	Wait(30000)
	RemoveBlip(blip)
end