local menu = {}
local ExampleText = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tristique, dolor at auctor tincidunt, purus urna imperdiet lectus, ac fringilla leo dolor sit amet erat.]]
local Bugtext = [[Report it on our github webpage
http://github.com/lorem/ipsum/

or email us at lorem@ipsum.com


Copyright (c) 2014 - Alpha 0.1.0]]
local NewsText = [[ New game modes coming!
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tristique, dolor at auctor tincidunt, purus urna imperdiet lectus, ac fringilla leo dolor sit amet erat. Maecenas dolor erat, pharetra et ante ac, bibendum posuere lorem.
 Aliquam erat volutpat. Cras justo neque, tincidunt vitae dolor a, vestibulum ornare tellus. Quisque vel ante at lectus euismod fermentum non vitae quam. Cras ipsum tortor, vehicula eu laoreet vitae, vulputate in nisl. Duis ut sagittis nibh. ]]

function menu:draw()
	love.graphics.setColor(255, 255, 255)
	local width, height = love.graphics.getWidth(), love.graphics.getHeight()
	
	love.graphics.draw(images["mainmenu/background"],(width-images["mainmenu/background"]:getWidth())/2,0)
	
	love.graphics.draw(images["mainmenu/eye_big"],(width-images["mainmenu/eye_big"]:getWidth())/2,208)
	love.graphics.draw(images["mainmenu/eye_small"],(width-images["mainmenu/eye_small"]:getWidth()-178)/2,299)
	love.graphics.draw(images["mainmenu/eye_small"],(width+238)/2,299, 0, -1, 1)
	
	for j=0, 1 do
		for i=0, 1 do
			local quad = love.graphics.newQuad(i*148, j*30, 148, 30, images["mainmenu/item_all"]:getWidth(), images["mainmenu/item_all"]:getHeight())
			if i == 1 and j == 1 then
				love.graphics.draw(images["mainmenu/item_decal"],(width-148)/2, 360 + 48 * i + 48 * j * 2 )
				i = 2
			end
			love.graphics.drawq(images["mainmenu/item_all"],quad,(width-148)/2, 360 + 48 * i + 48 * j * 2 )
		end
	end
	
	love.graphics.draw(images["mainmenu/wall_left"],0,0)
	love.graphics.draw(images["mainmenu/wall_right"],width-images["mainmenu/wall_right"]:getWidth(),0)
	
	love.graphics.draw(images["mainmenu/logo"],(width-images["mainmenu/logo"]:getWidth())/2,32)
	
	self:writeText("What is this game?", ExampleText, "left", 138)
	self:writeText("The controls?", ExampleText, "left", 218)
	self:writeText("What is this game?", ExampleText, "left", 338)
	self:writeText("The controls?", ExampleText, "left", 418)
	
	self:writeText("Things to come", NewsText..NewsText, "right", 138)
	self:writeText("Found a bug?", Bugtext, "right", 525)
end

function menu:writeText(Header, Text, Align, y)
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