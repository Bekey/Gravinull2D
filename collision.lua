local collision = {}

function collision.beginContact(a, b, coll)
	local A, B = a:getUserData(), b:getUserData()
	if A and B then -- Ugly array of if statements.
		--	AMY - MINE
		--======================================================================
		if ((A.type == "mine" and A.Mode ~= "NEUTRAL") and (B.type == "amy" or B.type == "player")) or 
		((A.type == "amy" or A.type == "player") and (B.type == "mine" and B.Mode ~= "NEUTRAL")) then
		--======================================================================		
			local dx, dy = coll:getNormal()	
			local x1, y1 = coll:getPositions( )
			A.body:applyLinearImpulse(-dx * 1.5, -dy * 1.5, x1, y1)
			B.body:applyLinearImpulse( dx * 1.5,  dy * 1.5, x1, y1)
			if  (A.type == "mine") then
				if B.Hurt then B:Hurt(A) end
			elseif (B.type == "mine") then
				if A.Hurt then A:Hurt(B) end
			end
		end
		
		--
		
    end
end

function collision.endContact(a, b, coll)
end

function collision.preSolve(a, b, coll)
end

function collision.postSolve(a, b, coll)
end

return collision