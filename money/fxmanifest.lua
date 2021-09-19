fx_version 'cerulean'
games { 'gta5' }
author 'NAT2K15'

ui_page 'html/index.html'


files {
    'html/index.html',
	'html/css/index.css',
    'html/js/script.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
    'html/img/logo.png',
    'html/img/bank.png',
}

shared_scripts {
    'config.lua'
}

client_script {
    'client/client.lua',
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}

server_export {
    'getaccount',
    'updateaccount',
    'bankNotify',
    'sendmoney'
}
client_export {
    'getclientaccount',
}