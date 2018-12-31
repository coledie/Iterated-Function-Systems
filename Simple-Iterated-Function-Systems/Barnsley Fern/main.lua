-- Barnsley Fern demo
-- https://github.com/colesteroni
-- Simple iterated function system illustrator showing a barnsley fern.
-- May edit the function parameters @ bottom of love.load() to get new ferns
-- https://en.wikipedia.org/wiki/Barnsley_fern


function love.load()
   --------------------------------------------------
   -- On game load
   --------------------------------------------------

   -- Settings
   -- Look settings
   dot_size = 1  -- Size of dots plotted
  
   dot_color = {34/255, 139/255, 34/255}  -- r, g, b, opacity
   love.graphics.setBackgroundColor(1, 1, 1)
   
   -- Update delay settings
   delay = false  -- To use or not to use the delay
   delay_length = .1  -- Time inbetween updates(s)
	
   -- Render settings
   -- plotted coords = (zoom * actual coords) + offset	
   zoom = {40, -40} 
   
   origin_offset = {400, 500}  -- Where origin goes in coords
   
   local origin = {0, 0}  -- Initial point
   
   -- inits
   love.window.setTitle("Iterated Function System - Barnsley Fern")
   love.window.setIcon(love.image.newImageData("img/icon.jpg"))
   
   dots = {origin}  -- Dots generated

   last_time = love.timer.getTime()
   
   -- Custom load functionality
   math.randomseed(os.time())  -- RNG seed
   
   -- Probability of each function being used (default = last function)
   -- If referencing a table this is the p value, usually the last column
   probabilities = {.01, .85, .07, .07}
   
   -- Matrix for function coefficients {a,b,c,d,e,f}
   -- x = ax + by + e
   -- y = cx + dy + f
   coefficients = {  
      {0, 0, 0, .16, 0, 0},
      {.85, .04, -.04, .85, 0, 1.6},
	  {.2, -.26, .23, .22, 0, 1.6},
      {-.15, .28, .26, .24, 0, .44}
   }
   
   -- Find more @ http://www.home.aone.net.au/~byzantium/ferns/fractal.html
end


function get_next_dot()
   --------------------------------------------------
   -- Generates new dot
   --------------------------------------------------
   local prev_dot = dots[#dots]  -- Last point generated
   local value = {}  -- {x, y}
   
   -- barnsley fern --
   
   -- Choose rule
   local choice = math.random()  -- Number 0-1
   
   -- Get rule coefficients
   local coeff, accum = coefficients[#coefficients], 0
   
   for i, probability in ipairs(probabilities) do
      accum = accum + probability
	  
	  if choice <= accum then
	     coeff = coefficients[i]
		 break
	  end
   end
   
   -- Execute
   local a,b,c,d,e,f = unpack(coeff)
   local old_x, old_y = unpack(prev_dot)
   
   value = {(a * old_x) + (b * old_y) + e, (c * old_x) + (d * old_y) + f}
   
   -- end barnsley fern --
   
   dots[#dots+1] = value
end


function love.update()
   --------------------------------------------------
   -- Generate next dot
   --------------------------------------------------
   
   if not paused and (not delay or love.timer.getTime() - last_time > delay_length) then
	  get_next_dot()  -- Generate new dot
      
	  last_time = love.timer.getTime()  -- Log time for delay checking
   end
end


function love.draw()
   --------------------------------------------------
   -- Draw all dots
   --------------------------------------------------
   
   love.graphics.setColor(dot_color)  -- Set color to draw
   
   -- Draw all dots
   for i, loc in ipairs(dots) do
      love.graphics.circle("fill", loc[1] * zoom[1] + origin_offset[1], loc[2] * zoom[2] + origin_offset[2], dot_size)
   end
end
   

function love.keypressed(key)
   --------------------------------------------------
   -- On key press
   -- @param {character} key Keyboard key pressed
   --------------------------------------------------
   
   -- Toggle pause
   if key == 'space' or key == 'p' then
      paused = not paused
	  print(paused and "Paused" or "Unpaused")
   end
   
   -- Step forward
   if key == 'right' or key == 'd' then
      get_next_dot()
   end
   
   -- Step backward
   if key == 'left' or key == 'a' then
      table.remove(dots, #dots)
   end
end
