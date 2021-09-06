fx_version 'adamant'
game 'gta5'
author 'EDIT: NAT2K15'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
	'html/script.js',
	'html/img/user.png',
	'html/img/phone.png',
	'html/img/clock.png',
	'html/img/receipt.png',
	'html/img/knife.png'

}

shared_scripts {
	'config.lua'
}

client_scripts {
	'client/client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}