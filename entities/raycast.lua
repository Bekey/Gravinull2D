local raycast = {}

function raycast:ShootRaycast(x, y, hitList)
	self.x = x
	self.y = y
	self.inSight = {}
	local function getNearest(a, b)
		local x, y = self.x, self.y
		local dist1, dist2 =
			math.sqrt((a.x-x)*(a.x-x)+(a.y-y)*(a.y-y)),
			math.sqrt((b.x-x)*(b.x-x)+(b.y-y)*(b.y-y))
		return dist1 < dist2
	end
	
	for _, v in pairs(hitList) do
		local function Raycast(fixture, x, y, xn, yn, fraction)
			local entity = fixture:getUserData()
			if entity == "wall" then
				self.inSight = {}
				return 0
			end
			table.insert(self.inSight, v)
			return 1
		end
		world:rayCast(self.x, self.y, v.x, v.y, Raycast)
	end
	table.sort(self.inSight, getNearest)
	return self.inSight[1]
end

return raycast