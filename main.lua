--	Libraries - libraries.txt for more info
--=============================================--
ATL = require("libs.AdvTiledLoader")
Camera = require("libs.hump.camera")
Vector = require("libs.hump.vector")
Timer = require("libs.hump.timer")
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


function love.load()
	local img_filenames = {"amy/amy_arm", "amy/amy_joint", "amy/amy_plating", "amy/amy_gears", "mines", "effects/flash"}
	images["amy_plate"] = love.image.newImageData("assets/amy/amy_plating.png")
	for _, v in ipairs(img_filenames) do
		images[v] = love.graphics.newImage("assets/" .. v .. ".png")
	end

	local width, height, mapwidth, mapheight
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	mapwidth = map.width * map.tileWidth
	mapheight = map.height * map.tileHeight
	
	cam = Camera(0, 0)
	cam:zoom(1)
	cam:setBounds(width/2, height/2, mapwidth - width/2, mapheight - height/2)
	
	Entities:loadAll()
end

function love.update(dt)
	world:update(dt)
	Entities:update(dt)
	Timer.update(dt)
	cam:lookAt(math.floor(player:getX()),math.floor(player:getY()))
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	cam:attach()
	
	local dx, dy = cam.x - 400, cam.y - 300
	map:setDrawRange(dx, dy,800,600)
	map:draw()

	Entities:draw()

	cam:detach()
end

function love.keypressed(key, unicode)
	map:callback("keypressed", key, unicode)
	if key == 'f4' then
		local x,y = cam:worldCoords(love.mouse.getPosition())
		Entities.Spawn("amy", x, y)
	elseif key == 'f1' then
		DEBUG = not DEBUG
	end
end

function love.mousepressed(x, y, button)
	local x, y = cam:mousepos()
	Entities:mousepressed(x,y,button)
end

function love.mousereleased(x, y, button)
	local x, y = cam:mousepos()
	Entities:mousereleased(x,y,button)
end