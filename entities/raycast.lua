local raycast = {}
local GrappleRay = {
	x1 = 0,
	y1 = 0,
	x2 = 0,
	y2 = 0,
	hitList = {},
	inSight = {}
}

function raycast:ShootRaycast(px, py, distance, spread)
	self.px = px
	self.py = py
	self.distance = distance
	self.spread = spread or 4
	
	GrappleRay.hitList = {}
	GrappleRay.inSight = {}
	
	-- Get the mouse position
	local mx, my = cam:mousepos()
	-- Get the angle from P to Mousepos with 2 offsets
	local angle1 = math.atan2(my-self.py, mx-self.px)+math.rad(-self.spread)
	local angle2 = math.atan2(my-self.py, mx-self.px)+math.rad(self.spread)
	-- Get the coordinates of the two different angled positions
	local ax, ay = self.distance*math.cos(angle1)+self.px, self.distance*math.sin(angle1)+self.py
	local bx, by = self.distance*math.cos(angle2)+self.px, self.distance*math.sin(angle2)+self.py
	-- Make a cone shape
	local tearDrop = Collider:addPolygon(	10+self.px, 10+self.py,
											ax, ay,
											bx, by)
	-- Iterate through all shapes inside the cone's bbox.
	for shape in pairs(Collider:shapesInRange(tearDrop:bbox())) do
		if shape ~= tearDrop then
			-- if shape's also colliding with tear drop
			if shape:collidesWith(tearDrop) then
				local entity = shape:getUserData()
				if entity then
					if entity.type == "mine" then
						-- and finally if it's a mine, put it in the hitlist
						table.insert(GrappleRay.hitList, entity) -- TODO: Add distance, angle offset and sort
					end
				end
			end
		end
	end
	--Clean up the mess
	Collider:remove(tearDrop)
	return GrappleRay.hitList[1]
end --[[
	
	for i = 1, 7 do
		local angle = math.atan2(my-self.py, mx-self.px)+math.rad(-4+i*1) -- -2 -1 0 +1 +2

		GrappleRay.x1, GrappleRay.y1 = self.px, self.py
		GrappleRay.x2, GrappleRay.y2 = self.distance*math.cos(angle)+self.px, self.distance*math.sin(angle)+self.py

		world:rayCast(GrappleRay.x1, GrappleRay.y1, GrappleRay.x2, GrappleRay.y2, Raycast)

		table.sort(GrappleRay.hitList, function(a, b) return a.distance < b.distance end)

		for i = #GrappleRay.hitList, 1, -1 do
			local hit = GrappleRay.hitList[i]
			local body = hit.fixture:getBody()

			if body:getType() == "static" then
				GrappleRay.inSight = {}
			else
				local entity = hit.fixture:getUserData()
				if entity and entity.type == "mine" then
					table.insert(GrappleRay.inSight, hit)
				end
			end
		end
	end
	table.sort(GrappleRay.inSight, function(a, b) return a.distance < b.distance end)
	function Raycast(fixture, x, y, xn, yn, fraction)
		local hit = {}
		hit.fixture = fixture
		hit.x, hit.y = x, y
		hit.xn, hit.yn = xn, yn
		hit.fraction = fraction
		hit.distance = math.sqrt((hit.x-self.px)*(hit.x-self.px)+(hit.y-self.py)*(hit.y-self.py))
		local body = hit.fixture:getBody()

		table.insert(GrappleRay.hitList, hit)

		return 1
	end
	
	return GrappleRay.inSight[1]
end
]]
return raycast