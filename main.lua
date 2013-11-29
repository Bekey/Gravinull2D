--	Libraries - libraries.txt for more info
--=============================================--
ATL = require("libs.AdvTiledLoader")
Camera = require("libs.hump.camera")
Vector = require("libs.hump.vector")
Timer = require("libs.hump.timer")
Gamestate = require("libs.hump.gamestate")
require("libs.AnAL")

--	App files
--=============================================--
Entities = require("entities")
Collision = require("collision")

--	Temporary globals
--=============================================--
ATL.Loader.path = 'maps/'
map = ATL.Loader.load("desert.tmx")
love.graphics.setDefaultImageFilter( "nearest", "nearest" )
love.physics.setMeter(map.tileWidth)
world = love.physics.newWorld(0, 0, true)
world:setCallbacks(Collision.beginContact, Collision.endContact, Collision.preSolve, Collision.postSolve)
DEBUG = false
images = {}
fonts = {}

-- Gamestates
--=============================================--
local menu = require("states.mainmenu")
local game = require("states.game")


-- love.load()
--=============================================--
function love.load()
	local img_filenames = {
	"mines",
	"amy/amy_arm", "amy/amy_joint", "amy/amy_gears",
	"effects/flash",
	"mainmenu/background", "mainmenu/eye_big", "mainmenu/eye_small", "mainmenu/item_all", "mainmenu/item_decal", "mainmenu/logo", "mainmenu/wall_left", "mainmenu/wall_right",
	}
	images["amy_plate"] = love.image.newImageData("assets/amy/amy_plating.png")
	for _, v in ipairs(img_filenames) do
		images[v] = love.graphics.newImage("assets/" .. v .. ".png")
	end
	
	fonts["silkscreen8"] = love.graphics.newFont("assets/slkscr.ttf", 8)
	fonts["silkscreen16"] = love.graphics.newFont("assets/slkscr.ttf", 16)
	fonts["silkscreen24"] = love.graphics.newFont("assets/slkscr.ttf", 24)
	fonts["silkscreen32"] = love.graphics.newFont("assets/slkscr.ttf", 32) 
	
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

-- Gamestate switch handling
--=============================================--
function menu:mousepressed(x, y, button)
    if y >= 360 and y<= 360+30 then
        Gamestate.switch(game)
    end
end