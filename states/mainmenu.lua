local menu = {} -- TODO ANIMATIONS and SHADERS

local ExampleText = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tristique, dolor at auctor tincidunt, purus urna imperdiet lectus, ac fringilla leo dolor sit amet erat.]]
local Bugtext = [[Report it on our github webpage
				http://github.com/lorem/ipsum/
				
				or email us at lorem@ipsum.com
				
				
				Copyright (c) 2014 - Alpha 0.1.0]]
local NewsText = [[ New game modes coming!
				 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tristique, dolor at auctor tincidunt, purus urna imperdiet lectus, ac fringilla leo dolor sit amet erat. Maecenas dolor erat, pharetra et ante ac, bibendum posuere lorem.
				 Aliquam erat volutpat. Cras justo neque, tincidunt vitae dolor a, vestibulum ornare tellus. Quisque vel ante at lectus euismod fermentum non vitae quam. Cras ipsum tortor, vehicula eu laoreet vitae, vulputate in nisl. Duis ut sagittis nibh. ]]

function menu:enter() 
	self.width, self.height = love.graphics.getWidth(), love.graphics.getHeight()
	self.ratio =  self.height / 600
end

function menu:draw()
	love.graphics.setColor(255, 255, 255)
	
	
	self:renderImage(images["mainmenu/background"], "resize-y", "center")
	
	self:renderImage(images["mainmenu/eye_big"], 0, "center", "top", 0, 208)

	self:renderImage(images["mainmenu/eye_small"], 0, "center", "top", 80, 299)
	self:renderImage(images["mainmenu/eye_small"], 0, "center", "top", -80, 299)
	
	self:renderImage(images["mainmenu/wall_left"], "resize-y", "left")
	self:renderImage(images["mainmenu/wall_right"], "resize-y", "right")
	self:renderImage(images["mainmenu/logo"], "resize-x", "center", "top", 0, 15)
	
	
	for j=0, 1 do
		for i=0, 1 do
			local quad = love.graphics.newQuad(i*148, j*30, 148, 30, images["mainmenu/item_all"]:getWidth(), images["mainmenu/item_all"]:getHeight())
			if i == 1 and j == 1 then
				self:renderImage(images["mainmenu/item_decal"], 0, "center", "top", 0, 360 + 48 * i + 48 * j * 2 )
				i = 2
			end
			self:renderQuad(images["mainmenu/item_all"], quad, 0, "center", "top", 0, 360 + 48 * i + 48 * j * 2 )
		end
	end
	
	self:renderText("What is this game?", ExampleText, "left", 138)
	self:renderText("The controls?", ExampleText, "left", 218)
	self:renderText("What is this game?", ExampleText, "left", 338)
	self:renderText("The controls?", ExampleText, "left", 418)
	
	self:renderText("Things to come", NewsText..NewsText, "right", 138)
	self:renderText("Found a bug?", Bugtext, "right", 525)
end

function menu:renderImage(image, resize, horizontal, vertical, xOff, yOff)
	local scale = self.ratio
	local yOff = yOff or 0
	local xOff = xOff or 0
	local x =  0 + xOff * scale
	local y =  0 + yOff * scale
	
	if resize == "resize-y" then
		scale = self.height / image:getHeight()
	elseif resize == "resize-x" then
		scale = self.width / image:getWidth()
	end
	
	if horizontal == "center" then
		x = x + (self.width - image:getWidth() * scale) / 2 
	elseif horizontal == "right" then
		x = x + self.width - image:getWidth() * scale
	elseif horizontal == "left" then
		x = 0
	else
		x = 0
	end
	
	love.graphics.draw(image, x, y, 0, scale)
end

function menu:renderQuad(image, quad, resize, horizontal, vertical, xOff, yOff)
	local ax, ay, w, h = quad:getViewport( )
	local scale = self.ratio
	local yOff = yOff or 0
	local xOff = xOff or 0
	local x =  0 + xOff * scale
	local y =  0 + yOff * scale
	
	if resize == "resize-y" then
		scale = self.height / w
	elseif resize == "resize-x" then
		scale = self.width / h
	end
	
	if horizontal == "center" then
		x = x + (self.width - w * scale) / 2 
	elseif horizontal == "right" then
		x = x + self.width - h * scale
	elseif horizontal == "left" then
		x = 0
	else
		x = 0
	end
	
	love.graphics.drawq(image, quad, x, y, 0, scale)
end

function menu:renderText(Header, Text, Align, y) -- TODO: !!!
	local x = 10
	if Align == "right" then
		x = love.graphics.getWidth()-images["mainmenu/wall_right"]:getWidth() + 65
	end
	love.graphics.setFont(fonts["silkscreen16"])
	love.graphics.setColor(153, 229, 80)
	love.graphics.print(Header, x, y)
	love.graphics.setFont(fonts["silkscreen8"])
	love.graphics.setColor(203, 219, 252)
	love.graphics.printf(Text, x, y+16, 185)
end

return menu