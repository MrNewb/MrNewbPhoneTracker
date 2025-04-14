fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'
name "MrNewbPhoneTracker"
author "MrNewb"
version '2.0.1'
description "Phone Tracker for FiveM, this allows for tracking a player by the phone number."

shared_scripts {
	'@ox_lib/init.lua',
	'src/shared/config.lua',
	'src/shared/init.lua',
}

client_script {
	'src/client/*.lua',
}

server_scripts {
	'bridge/**/server.lua',
	'src/server/*.lua',
}

files {
	'locales/*.*',
}

dependencies {
	'/server:6116',
	'/onesync',
	'ox_lib',
	'community_bridge',
}

escrow_ignore {
	'src/shared/*.lua',   	-- Config files
	'src/client/*.lua',   	-- open files
	'src/server/*.lua',   	-- open files
	'bridge/**/*.lua', -- open files
}