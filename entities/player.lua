local player = Entities.Derive("amy")
local Raycast = require("entities.raycast")

function player:update(dt)
	self.x, self.y = self.body:getPosition()
	
	if self.Grappled then -- Is the player self.Grappled to an entity?
		self:Grapple(self.Grappled)
	elseif self.Grabbed then -- Does it need anything here?
	
	end
	
	if self.isGrabbing then -- Pressing left mouse button
		if not self.Grabbed and self.canGrab then
			local x, y = cam:mousepos()
			local hitList = self:InsideCone(self:getViewCone(x, y, 200, 10))
			if hitList then
				local Grabbing = Raycast:ShootRaycast(self.x, self.y, hitList) -- Return the nearest grabeable entity
				if Grabbing then
					self:Grab(Grabbing)
				end
			end
		elseif self.canShoot then
			local x, y = cam:mousepos()
			local angle = math.atan2(y-self.y, x-self.x)
			self:Shoot(angle)
		end
	end
end

function player:mousepressed(x, y, button)
	-- GRAPPLING - - If the player is not holding and the right mouse is pressed: 
	if not self.Grabbed and not self.Grappled and button == "r" then
		local hitList = self:InsideCone( self:getViewCone( x, y, 1024, 5 ) )
		if hitList then
			local Grappling = Raycast:ShootRaycast(self.x, self.y, hitList)
			if Grappling then
				self.Grappled = Grappling
				local data = {["GRAPPLE"] = {self.id, self.Grappled.id}}
				Client:send(Serialize(data))
			end
		end
	end
	
	-- GRABBING - - If the player is not holding, can grab and left mouse is pressed:
	if not self.Grabbed and self.canGrab and button == "l" then
		self.isGrabbing = true
	end
	
	-- Shooting - - If the player is holding, can shoot and left mouse is pressed:
	if self.Grabbed and self.canShoot and button == "l" then
		local angle = math.atan2(y-self.y, x-self.x)
		self:Shoot(angle)
	end
	
	-- SWITCHING - - If the player is holding and middle mouse is pressed
	if self.Grabbed and self.canChangeMode and button == "m" then
		-- TODO: Add mode animation, timer, sound
		if self.Grabbed == "RED" then
			self.Grabbed = "BLUE"
		else
			self.Grabbed = "RED"
		end
	end
end
function player:draw()
	self:drawAmy()
	if DEBUG then
		love.graphics.print(self.Health,self.x+35,self.y+10)
		love.graphics.print(self.Score,self.x+35,self.y+25)
		love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
		local x, y = cam:mousepos()
		local x1, y1, x2, y2, x3, y3 = self:getViewCone(x, y, 1024, 5)
		love.graphics.polygon("line", x1, y1, x2, y2, x3, y3 )
	end
end
function player:mousereleased(x, y, button)
	if button == "r" then
		if self.Grappled then
			self.Grappled = nil
			local data = {["UNGRAPPLE"] = {self.id}}
			Client:send(Serialize(data))
		end
	elseif button == "l" then
		self.isGrabbing = false
	end
end


return player