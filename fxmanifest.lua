fx_version 'cerulean'
game 'gta5'

author 'Herd Developments'
description 'Modern notification system with customizable themes, sounds, and positions'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/icons/*.png',
    'html/sound/notification.mp3'
}

client_scripts {
    'client.lua'
}

exports {
    'Notify',
    'SetTheme',
    'SetSound',
    'SetPosition'
}
