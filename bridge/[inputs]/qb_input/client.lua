if Config.Input.QbInput ~= true then return print("QbInput CS Off") end

function CreateInput(data)
	local qbdata = exports['qb-input']:ShowInput({
		header = data.title,
		submitText = "Confirm",
		inputs = {
			{ type = 'text', isRequired = true, text = data.options1, name = 'inputted1',},
		}
	})
	local phonemenu = qbdata and qbdata.inputted1 or nil
	if phonemenu then
		ReturnedInput(qbdata)
	end
end
