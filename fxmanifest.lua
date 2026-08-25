fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'MrNewbPhoneTracker'
author 'MrNewb'
description 'Phone Tracker for FiveM, this allows for tracking a player by the phone number.'
version '3.1.2'

shared_scripts {
    '@ox_lib/init.lua',
    '@Newb_Bridge/import.lua',
    'configs/config.lua',
    'resource/shared/locale.lua',
}

client_scripts {
    'resource/client/tracker.lua',
}

server_scripts {
    'resource/open/server/*.lua',
    'resource/server/tracker.lua',
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
    'configs/*.lua',
    'locales/*.json',
    'resource/open/**/*',
    'resource/**/*.lua',
    'web/**/*',
}
