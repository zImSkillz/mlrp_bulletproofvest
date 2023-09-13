fx_version 'adamant'

game 'gta5'

description 'Bulletproof Vest Script by zImSkillz'

author 'zImSkillz'

lua54 'yes'
version '1.0.0'

dependencies {
	'es_extended',
	'ox_inventory'
}

shared_scripts { 
	'@es_extended/imports.lua',
	'@es_extended/locale.lua'
}

server_scripts {
	'Server/Server.lua'
}

client_scripts {
	'Client/Client.lua'
}