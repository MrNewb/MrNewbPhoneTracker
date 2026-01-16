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
        local coords = Bridge.Callback.Trigger('MrNewbPhoneTracker_v2:Callback:GetCoord', trimmedInput)
        if not coords then return DebugInfo("No Coords Returned") end
        return DispatchData(coords)
    end
    return Bridge.Notify.SendNotify(locales("InputMenu.NoInput"), "error")
end