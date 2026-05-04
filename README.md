# 🔔 Herd Notifications

A modern, customizable notification system for FiveM with beautiful themes, sound effects, and persistent settings.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)
<img width="1367" height="736" alt="notification" src="https://github.com/user-attachments/assets/9f662c95-0603-4dac-b5e1-97f4a62f028e" />

## ✨ Features

- 🎨 **3 Beautiful Themes** - Colorful, Dark, and Light modes
- 🔊 **Sound Effects** - Toggle notification sounds on/off
- 📍 **Customizable Position** - Drag and drop notifications anywhere on screen
- 💾 **Persistent Settings** - Your preferences are saved locally
- 🎯 **4 Notification Types** - Success, Error, Warning, and System
- 🖱️ **Interactive Settings Panel** - Easy-to-use configuration UI
- ⚡ **Lightweight** - Optimized performance with smooth animations

## 📦 Installation

1. Download the resource
2. Place `herd_notifications` folder in your server's `resources` directory
3. Add `ensure herd_notifications` to your `server.cfg`
4. Restart your server

## 🎮 Usage

### Client-Side Export (Recommended)

```lua
-- Basic notification
exports['herd_notifications']:Notify('success', 'Title', 'Message')

-- Examples for each type
exports['herd_notifications']:Notify('success', 'Success', 'Your vehicle is repaired and ready to drive')
exports['herd_notifications']:Notify('error', 'Error', 'Transaction failed due to insufficient funds')
exports['herd_notifications']:Notify('warning', 'Warning', 'Fuel level critical. Engine failure expected')
exports['herd_notifications']:Notify('system', 'System', 'Server restart in 20 minutes')
```

### Client-Side Trigger Event

```lua
-- Basic notification
TriggerEvent('herd_notifications:notify', 'success', 'Title', 'Message')

-- Examples
TriggerEvent('herd_notifications:notify', 'error', 'Payment Failed', 'You do not have enough money')
TriggerEvent('herd_notifications:notify', 'warning', 'Low Health', 'Your health is critically low')
```

### Server-Side Trigger Event

```lua
-- Send to specific player
TriggerClientEvent('herd_notifications:notify', source, 'success', 'Welcome', 'Welcome to the server!')

-- Send to all players
TriggerClientEvent('herd_notifications:notify', -1, 'system', 'Announcement', 'Server restart in 10 minutes')

-- Examples
TriggerClientEvent('herd_notifications:notify', playerId, 'success', 'Money Received', 'You received $5000')
TriggerClientEvent('herd_notifications:notify', playerId, 'error', 'Access Denied', 'You do not have permission')
```

## 🎨 Notification Types

| Type | Description | Use Case |
|------|-------------|----------|
| `success` | Green themed | Successful actions, confirmations |
| `error` | Red themed | Errors, failures, denied actions |
| `warning` | Orange themed | Warnings, cautions, alerts |
| `system` | Blue themed | System messages, information |

## ⚙️ Theme Management

### Change Theme via Export

```lua
-- Available themes: 'color', 'dark', 'light'
exports['herd_notifications']:SetTheme('dark')
```

### Change Theme via Command

```
/theme color
/theme dark
/theme light
```

## 🔊 Sound Management

### Toggle Sound via Export

```lua
exports['herd_notifications']:SetSound(true)  -- Enable sound
exports['herd_notifications']:SetSound(false) -- Disable sound
```

## 📍 Position Management

### Set Position via Export

```lua
-- x = distance from right edge, y = distance from top edge
exports['herd_notifications']:SetPosition(30, 30)  -- Top right (default)
exports['herd_notifications']:SetPosition(30, 500) -- Middle right
```

### Adjust Position via UI

```
/notifysettings
```
Then click "Adjust Position" and drag the preview notification to your desired location.

## 🎯 Commands

| Command | Description |
|---------|-------------|
| `/notifysettings` | Open the settings panel |
| `/theme [color\|dark\|light]` | Change notification theme |
| `/testnotify [type]` | Test notifications (all, success, error, warning, system) |
| `/notifyreset` | Reset all settings to default |

## 📋 Examples

### Basic Usage in Your Resource

```lua
-- client.lua
RegisterCommand('payday', function()
    local amount = 5000
    -- Your payday logic here
    exports['herd_notifications']:Notify('success', 'Payday', 'You received $' .. amount)
end)

RegisterCommand('buyvehicle', function()
    local hasEnoughMoney = false -- Your check here
    
    if hasEnoughMoney then
        exports['herd_notifications']:Notify('success', 'Purchase Complete', 'Vehicle purchased successfully')
    else
        exports['herd_notifications']:Notify('error', 'Purchase Failed', 'Insufficient funds')
    end
end)
```

### Server-Side Usage

```lua
-- server.lua
RegisterCommand('heal', function(source, args)
    local playerId = source
    
    -- Your heal logic here
    TriggerClientEvent('herd_notifications:notify', playerId, 'success', 'Healed', 'Your health has been restored')
end)

-- Broadcast to all players
AddEventHandler('playerConnecting', function(name)
    TriggerClientEvent('herd_notifications:notify', -1, 'system', 'Player Joining', name .. ' is connecting to the server')
end)
```

### Advanced Integration

```lua
-- ESX Example
ESX.ShowNotification = function(msg, type, length)
    local notifType = type or 'system'
    exports['herd_notifications']:Notify(notifType, 'Notification', msg)
end

-- QB-Core Example
QBCore.Functions.Notify = function(text, texttype, length)
    local notifType = texttype or 'system'
    exports['herd_notifications']:Notify(notifType, 'Notification', text)
end
```

## 🎨 Themes Preview

### Colorful Theme
Vibrant gradient backgrounds with white text - perfect for a modern, eye-catching look.

### Dark Theme
Glassmorphic dark design with subtle gradients - ideal for immersive gameplay.

### Light Theme
Clean white backgrounds with colored accents - great for visibility and clarity.

## 💾 Settings Storage

All player preferences are stored locally using FiveM's Resource KVP system:
- **Theme preference** - Your selected theme
- **Sound preference** - Sound enabled/disabled
- **Position preference** - Custom notification position

Settings persist across:
- ✅ Game restarts
- ✅ Resource restarts
- ✅ Server changes

## 🔧 Configuration

The notification system works out of the box with sensible defaults:
- **Default Theme**: Colorful
- **Default Sound**: Enabled
- **Default Position**: Top-right (30px from right, 30px from top)
- **Notification Duration**: 5 seconds
- **Sound Volume**: 50%

## 📱 Responsive Design

- Automatically adapts to different screen resolutions
- Position validation ensures notifications stay on-screen
- Smooth animations and transitions
- Mobile-friendly (for FiveM mobile clients)

## 🚀 Performance

- Minimal resource usage (~0.00ms idle)
- Optimized animations using CSS transforms
- No constant loops or heavy operations
- Efficient event handling

## 🐛 Troubleshooting

### Notifications not showing
1. Check if the resource is started: `ensure herd_notifications`
2. Verify the resource name matches your folder name
3. Try resetting settings: `/notifyreset`

### Notifications appearing off-screen
Run `/notifyreset` to restore default position

### Sound not playing
1. Check if sound is enabled in settings: `/notifysettings`
2. Verify `notification.mp3` exists in `html/sound/` folder
3. Check your game audio settings

### Cursor stuck on screen
This should not happen, but if it does:
1. Press ESC to close any open UI
2. Restart the resource: `restart herd_notifications`

## 📄 License

This resource is provided as-is for FiveM servers.

## 👨‍💻 Author

**Herd Developments**

## 🤝 Support

For issues, suggestions, or contributions, please contact the development team.

## 📝 Changelog

### Version 1.0.0
- Initial release
- 3 theme options (Colorful, Dark, Light)
- 4 notification types (Success, Error, Warning, System)
- Sound effects with toggle
- Draggable position adjustment
- Persistent settings storage
- Export and event trigger support
- Interactive settings panel

---

Made with ❤️ by Herd Developments
