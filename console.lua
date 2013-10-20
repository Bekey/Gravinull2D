console = {}
console.state = false
console.width = 40
console.height = 20
console.lineheight = 15
console.currline = 15
console.lines = {
}

local font = loveframes.basicfontsmall
love.graphics.setFont(font)

function console:draw()
	local r, g, b, a = love.graphics.getColor()
	
	love.graphics.setLineWidth(1)
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 5, 10, console.width, console.height)
	love.graphics.setColor(22, 22, 60, 255)
	love.graphics.rectangle("line", 5, 10, console.width, console.height)

	love.graphics.setColor(r, g, b, a)
	
	if(self.state) then
		if self.width < 300 then
			self.width = self.width + 20
			self.height = self.width + 20
			return
		end

		self:output()
		
	else
		if self.width > 40 then
			self.width = self.width - 20
			self.height = self.width - 20
		end
		console.lines = {}
	end
	
end

function console:switch()
	if(self.state) then
		self.state = false
	else
		self.state = true
	end
end

function console:output()

	while #self.lines > 20 do
		table.remove(self.lines,1)
	end
	
	for i,v in ipairs(self.lines) do
		love.graphics.print( v, 15, self.lineheight+self.currline*(i-1) )
	end

end

function console:input(txt)
	if(self.state) then
		table.insert(self.lines, txt)
	end
end

--	love.graphics.print(camera:mouseGetX()..[[, ]]..camera:mouseGetY(), width/2, height/2)
--	love.graphics.rectangle("fill", love.mouse.getX()-30, love.mouse.getY()-30, 60, 60)
--	love.graphics.print("FPS: " .. love.timer.getFPS(), width/2, height/2+40)