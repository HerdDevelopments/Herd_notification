local currentTheme = 'color'
local soundEnabled = true
local notificationPosition = { x = 30, y = 30 } -- Default top-right position

-- Load saved settings
local function LoadSettings()
    local savedTheme = GetResourceKvpString('herd_notify_theme')
    local savedSound = GetResourceKvpString('herd_notify_sound')
    local savedPosX = GetResourceKvpInt('herd_notify_pos_x')
    local savedPosY = GetResourceKvpInt('herd_notify_pos_y')
    
    if savedTheme then
        currentTheme = savedTheme
    end
    
    if savedSound then
        soundEnabled = savedSound == 'true'
    end
    
    -- Validate position values (must be reasonable screen coordinates)
    if savedPosX and savedPosX >= 0 and savedPosX <= 3840 then
        notificationPosition.x = savedPosX
    end
    
    if savedPosY and savedPosY >= 0 and savedPosY <= 2160 then
        notificationPosition.y = savedPosY
    end
end

-- Save settings
local function SaveSettings()
    SetResourceKvp('herd_notify_theme', currentTheme)
    SetResourceKvp('herd_notify_sound', tostring(soundEnabled))
    
    -- Validate position before saving
    local x = math.floor(notificationPosition.x)
    local y = math.floor(notificationPosition.y)
    
    -- Clamp values to reasonable ranges
    x = math.max(0, math.min(x, 3840))
    y = math.max(0, math.min(y, 2160))
    
    SetResourceKvpInt('herd_notify_pos_x', x)
    SetResourceKvpInt('herd_notify_pos_y', y)
end

-- Load settings on resource start
CreateThread(function()
    LoadSettings()
end)

-- Export to set theme
exports('SetTheme', function(theme)
    if theme == 'color' or theme == 'dark' or theme == 'light' then
        currentTheme = theme
        SaveSettings()
        SendNUIMessage({
            action = 'setTheme',
            theme = theme
        })
    end
end)

-- Export to toggle sound
exports('SetSound', function(enabled)
    soundEnabled = enabled
    SaveSettings()
    SendNUIMessage({
        action = 'setSound',
        enabled = enabled
    })
end)

-- Export to set position
exports('SetPosition', function(x, y)
    notificationPosition = { x = x, y = y }
    SaveSettings()
    SendNUIMessage({
        action = 'setPosition',
        x = x,
        y = y
    })
end)

-- Export to trigger notification
exports('Notify', function(type, title, message)
    SendNUIMessage({
        action = 'notify',
        type = type,
        title = title,
        message = message,
        sound = soundEnabled
    })
end)

-- Event handler for triggering notifications
RegisterNetEvent('herd_notifications:notify', function(type, title, message)
    exports[GetCurrentResourceName()]:Notify(type, title, message)
end)

-- Event handler for theme change
RegisterNetEvent('herd_notifications:setTheme', function(theme)
    exports[GetCurrentResourceName()]:SetTheme(theme)
end)

-- Event handler for sound toggle
RegisterNetEvent('herd_notifications:setSound', function(enabled)
    exports[GetCurrentResourceName()]:SetSound(enabled)
end)

-- Event handler for position change
RegisterNetEvent('herd_notifications:setPosition', function(x, y)
    exports[GetCurrentResourceName()]:SetPosition(x, y)
end)

-- Command to test notifications
RegisterCommand('testnotify', function(source, args, rawCommand)
    local type = args[1] or 'all'
    
    if type == 'all' then
        exports[GetCurrentResourceName()]:Notify('warning', 'Warning', 'Fuel Level critical. Engine failure expected')
        Wait(600)
        exports[GetCurrentResourceName()]:Notify('success', 'Success', 'Your Vehicle is repaired and ready to drive')
        Wait(600)
        exports[GetCurrentResourceName()]:Notify('error', 'Error', 'Transaction Failed due to insufficient amount')
        Wait(600)
        exports[GetCurrentResourceName()]:Notify('system', 'System', 'Server restart in 20 mints. please finish your work')
    else
        local title = args[2] or 'Test'
        local message = args[3] or 'This is a test notification.'
        exports[GetCurrentResourceName()]:Notify(type, title, message)
    end
end, false)

-- Command to change theme
RegisterCommand('theme', function(source, args, rawCommand)
    local theme = args[1]
    if theme == 'color' or theme == 'dark' or theme == 'light' then
        exports[GetCurrentResourceName()]:SetTheme(theme)
        exports[GetCurrentResourceName()]:Notify('system', 'Theme Updated', 'Notification theme changed to ' .. theme)
    else
        print('^1[Herd Notifications] ^7Invalid theme. Use: /theme color | /theme dark | /theme light')
    end
end, false)

-- Command to reset settings to default
RegisterCommand('notifyreset', function(source, args, rawCommand)
    -- Reset to defaults
    currentTheme = 'color'
    soundEnabled = true
    notificationPosition = { x = 30, y = 30 }
    
    -- Clear saved settings
    DeleteResourceKvp('herd_notify_theme')
    DeleteResourceKvp('herd_notify_sound')
    DeleteResourceKvp('herd_notify_pos_x')
    DeleteResourceKvp('herd_notify_pos_y')
    
    -- Apply defaults
    exports[GetCurrentResourceName()]:SetTheme(currentTheme)
    exports[GetCurrentResourceName()]:SetSound(soundEnabled)
    exports[GetCurrentResourceName()]:SetPosition(notificationPosition.x, notificationPosition.y)
    
    exports[GetCurrentResourceName()]:Notify('success', 'Settings Reset', 'All notification settings have been reset to default')
end, false)

-- Command to open notification settings
RegisterCommand('notifysettings', function(source, args, rawCommand)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openSettings',
        currentTheme = currentTheme,
        soundEnabled = soundEnabled,
        position = notificationPosition
    })
end, false)

-- NUI Callback to close settings
RegisterNUICallback('closeSettings', function(data, cb)
    SetNuiFocus(false, false)
    
    -- Also send a message to ensure UI is closed
    SendNUIMessage({
        action = 'closeSettings'
    })
    
    cb('ok')
end)

-- NUI Callback to update theme
RegisterNUICallback('updateTheme', function(data, cb)
    currentTheme = data.theme
    SaveSettings()
    exports[GetCurrentResourceName()]:SetTheme(data.theme)
    cb('ok')
end)

-- NUI Callback to update sound
RegisterNUICallback('updateSound', function(data, cb)
    soundEnabled = data.enabled
    SaveSettings()
    exports[GetCurrentResourceName()]:SetSound(data.enabled)
    cb('ok')
end)

-- NUI Callback to save position
RegisterNUICallback('savePosition', function(data, cb)
    -- Validate and clamp position values
    local x = math.floor(tonumber(data.x) or 30)
    local y = math.floor(tonumber(data.y) or 30)
    
    -- Ensure values are within reasonable bounds
    x = math.max(0, math.min(x, 3840))
    y = math.max(0, math.min(y, 2160))
    
    notificationPosition = { x = x, y = y }
    SaveSettings()
    exports[GetCurrentResourceName()]:SetPosition(x, y)
    exports[GetCurrentResourceName()]:Notify('success', 'Position Saved', 'Notification position has been updated')
    cb('ok')
end)

-- Trigger initial theme and load saved settings
CreateThread(function()
    Wait(1000)
    SendNUIMessage({
        action = 'setTheme',
        theme = currentTheme
    })
    SendNUIMessage({
        action = 'setSound',
        enabled = soundEnabled
    })
    SendNUIMessage({
        action = 'setPosition',
        x = notificationPosition.x,
        y = notificationPosition.y
    })
end)
