fx_version 'cerulean'
game 'gta5'

author 'F1r3'
description 'UltimateX QBCore Anti-Cheat'
version '1.0.0'

shared_script 'config/config.lua'

server_scripts {
    'server/anticheat.lua',
    'server/updater.lua'
}

client_scripts {
    'client/detection.lua',
    'client/monitor.lua'
}
