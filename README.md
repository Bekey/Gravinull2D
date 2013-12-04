#DEVBLOG!
Following Ducksauce's decision to keep a coder's journal during the 5 week development time of the original Half-Life 2 Source modification, GraviNULL, I decided to do the same. His programming skills greatly exceed mine, and there's not going to be much of interesting thought here, except for a few screenshots maybe, but nevertheless it should be a nice homage to the original master mind of this great game.

###### 30/08/2013 - Day 1
- Decided to use LOVE2D over the HGE engine, simply because LOVE still has a big community and a lot of useful custom libraries that will help me skip most of the technicalities, so that I can focus more on the graphics and gameplay code.
- Started out with following the tutorial section on the Love2D wiki, at the end of all the copy pasting I had a functional camera, simple parallax scrolling and a temporary way to move around the map.
- Decided to make a console, animated the closing/opening animation, but otherwise very primitive: http://i.imgur.com/aQ2No2h.png
- Finally, from the Libraries section on the wiki I grabbed myself LöveFrames and Advanced Tiled  Loader and with the example map from ATL's website I tested it out: http://i.imgur.com/jqWbcw3.png
- Took me all day, yet there was no effort. Next I shall probably create physics and some graphics on my own.

###### 31/08/2013 - Day 2
- Fiddled around with ATL, set the correct drawRange, constricted the camera to not go beyond the map dimensions and ultimately failed at making ATL render void-tiles whenever there's no tile information. Oh well, it's a fancy feature noone will miss (hopefully).
- Used map("layer"):iterate() to cycle through all tiles and find the ones with the property "obstacle", if they had that property, I assigned physics to them. Very inefficient and bare bones, but regardless it's something I came up myself: http://i.imgur.com/S88eU9U.png
- Created my first spritesheet, didn't feel very creative so I decided to invoke some nostalgia and recreate Source Engine dev textures in a 32x32 fashion: http://i.imgur.com/Gtleg9L.png

###### 01/09/2013 - Day 3
- Added extra properties to the tilesheet to create corners and half-blocks. The stair-type of blocks still need a whole seperate algorithm tho, that's for another day: http://i.imgur.com/5UKGrw9.png
- Followed ATL's tutorial to get objects from the map file to the game. It worked until I added physics to the object. I'll need to change my entire method and implement an entity system. Learning mode activated.

###### 02/03/2013 - Day 4
- Copied Goature's entity system from his youtube tutorial. It worked well, until I again.. I added physics. But luckily Razzeeyy from the IRC chat helped me out.

###### 03/09/2013 - Day 5
- Some more minor corrections via Razzeeyy's help. Entity system fully working, even used the system from Day 3 to implement spawning game object via the level editor: http://i.imgur.com/8Bv78hl.png
- HOLY SHIT LOOK AT THESE PHYSICS http://i.imgur.com/ijQprvt.gif
- *"Kawata said: why am i reminded of meatspin when i see that"*
- Created some early mine objects.
- Used world:RayCast to try and find grappleable mines in the aiming direction.

###### 04/09/2013 - Day 6
- Figured out how to trace fixtures from the raycast back to the specific mine. Several bugs however, waiting for help on the forums.
- Created a mine texture: http://i.imgur.com/U974xEv.png
- Danboe my loyal companion enlightened me to sort all hits by the raycast by distance, instead of trying to get it into the right order. There goes an entire day spent fixing an easy problem.
- Copied raycast to it's own file, good practice, all working.
- Added some basic grappling technique. All working. Hallelujah!

###### 05/09/2013 - Day 7
- Personal issues, couldn't do anything but back up the code.

###### 06/09/2013 - Day 8
- Amy now knows how to grab balls and the balls disappear accordingly. (eh, 8 days and the first innuendo slipped through, oh well)
- Amy now knows how to shoot said balls.
- Still a lot of bugs to fix, most of them just require a timer function, however the HUMP timer is severely inaccurate ATM. Will look into it.
- Next shall be different shooting modes, and new raycast method as well as checking if grappled ball is obscured during grappling, instead of just at the start.

###### 07/09/2013 - Day 9
- Added different shooting modes.	
- Experimented a bit with angles: http://i.imgur.com/XxOy3y0.gif

###### 08/09/2013 - Day 10
- Added cooldowns

###### 28/11/2013 - Day ... 60?
Wooah! It's been months!? Well, to be fair I really did stop working on it for a month or two. Lost my focus, had things to sort out. On the flipside however, I did manage to get back into the flow and **completely** rewrite the entire game with some added new features:
- Added base class for effects, see the disappearing ball in action: http://i.imgur.com/GadKChZ.gif
- Worked out how to allow players to choose their own custom color! http://i.imgur.com/TyWXMOf.png
- Pixel'd and added a game main menu: http://i.imgur.com/O3zGuMt.png
- Fixed countless bugs, optimised 90% of the game, dropped some libraries and added new ones.

###### 30/11/2013 - Day 90
- Tested out HardonCollider, it offered some nifty tools for debugging and a VERY nifty raycast method: http://i.imgur.com/55NMwSd.gif
- New Raycast method: Create cone shape, return a table of all shapes inside the bounding box of the cone shape, then test each shape if it's withing the cone shape.
- Sadly HardonCollider on it's own does not offer enough features, returning back to Box2d.

###### 01/12/2013 - Day 91
- Finally I managed to write a clean and (hopefully) optimized raycast method. It works similar to the previous one used in HardonCollider. (*"rewrite entities/raycast.lua (96%)"*)
- I think this is it guys... Time to use LUBE

###### 02/12/2013 - Day 92
- **What's been done so far:** http://i.minus.com/ibbVyAqQFfatSv.gif
- Implemented LUBE for the netcode and gvx's Ser library for serialization. Some basic stuff, but it's going along nicely despite the few hickups I had at the start.
- Server code is at https://github.com/Bekey/GraviNULL2D-Server

###### 04/12/2013 - Day 93
- Still doing net-code. What a challenge.
- Levels are now loaded from the server. Also supports multiple players.
- It took really really long to have a lag-free setup. There's a lot of stuff missing, but at least it's lag free: http://i.imgur.com/rfcKLLI.gif
