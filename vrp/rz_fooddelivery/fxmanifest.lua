fx_version 'adamant'
game 'gta5'

version '1.2.0'


ui_page "html/index.html"

files {
    "html/index.html",
    "html/css/style.css",
    "html/js/javascript.js"
}

client_scripts {
    "config.lua",
	"client/main.lua",
	    "lib/Tunnel.lua",
	"lib/Proxy.lua",
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
    "config.lua",
	"server/main.lua",
	"@vrp/lib/utils.lua",
}

