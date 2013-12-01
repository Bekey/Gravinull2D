local Amy = Entities.Derive("base") or {}

function Amy:load()
	self:loadBody()
	self:loadArm()
	self:loadJoint()
	
	if not self.teamColor then self.teamColor = math.random() end
	self.armourPlating = self:colorPlate(self.teamColor, images["amy_plate"])
	
	self.Health = self.Health or 100
	
	self.Score = 0

	self.Grappled = false
	self.Grabbed = false

	self.isGrappling = false
	self.isGrabbing = false
	self.isHolding = false

	self.canGrapple = true
	self.canShoot = true
	
	self.canGrab = true
	self.canChangeMode = true
	self.shootingMode = "RED"
end

function Amy:loadBody()
	self.r_body = 0
	self.w_body = 64
	self.h_body = 25

	self.body = love.physics.newBody(world, self.x,self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w_body, self.h_body)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)
	self.body:setFixedRotation(true)
end
function Amy:loadArm()
	self.r_arm = 0
	self.w_arm = 35
	self.h_arm = 13

	self.player_arm = {}
	self.player_arm.body = love.physics.newBody(world, self.x+5,self.y+13, "dynamic")
	self.player_arm.shape = love.physics.newRectangleShape(self.w_arm, self.h_arm)
	self.player_arm.fixture = love.physics.newFixture(self.player_arm.body, self.player_arm.shape)
end
function Amy:loadJoint()
	self.joint = love.physics.newRevoluteJoint(self.body, self.player_arm.body, self.x-12,self.y+5, false )
	self.joint:enableLimit(true)
	self.joint:setLimits(math.rad(-5), math.rad(180))
end

function Amy:Hurt(Object)
	local score = 0
	if Object.Charge > self.Health then
		score = math.abs(math.floor(self.Health/10)) + 3
	else
		score = math.abs(math.floor(Object.Charge/10))
	end
	self.Health = self.Health - Object.Charge
	Object.Owner.Score = Object.Owner.Score + score
	
	if self.Health <= 0 then
		
	end
end

function Amy:InsideCone(x1, y1, x2, y2, x3, y3, type)
	local ENTITY_TYPE = type or "mine" 
	local hits = {}
	local anyHits = nil
	local ux, uy = x1, y1
	local lx, ly = x1, y1
	if lx > x2 then lx = x2 end
	if ly > y2 then ly = y2 end
	if ux < x2 then ux = x2 end
	if uy < y2 then uy = y2 end
	if lx > x3 then lx = x3 end
	if ly > y3 then ly = y3 end
	if ux < x3 then ux = x3 end
	if uy < y3 then uy = y3 end
	
	local function dotprod(a, b)
		local ret = 0
		for i = 1, #a do
			ret = ret + a[i] * b[i]
		end
		return ret
	end
	
	for _, entity in pairs(Entities.objects) do
		if entity.type == ENTITY_TYPE then
		if entity.y and entity.x then
			if ((entity.y > uy and entity.y < ly) or (entity.y < uy and entity.y > ly)) then
			if (entity.x > ux and entity.x < lx) or (entity.x > lx and entity.x < ux) then
				local v0, v1, v2 = 	{ x2 - x1, y2 - y1 },
									{ x3 - x1, y3 - y1 },
									{ entity.x - x1, entity.y - y1 }
				local dot00, dot01, dot02, dot11, dot12 =
					dotprod(v0, v0),
					dotprod(v0, v1),
					dotprod(v0, v2),
					dotprod(v1, v1),
					dotprod(v1, v2)
				local invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
				local u, v
				u = (dot11 * dot02 - dot01 * dot12) * invDenom
				v = (dot00 * dot12 - dot01 * dot02) * invDenom
				if (u >= 0) and (v >= 0) and (u + v < 1) then
					table.insert(hits, entity)
					anyHits = true
				end
			end
			end
		end
		end
	end
	if anyHits then
		return hits
	else return nil end
end

function Amy:getViewCone(x, y, distance, spread)
	local MIN_DISTANCE = 5
	local MAX_DISTANCE = distance or 200
	local SPREAD = spread or 10
	
	-- Get the mouse position
	local mx, my = x, y
	
	-- Get the angle from P to Mousepos with 2 offsets
	local angle = math.atan2(my-self.y, mx-self.x)
	local angle1 = angle+math.rad(-SPREAD)
	local angle2 = angle+math.rad(SPREAD)
	
	local x1, y1 = MIN_DISTANCE*math.cos(angle)+self.x, MIN_DISTANCE*math.sin(angle)+self.y
	
	-- Get the coordinates of the two different angled positions
	local x2, y2 = MAX_DISTANCE*math.cos(angle1)+self.x, MAX_DISTANCE*math.sin(angle1)+self.y
	local x3, y3 = MAX_DISTANCE*math.cos(angle2)+self.x, MAX_DISTANCE*math.sin(angle2)+self.y
	
	return x1, y1, x2, y2, x3, y3
end

function Amy:update(dt)
	self.x, self.y = self:getPosition()
	
	if self.isGrappling then
		if self.Grappled then -- Is the player self.Grappled to an entity?
			self:Grapple(self.Grappled)
		end
	elseif self.isHolding then -- Does it need anything here? TODO: YES! aniamtion and shit
	end
	
	if self.Health <= 0 then
	end
end


function Amy:Grapple(Object)
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

function Amy:Shoot(angle) 
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
	self.body:applyLinearImpulse(-delta.x, -delta.y)
	
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

function Amy:Grab(Object)
	local entity = Object.fixture:getUserData()
	if entity and entity.type == "mine" then
		self.shootingMode = "RED"
		self.isGrappling = false
		self.isHolding = true
		self.canGrab = false
		
		self.Grappled = nil
		
		self.canShoot = false
		Timer.add(0.75, function() self.canShoot = true end)
		return Entities.Destroy(entity.id)
	end
end


function Amy:mousepressed(x, y, button)
end

function Amy:draw()
	local body = self.fixture:getBody()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	self.r_body = body:getAngle()


	local player_arm = self.player_arm.fixture:getBody()
	local x, y = player_arm:getPosition( )
	self.r_arm = player_arm:getAngle()

	do
		local quad = self:getBodyPart("amy/amy_joint")
		love.graphics.drawq(images["amy/amy_joint"], quad, math.floor(x1), math.floor(y1), self.r_body,1,1,-18,-14,0,0)
	end
	do
		local x1,y1, x2,y2 = self.player_arm.body:getWorldPoints(self.player_arm.shape:getPoints())
		local quad = self:getBodyPart("amy/amy_arm")
		love.graphics.drawq(images["amy/amy_arm"], quad, math.floor(x1), math.floor(y1), self.r_arm,1,1,0,0,0,0)
	end
	do
		love.graphics.draw(self.armourPlating, math.floor(x1), math.floor(y1), self.r_body,1,1,0,0,0,0)
	end
	do
		local quad = self:getBodyPart("amy/amy_gears")
		love.graphics.drawq(images["amy/amy_gears"], quad, math.floor(x1), math.floor(y1), self.r_body,1,1,0,0,0,0)
	end
	if self.isGrappling and self.Grappled then
		local tx, ty = self.Grappled.fixture:getBody():getPosition()
		love.graphics.line(self:getX()+20, self:getY()+22, tx, ty)
	end
	
	if DEBUG then
		love.graphics.print(self.Health,self.x+35,self.y+10)
		love.graphics.print(self.Score,self.x+35,self.y+25)
		love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
		love.graphics.polygon("line", self.player_arm.body:getWorldPoints(self.player_arm.shape:getPoints()))
		local x, y = cam:mousepos()
		local x1, y1, x2, y2, x3, y3 = self:getViewCone(x, y, 1024, 5)
		love.graphics.polygon("line", x1, y1, x2, y2, x3, y3 )
	end
end

function Amy:getBodyPart(string)
	local quad = love.graphics.newQuad(0, 0, images[string]:getWidth(), images[string]:getHeight(), images[string]:getWidth(), images[string]:getHeight())
	return quad
end

function Amy:colorPlate(T_Color, source)
	local function RGB(r, g, b, a)
		local var_R, var_G, var_B = r/255, g/255, b/255
		local var_Min, var_Max = math.min(var_R, var_G, var_B), math.max(var_R, var_G, var_B)
		local del_Max = var_Max - var_Min
		
		local l, h, s = ( var_Max + var_Min ) / 2,  0, 0
		if del_Max ~= 0 then
			if l < 0.5 then s = del_Max / ( var_Max + var_Min )
			else s = del_Max / ( 2 - var_Max - var_Min ) end
			local del_R, del_G, del_B
			del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
			del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
	    	del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max
			if var_R == var_Max then h = del_B - del_G
			elseif var_G == var_Max then h = ( 1 / 3 ) + del_R - del_B
			elseif  var_B == var_Max then h = ( 2 / 3 ) + del_G - del_R end
			if h < 0 then
				h = h + 1
			end
			if h > 1.0 then
				h = h - 1
			end
		end
		return h, s, l, a
	end
	local function Hue_2_RGB( v1, v2, vH )
	   if vH < 0 then vH = vH+1 end
	   if vH > 1 then vH = vH-1 end
	   if ( 6 * vH ) < 1 then return ( v1 + ( v2 - v1 ) * 6 * vH ) end
	   if ( 2 * vH ) < 1 then return ( v2 ) end
	   if ( 3 * vH ) < 2 then return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 ) end
	   return v1
	end
	local function HLS(h, s, l, a)
	    if s<= 0 then return l*255,l*255,l*255,a
	    
	    else
	    	local var_2, var_1, r, g, b
	    	if ( l < 0.5 ) then
	    		var_2 = l * ( 1 + s )
	    	else
	    		var_2 = ( l + s ) - ( s * l )
	    	end
	    	
	    	var_1 = 2 * l - var_2
			r = 255 * Hue_2_RGB( var_1, var_2, h + ( 1 / 3 ) )
			g = 255 * Hue_2_RGB( var_1, var_2, h )
			b = 255 * Hue_2_RGB( var_1, var_2, h - ( 1 / 3 ) )
		
			return r, g, b, a
		end	
	end
	
	local function hueShift(x, y, r, g, b, a)
		local H, L, S, A = RGB(r, g, b, a)
		
		H = T_Color + H
		
		local R, G, B, A = HLS(H, L, S, A)
		
		return R, G, B, A 
	end
	
	source:mapPixel(hueShift)
	return love.graphics.newImage(source)
end

function Amy:getPosition()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	return (x1+(x2-x1)/2), (y1+(y2-y1)/2)
end

function Amy:getX()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	return (x1+(x2-x1)/2)
end

function Amy:getY()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	return (y1+(y2-y1)/2)
end

function Amy:getPlayer()
	return Amy
end

return Amy;