
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'iamlation'
description 'A zone script to create controlled areas on the map.'
version '1.0.0'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/*.css',
    'ui/*.js',
}

dependency 'ox_lib'
