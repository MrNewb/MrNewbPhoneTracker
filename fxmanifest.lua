fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'MrNewbPhoneTracker'
author 'MrNewb'
description 'Phone Tracker for FiveM, this allows for tracking a player by the phone number.'
version '3.2.1'

shared_scripts {
    '@ox_lib/init.lua',
    '@Newb_Bridge/import.lua',
    'resource/open/shared/config.lua',
    'resource/modules/core/shared/locale.lua',
}

client_scripts {
    'resource/modules/tracker/client/tracker.lua',
}

server_scripts {
    'resource/open/server/*.lua',
    'resource/modules/tracker/server/tracker.lua',
}

ui_page 'web/build/index.html'

files {
    'locales/*.json',
    'web/build/index.html',
    'web/build/**/*',
}

dependencies {
    '/server:6116',
    '/onesync',
    'ox_lib',
    'Newb_Bridge',
}

escrow_ignore {
    '**/*',
}
