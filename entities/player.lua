local player = Entities.Derive("amy")
local Raycast = require("entities.raycast")

function player:update(dt)
	self.x, self.y = self:getPosition()
	
	if self.isGrappling then
		if Grappled then -- Is the player Grappled to an entity?
			self:Grapple(Grappled)
		end
	elseif self.isHolding then -- Does it need anything here?
	end
	
	if self.isGrabbing then -- Pressing left mouse button
		if not self.isHolding and self.canGrab then
			local Grabbing = Raycast:ShootRaycast(self.x+20, self.y+22, 200) -- Return the nearest grabeable entity
			if Grabbing then
				self:Grab(Grabbing)
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
	if not self.isHolding and not self.isGrappling and button == "r" then
		local Grappling = Raycast:ShootRaycast(self.x+20, self.y+22, 1024)
		if Grappling then
			self.isGrappling = true
			Grappled = Grappling
		end
	end
	-- GRABBING - - If the player is not holding, can grab and left mouse is pressed:
	if not self.isHolding and self.canGrab and button == "l" then
		self.isGrabbing = true
	end
	-- Shooting - - If the player is holding, can shoot and left mouse is pressed:
	if self.isHolding  and self.canShoot and button == "l" then
		local angle = math.atan2(y-self.y, x-self.x)
		self:Shoot(angle)
	end
	-- SWITCHING - - If the player is holding and middle mouse is pressed
	if self.isHolding and self.canChangeMode and button == "m" then
		-- TODO: Add mode animation, timer, sound
		if self.shootingMode == "RED" then
			self.shootingMode = "BLUE"
		else
			self.shootingMode = "RED"
		end
	end
end

function player:mousereleased(x, y, button)
	if button == "r" then
		self.isGrappling = false
		Grappled = nil
	elseif button == "l" then
		self.isGrabbing = false
	end
end

function player:Grapple(Object)
	local entity = Object.fixture:getUserData()
	if entity and entity.type == "mine" then
		local delta = Vector(0,0)
		
		delta.x = entity.x - self.x
		delta.y = entity.y - self.y
		delta:normalized()
		self.body:applyForce(delta.x*(1.2+delta:len()/2048), delta.y*(1.2+delta:len()/2048))
	else
		self.isGrappling = false
	end
end

function player:Shoot(angle) 
	local delta = Vector(0, 0)
	local ox, oy = 50*math.cos(angle)+self.x, 50*math.sin(angle)+self.y
	local projectile = Entities.Spawn("mine", ox, oy)
	projectile.isGrabbed = false
	projectile.isGrabbable = false
	projectile.isGrappleAble = true
	projectile.Mode = self.shootingMode
	projectile.Owner = self
	
	if projectile.Mode == "RED" then
		projectile.Charge = 60
		Timer.add(3, function() projectile.Charge = projectile.Charge - 1 end)
	else
		projectile.Charge = 20
	end
	
	delta.x = ox - self.x
	delta.y = oy - self.y
	delta:normalized()
	projectile.body:applyLinearImpulse(delta.x*2, delta.y*2)
	
	self.isHolding = false
	self.canShoot = false
	self.canGrab = false
	
	
	Timer.add(1, function() self.canGrab = true end)
	Timer.add(0.3, function() projectile.isGrabbable = true end)
	if self.shootingMode == "BLUE" then
		self.canChangeMode = false
		Timer.add(10, function() projectile.Mode, projectile.Charge = "NEUTRAL", 0 end)
		Timer.add(5, function() self.canChangeMode = true end)
	end
	
	return projectile
end

function player:Grab(Object)
	local entity = Object.fixture:getUserData()
	if entity and entity.type == "mine" then
		self.shootingMode = "RED"
		self.isGrappling = false
		self.isHolding = true
		self.canGrab = false
		
		Grappled = nil
		
		self.canShoot = false
		Timer.add(0.75, function() self.canShoot = true end)
		return Entities.Destroy(entity.id)
	end
end

return player