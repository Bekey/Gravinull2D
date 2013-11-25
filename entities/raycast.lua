local raycast = {}
local GrappleRay = {
	x1 = 0,
	y1 = 0,
	x2 = 0,
	y2 = 0,
	hitList = {},
	inSight = {}
}

function raycast:ShootRaycast(px, py, distance)
	self.px = px
	self.py = py
	self.distance = distance
	GrappleRay.hitList = {}
	GrappleRay.inSight = {}


	for i = 1, 7 do
		local mx, my = cam:mousepos()
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


return raycast