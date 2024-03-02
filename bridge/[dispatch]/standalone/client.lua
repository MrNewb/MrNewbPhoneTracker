if Config.Alert ~= "Standalone" then return end
if Config.Debug then print("Alert Set To ", Config.Alert) end

function DispatchData(data)
	if not data then return print("No data provided") end
	if Config.Debug then print("DispatchData",json.encode(data)) end

	local blipr = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, 100.0)
	SetBlipColour(blipr, 1)
	SetBlipAlpha(blipr, 128)
	local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
	SetBlipSprite(blip, data.sprite)
	SetBlipAsShortRange(blip, data.shortrange)
	SetBlipScale(blip, data.scale)
	SetBlipColour(blip, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(data.message)
	EndTextCommandSetBlipName(blip)

	Wait(30000)
	RemoveBlip(blipr)
	RemoveBlip(blip)
end