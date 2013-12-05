--	Libraries - libraries.txt for more info
--=============================================--
ATL 	= 	require("libs.AdvTiledLoader")
class 	= 	require("libs.hump.class")
Camera 	= 	require("libs.hump.camera")
Vector 	= 	require("libs.hump.vector")
Timer 	= 	require("libs.hump.timer")
State 	= 	require("libs.hump.gamestate")
Serialize= 	require("libs.ser")
			require("libs.AnAL")
			require("libs.LUBE")
 
--	App files
--=============================================--
Entities = 	require("entities")
Client	 = 	require("client")
local Collision = require("collision")

--	Temporary globals
--=============================================--
ATL.Loader.path = 'maps/'
map = ATL.Loader.load("desert.tmx")
love.graphics.setDefaultImageFilter( "nearest", "nearest" )
love.physics.setMeter(32)
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
	loadImageFiles()
	loadFontFiles()
    State.registerEvents()
    State.switch(menu)
end

function loadImageFiles()
	local img_filenames = {
	"mines", "amy/amy_arm", "amy/amy_joint", "amy/amy_gears", --TODO: Amy in one piece
	"effects/flash",
	"mainmenu/background", "mainmenu/eye_big", "mainmenu/eye_small", "mainmenu/item_all",
	"mainmenu/item_decal", "mainmenu/logo", "mainmenu/wall_left", "mainmenu/wall_right",
	}
	images["amy_plate"] = love.image.newImageData("assets/amy/amy_plating.png")
	for _, v in ipairs(img_filenames) do
		images[v] = love.graphics.newImage("assets/" .. v .. ".png")
	end
end

function loadFontFiles()
	fonts["silkscreen8"]  = love.graphics.newFont("assets/slkscr.ttf", 8)
	fonts["silkscreen16"] = love.graphics.newFont("assets/slkscr.ttf", 16)
	fonts["silkscreen24"] = love.graphics.newFont("assets/slkscr.ttf", 24)
	fonts["silkscreen32"] = love.graphics.newFont("assets/slkscr.ttf", 32) 
end

-- Gamestate switch handling
--=============================================--
function menu:mousepressed(x, y, button)
    	local a, b = Client:connect("92.37.108.102", 18112)
    if y >= 360 and y<= 360+30 then --TODO: Proper GUI stuff
        if a and not b then
        	State.switch(game)
    	end
    end
end

function menu:update(dt)
	Client:update(dt)
end