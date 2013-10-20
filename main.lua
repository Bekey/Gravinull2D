--require("libs.lovedebug")
require("libs.loveframes")
local ATL = require("libs.AdvTiledLoader")
vector = require "libs.hump.vector"
Timer = require "libs.hump.timer"
require("_math")
require("camera")
require("console")
require("entities")

----------------------------------------------------------------------------------------------------
-- GLOBALS?
ATL.Loader.path = 'maps/'
map = ATL.Loader.load("desert.tmx")
love.physics.setMeter(map.tileWidth)
world = love.physics.newWorld(0, 0, true)
objects = {}
images = {}
love.graphics.setDefaultImageFilter( "nearest", "nearest" )

----------------------------------------------------------------------------------------------------
-- LOAD THIS SHIT
function love.load()
	--[[ LOAD IMAGES
	]]	img_fn = {"amy_body", "amy_arm", "amy_joint", "mines"}
	for _, v in ipairs(img_fn) do
		images[v] = love.graphics.newImage("assets/".. v .. ".png")
	end

	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	mapwidth = map.width * map.tileWidth
	mapheight = map.height * map.tileHeight
	
	
	camera:setBounds(0, 0, mapwidth - width, mapheight - height)

	entities:loadAll()
	
	--------------------------------------------------------
	-- TODO: Bring this in a separate class/file/function
	for x, y, tile in map("Ground"):iterate() do
		if tile.properties.obstacle then
			local w, h, xOffset, yOffset
			if tile.properties.width then w = tile.properties.width else w = map.tileWidth end
			if tile.properties.height then h = tile.properties.height else h = map.tileHeight end
			if tile.properties.xOffset then xOffset = tile.properties.xOffset else xOffset = 0 end
			if tile.properties.yOffset then yOffset = tile.properties.yOffset else yOffset = 0 end
			objects.walls = {}
			objects.walls.body = love.physics.newBody(world, x*map.tileWidth+xOffset+w/2, y*map.tileHeight+yOffset+h/2)
			objects.walls.shape = love.physics.newRectangleShape(w, h)
			objects.walls.fixture = love.physics.newFixture(objects.walls.body, objects.walls.shape)
			objects.walls.fixture:setMask(16) 
		end
	end

end

----------------------------------------------------------------------------------------------------
-- UPDATE FUNCTION
function love.update(dt)
	--[[ LOVE FRAMES
	]]	loveframes.update(dt)

	--[[ THIS PUTS THE WORLD INTO MOTION
	]]	world:update(dt)
	
	--[[ ENTITIES
	]]	entities:update(dt)

	--[[ TIMER
	]]	Timer.update(dt)
    
	tx = math.floor(player:getX() - width / 2)
	ty = math.floor(player:getY() - height / 2)

	camera:setPosition(tx, ty)

	tx = camera:getX()
	ty = camera:getY()

end

----------------------------------------------------------------------------------------------------
-- DRAW FUNCTION
function love.draw()
	love.graphics.setColor(255, 255, 255)
	--[[ STUFF
	]]	camera:set()
		camera:draw()

	--[[ ATL MAP
	]]	map:setDrawRange(math.floor(tx), math.floor(ty), math.floor(width), math.floor(height))
		map:draw()
		
	--[[ ENTITIES
	]]	entities:draw()
	
		camera:unset()

	--[[ CONSOLE
	]]	console:draw()

	--[[ LOVE FRAMES
	]]	loveframes.draw()
end

----------------------------------------------------------------------------------------------------
-- KEYBOARD PRESSED
function love.keypressed(key, unicode)
	--[[ LOVE FRAMES
	]]	loveframes.keypressed(key, unicode)

	--[[ ATL MAP
	]]	map:callback("keypressed", key, unicode)
	if key == 'f4' then
		entities.Spawn("mine", camera:mouseGetX(), camera:mouseGetY())
	elseif key == 'f3' then
		love.load()
	elseif key == 'f2' then
		console:switch()
	elseif key == "f1" then
		local debug = loveframes.config["DEBUG"]
		loveframes.config["DEBUG"] = not debug
	end

end

----------------------------------------------------------------------------------------------------
-- KEYBOARD RELEASED
function love.keyreleased(key)
	--[[ LOVE FRAMES
	]]	loveframes.keyreleased(key)
end


----------------------------------------------------------------------------------------------------
-- MOUSE PRESSED
function love.mousepressed(x, y, button)
	--[[ LOVE FRAMES
	]]	loveframes.mousepressed(x, y, button)
	
	player:mousepressed(x,y,button)
	
end

----------------------------------------------------------------------------------------------------
-- MOUSE RELEASED
function love.mousereleased(x, y, button)
	--[[ LOVE FRAMES
	]]	loveframes.mousereleased(x, y, button)
	
end