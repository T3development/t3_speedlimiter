fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 't3mpu5'
description 't3_speedlimiter'
version '1.0.1'

client_scripts {
	'client/main.lua',
	'client/npc.lua',
}

server_scripts {
	'server/main.lua',
}

shared_scripts {
    'config.lua',
}

escrow_ignore {
	'config.lua',
	'client/main.lua',
	'client/npc.lua',
	'server/main.lua',
}