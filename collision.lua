local collision = {}

function collision.beginContact(a, b, coll)
	local A, B = a:getUserData(), b:getUserData()
	if A and B and A ~= "wall" then -- Ugly array of if statements.
		--	AMY - MINE
		--======================================================================
		if A.MODE ~= "NEUTRAL" and (A.type == "redmine" or A.type == "bluemine") and (B.type == "amy" or B.type == "player") then 
			collision.AmyMine(B, A, coll)
		elseif B.MODE ~= "NEUTRAL" and (B.type == "bluemine" or B.type == "redmine") and (A.type == "amy" or A.type == "player") then
			collision.AmyMine(A, B, coll)
		end
		--
    end
end

function collision.AmyMine(amy, mine, coll)	
	local dx, dy = coll:getNormal()	
	local x1, y1 = coll:getPositions( )
	amy.body:applyLinearImpulse(-dx * 1.5, -dy * 1.5, x1, y1)
	mine.body:applyLinearImpulse( dx * 1.5,  dy * 1.5, x1, y1)
	amy:Hurt(mine)
end

function collision.endContact(a, b, coll)
end

function collision.preSolve(a, b, coll)
end

function collision.postSolve(a, b, coll)
end

return collision