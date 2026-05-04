-- ============================================
-- HERD NOTIFICATIONS - USAGE EXAMPLES
-- ============================================

-- ============================================
-- CLIENT-SIDE EXAMPLES
-- ============================================

-- Basic Notification (Export Method - Recommended)
exports['herd_notifications']:Notify('success', 'Title', 'Message')

-- Using Trigger Event (Alternative Method)
TriggerEvent('herd_notifications:notify', 'success', 'Title', 'Message')

-- ============================================
-- NOTIFICATION TYPES
-- ============================================

-- Success Notification (Green)
exports['herd_notifications']:Notify('success', 'Success', 'Your vehicle is repaired and ready to drive')

-- Error Notification (Red)
exports['herd_notifications']:Notify('error', 'Error', 'Transaction failed due to insufficient funds')

-- Warning Notification (Orange)
exports['herd_notifications']:Notify('warning', 'Warning', 'Fuel level critical. Engine failure expected')

-- System Notification (Blue)
exports['herd_notifications']:Notify('system', 'System', 'Server restart in 20 minutes')

-- ============================================
-- THEME MANAGEMENT
-- ============================================

-- Change theme using export
exports['herd_notifications']:SetTheme('color')  -- Colorful theme
exports['herd_notifications']:SetTheme('dark')   -- Dark theme
exports['herd_notifications']:SetTheme('light')  -- Light theme

-- Change theme using event
TriggerEvent('herd_notifications:setTheme', 'dark')

-- ============================================
-- SOUND MANAGEMENT
-- ============================================

-- Enable/disable sound using export
exports['herd_notifications']:SetSound(true)   -- Enable sound
exports['herd_notifications']:SetSound(false)  -- Disable sound

-- Enable/disable sound using event
TriggerEvent('herd_notifications:setSound', true)

-- ============================================
-- POSITION MANAGEMENT
-- ============================================

-- Set position using export (x = from right, y = from top)
exports['herd_notifications']:SetPosition(30, 30)    -- Top right (default)
exports['herd_notifications']:SetPosition(30, 500)   -- Middle right
exports['herd_notifications']:SetPosition(800, 30)   -- Top center-ish

-- Set position using event
TriggerEvent('herd_notifications:setPosition', 30, 30)

-- ============================================
-- SERVER-SIDE EXAMPLES
-- ============================================

-- Send notification to specific player
RegisterCommand('givemoney', function(source, args)
    local playerId = source
    local amount = 5000
    
    -- Your money logic here
    
    TriggerClientEvent('herd_notifications:notify', playerId, 'success', 'Money Received', 'You received $' .. amount)
end)

-- Send notification to all players
RegisterCommand('announce', function(source, args)
    local message = table.concat(args, ' ')
    
    TriggerClientEvent('herd_notifications:notify', -1, 'system', 'Announcement', message)
end)

-- Player connecting notification
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local playerId = source
    
    TriggerClientEvent('herd_notifications:notify', -1, 'system', 'Player Joining', name .. ' is connecting to the server')
end)

-- ============================================
-- PRACTICAL EXAMPLES
-- ============================================

-- Example 1: Vehicle Purchase System
RegisterCommand('buyvehicle', function(source, args)
    local playerId = source
    local vehicleName = args[1] or 'Vehicle'
    local price = 50000
    local playerMoney = 100000 -- Get from your framework
    
    if playerMoney >= price then
        -- Deduct money and spawn vehicle
        TriggerClientEvent('herd_notifications:notify', playerId, 'success', 'Purchase Complete', 'You bought a ' .. vehicleName .. ' for $' .. price)
    else
        TriggerClientEvent('herd_notifications:notify', playerId, 'error', 'Purchase Failed', 'You need $' .. price .. ' to buy this vehicle')
    end
end)

-- Example 2: Health System
RegisterCommand('heal', function(source, args)
    local playerId = source
    
    -- Heal player logic
    TriggerClientEvent('herd_notifications:notify', playerId, 'success', 'Healed', 'Your health has been fully restored')
end)

-- Example 3: Warning System
RegisterCommand('warn', function(source, args)
    local targetId = tonumber(args[1])
    local reason = table.concat(args, ' ', 2)
    
    if targetId then
        TriggerClientEvent('herd_notifications:notify', targetId, 'warning', 'Warning', 'You have been warned: ' .. reason)
        TriggerClientEvent('herd_notifications:notify', source, 'system', 'Warning Sent', 'Player has been warned')
    end
end)

-- ============================================
-- ESX FRAMEWORK INTEGRATION
-- ============================================

-- Replace ESX notification system
ESX = exports['es_extended']:getSharedObject()

ESX.ShowNotification = function(msg, type, length)
    local notifType = type or 'system'
    exports['herd_notifications']:Notify(notifType, 'Notification', msg)
end

-- Usage in ESX scripts
ESX.ShowNotification('You received $5000', 'success')
ESX.ShowNotification('You do not have enough money', 'error')

-- ============================================
-- QB-CORE FRAMEWORK INTEGRATION
-- ============================================

-- Replace QB-Core notification system
QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.Notify = function(text, texttype, length)
    local notifType = texttype or 'system'
    exports['herd_notifications']:Notify(notifType, 'Notification', text)
end

-- Usage in QB-Core scripts
QBCore.Functions.Notify('Vehicle spawned successfully', 'success')
QBCore.Functions.Notify('You cannot do that right now', 'error')

-- ============================================
-- ADVANCED EXAMPLES
-- ============================================

-- Example 1: Timed Notifications
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        exports['herd_notifications']:Notify('system', 'Server Info', 'Remember to follow server rules!')
    end
end)

-- Example 2: Conditional Notifications
RegisterNetEvent('checkPlayerStatus', function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    
    if health < 50 then
        exports['herd_notifications']:Notify('warning', 'Low Health', 'Your health is critically low!')
    elseif health < 100 then
        exports['herd_notifications']:Notify('warning', 'Health Warning', 'Consider healing yourself')
    else
        exports['herd_notifications']:Notify('success', 'Healthy', 'You are in good health')
    end
end)

-- Example 3: Sequential Notifications
RegisterCommand('tutorial', function()
    exports['herd_notifications']:Notify('system', 'Tutorial', 'Welcome to the server!')
    Wait(3000)
    exports['herd_notifications']:Notify('system', 'Tutorial', 'Press F1 to open the menu')
    Wait(3000)
    exports['herd_notifications']:Notify('system', 'Tutorial', 'Press F2 to open inventory')
    Wait(3000)
    exports['herd_notifications']:Notify('success', 'Tutorial Complete', 'You are ready to play!')
end)

-- Example 4: Dynamic Content
RegisterNetEvent('playerLevelUp', function(newLevel)
    exports['herd_notifications']:Notify('success', 'Level Up!', 'You reached level ' .. newLevel)
end)

-- Example 5: Error Handling
RegisterCommand('withdraw', function(source, args)
    local amount = tonumber(args[1])
    
    if not amount then
        exports['herd_notifications']:Notify('error', 'Invalid Amount', 'Please enter a valid number')
        return
    end
    
    if amount <= 0 then
        exports['herd_notifications']:Notify('error', 'Invalid Amount', 'Amount must be greater than 0')
        return
    end
    
    -- Process withdrawal
    exports['herd_notifications']:Notify('success', 'Withdrawal Complete', 'You withdrew $' .. amount)
end)

-- ============================================
-- TESTING COMMANDS
-- ============================================

-- Test all notification types
RegisterCommand('testall', function()
    exports['herd_notifications']:Notify('success', 'Success Test', 'This is a success notification')
    Wait(1000)
    exports['herd_notifications']:Notify('error', 'Error Test', 'This is an error notification')
    Wait(1000)
    exports['herd_notifications']:Notify('warning', 'Warning Test', 'This is a warning notification')
    Wait(1000)
    exports['herd_notifications']:Notify('system', 'System Test', 'This is a system notification')
end)

-- Test with custom messages
RegisterCommand('customnotif', function(source, args)
    local type = args[1] or 'system'
    local title = args[2] or 'Custom Title'
    local message = table.concat(args, ' ', 3) or 'Custom message'
    
    exports['herd_notifications']:Notify(type, title, message)
end)
