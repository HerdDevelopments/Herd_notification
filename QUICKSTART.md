# 🚀 Quick Start Guide

Get started with Herd Notifications in 2 minutes!

## 📦 Installation

1. Download and extract to your `resources` folder
2. Add to `server.cfg`:
```cfg
ensure herd_notifications
```
3. Restart your server

## 🎯 Basic Usage

### Show a Notification

```lua
exports['herd_notifications']:Notify('success', 'Title', 'Message')
```

### From Server to Client

```lua
TriggerClientEvent('herd_notifications:notify', playerId, 'success', 'Title', 'Message')
```

## 🎨 Notification Types

```lua
-- Success (Green)
exports['herd_notifications']:Notify('success', 'Success!', 'Action completed')

-- Error (Red)
exports['herd_notifications']:Notify('error', 'Error!', 'Something went wrong')

-- Warning (Orange)
exports['herd_notifications']:Notify('warning', 'Warning!', 'Be careful')

-- System (Blue)
exports['herd_notifications']:Notify('system', 'Info', 'System message')
```

## ⚙️ Player Commands

```
/notifysettings  - Open settings panel
/theme dark      - Change theme (color/dark/light)
/testnotify      - Test all notifications
/notifyreset     - Reset to defaults
```

## 🎨 Change Theme

```lua
exports['herd_notifications']:SetTheme('dark')  -- or 'color', 'light'
```

## 🔊 Toggle Sound

```lua
exports['herd_notifications']:SetSound(false)  -- Disable sound
exports['herd_notifications']:SetSound(true)   -- Enable sound
```

## 📍 Set Position

```lua
exports['herd_notifications']:SetPosition(30, 30)  -- x, y from top-right
```

## 💡 Common Examples

### Money Transaction
```lua
-- Client side
RegisterCommand('payday', function()
    exports['herd_notifications']:Notify('success', 'Payday', 'You received $5000')
end)
```

### Server to Player
```lua
-- Server side
RegisterCommand('heal', function(source)
    -- Your heal logic
    TriggerClientEvent('herd_notifications:notify', source, 'success', 'Healed', 'Health restored')
end)
```

### Broadcast to All
```lua
-- Server side
TriggerClientEvent('herd_notifications:notify', -1, 'system', 'Announcement', 'Server restart in 10 minutes')
```

## 🔗 Framework Integration

### ESX
```lua
ESX.ShowNotification = function(msg, type)
    exports['herd_notifications']:Notify(type or 'system', 'Notification', msg)
end
```

### QB-Core
```lua
QBCore.Functions.Notify = function(text, texttype)
    exports['herd_notifications']:Notify(texttype or 'system', 'Notification', text)
end
```

## 📚 More Examples

Check `EXAMPLES.lua` for detailed usage examples!

## 🆘 Need Help?

- Notifications not showing? Run `/notifyreset`
- Check console for errors (F8)
- Verify resource is started: `ensure herd_notifications`

---

That's it! You're ready to use Herd Notifications 🎉
