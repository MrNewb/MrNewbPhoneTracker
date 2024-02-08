if Config.Input.OxInput ~= true then return end

function CreateInput(data)
	local input = lib.inputDialog(data.title, {data.options1})
	if not input then return end
	data.inputted1 = input[1]
	ReturnedInput(data)
end
