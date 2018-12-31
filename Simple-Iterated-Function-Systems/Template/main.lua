-- Simple Iterated Function System Illustrator
-- https://github.com/colesteroni
-- A template for a LOVE implementation of a simple iterated function system illustrator.


function love.load()
   --------------------------------------------------
   -- On game load
   --------------------------------------------------

   -- Settings
   -- Look settings
   dot_size = 3  -- Size of dots plotted
  
   dot_color = {0, 0, 0}  -- r, g, b, opacity
   love.graphics.setBackgroundColor(1, 1, 1)
   
   -- Update delay settings
   delay = false  -- To use or not to use the delay
   delay_length = .1  -- Time inbetween updates(seconds)
	
   -- Render settings
   -- plotted coords = (zoom * actual coords) + offset	
   zoom = {1, 1} 
   
   origin_offset = {400, 300}  -- Where origin goes in coords
   
   local origin = {0, 0}  -- Initial point
   
   -- inits
   love.window.setTitle("Iterated Function System")
   love.window.setIcon(love.image.newImageData("img/icon.jpg"))
   
   dots = {origin}  -- Dots generated

   last_time = love.timer.getTime()
   
   -- Custom load functionality
   
end


function get_next_dot()
   --------------------------------------------------
   -- Generates new dot
   --------------------------------------------------
   local prev_dot = dots[#dots]  -- Last point generated
   local value = {}  -- {x, y}
   
   -- Functionality goes here --
   
   dots[#dots+1] = value  
end


function love.update()
   --------------------------------------------------
   -- Generate next dot
   --------------------------------------------------
   
   if not paused and (not delay or love.timer.getTime() - last_time > delay_length) then
	  dots[#dots+1] = get_next_dot()  -- Generate new dot
      
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
