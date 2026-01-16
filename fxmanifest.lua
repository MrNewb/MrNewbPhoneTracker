fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'
name "MrNewbPhoneTracker"
author "MrNewb"
version '2.1.0'
description "Phone Tracker for FiveM, this allows for tracking a player by the phone number."

shared_scripts {
	'core/config.lua',
	'core/init.lua',
}

client_scripts {
	'modules/**/client/*.lua',
}

server_scripts {
	'modules/**/server/*.lua',
}

files {
	'locales/*.*',
}

dependencies {
	'/server:6116',
	'/onesync',
	'community_bridge',
}

escrow_ignore {
	'**/*.lua',
}