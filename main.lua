-- Chaos Game
-- https://github.com/colesteroni
-- A LOVE implementation of the chaos game ( https://www.youtube.com/watch?v=kbKtFN71Lfs )


function love.load()
   --------------------------------------------------
   -- On game load
   --------------------------------------------------

   -- Settings
   -- Look settings
   dot_size = 3  -- Size of dots plotted
  
   dot_color = {0, 0, 0}
   love.graphics.setBackgroundColor(255, 255, 255)
   
   -- Update delay settings
   delay = true  -- To use or not to use the delay
   delay_length = .25  -- Time inbetween updates(seconds)
   
   -- Pivot point settings - (x, y pairs of the points to go between)
   pivot_points = {{400, 100}, {200, 450}, {600, 450}}  -- Triangle
   -- pivot_points = {{150, 50}, {650, 50}, {150, 550}, {650, 550}}  -- Square 
   -- pivot_points = {{400, 50}, {600, 218}, {200, 218}, {500, 450}, {300, 450}}  -- Pentagon
   
   
   -- Rule settings (0 = default)
   rule_set = {rule_choose_move_towards_selection = 0,
			   rule_choose_position_selection = 1,
			   rule_initial_point_selection = 0
   }
   
   -- Demo pivots and rule sets
   -- Sierpinski triange
   
   -- pivot_points = {{400,100}, {200, 450}, {600, 450}}
   -- rule_set = {rule_choose_move_towards_selection = 0, rule_choose_position_selection = 0, rule_initial_point_selection = 0}
   
   
   -- Snowflake
   
   -- pivot_points = {{150, 50}, {650, 50}, {150, 550}, {650, 550}}
   -- rule_set = {rule_choose_move_towards_selection = 1, rule_choose_position_selection = 0, rule_initial_point_selection = 1}
   
   
   -- inits
   love.window.setTitle("Chaos Game")
   love.window.setIcon(love.image.newImageData("icon.jpg"))
   
   math.randomseed(os.time())
   
   dots = {rule_initial_point()}

   last_time = love.timer.getTime()
end


function rule_choose_move_towards(max_choice)
   --------------------------------------------------
   -- Rule to choose point to move towards
   --------------------------------------------------
   
   local value = 0
   local rule_selection = rule_set['rule_choose_move_towards_selection']
   
   if rule_selection == 1 then
      -- Random except previous
      
	  local nxt = previous
	  
	  while nxt == previous do
	     nxt = math.random(#pivot_points)
	  end
	  
	  previous = nxt
	  value = pivot_points[nxt]
	  
   elseif rule_selection == 2 then
      -- Random except clockwise
	  local nxt = previous
	  
	  while nxt == previous do
	     nxt = math.random(#pivot_points)
	  end
	  
	  previous = (nxt + 1) % #pivot_points + 1
	  value = pivot_points[nxt]
	  
   else
      -- Random pivot point
      value = pivot_points[math.random(#pivot_points)]
   end
   
   return value
end


function rule_choose_position(prev_point, move_toward_point)
   --------------------------------------------------
   -- Rule to set position of next generated point
   --------------------------------------------------
   
   local value = 0
   local rule_selection = rule_set['rule_choose_position_selection']
   
   if rule_selection == 1 then
      -- Third of way between points weighted toward move toward point
	  value = {(prev_point[1] + move_toward_point[1] * 2) / 3, (prev_point[2] + move_toward_point[2] * 2) / 3} 
	  
   elseif rule_selection == 2 then
      -- Quarter of way between points weighted toward move toward point
	  value = {(prev_point[1] + move_toward_point[1] * 3) / 4, (prev_point[2] + move_toward_point[2] * 3) / 4} 
	  
   else
      -- Halfway between points
      value = {(prev_point[1] + move_toward_point[1]) / 2, (prev_point[2] + move_toward_point[2]) / 2}  
   end
   
   return value 
end


function rule_initial_point()
   --------------------------------------------------
   -- Rule for choosing the initial point
   --------------------------------------------------
   
   local value = 0
   local rule_selection = rule_set['rule_initial_point_selection']
   
   if rule_selection == 1 then
      -- Center of pivot points
      value = {0, 0}
	  
	  -- Sum up weighted x's & y's
      for i, v in ipairs(pivot_points) do
         value[1] = value[1] + (v[1] / #pivot_points)  -- Weighted x
		 value[2] = value[2] + (v[2] / #pivot_points)  -- Weighted y
      end 
	  
   elseif rule_selection == 2 then
      -- Random X & Y
	  value = {math.random(800), math.random(600)}
   else
      -- Random pivot point
      value = pivot_points[math.random(#pivot_points)]
   end
   
   return value
end


function get_next_dot()
   --------------------------------------------------
   -- Generates new dot (Careful editing!)
   --------------------------------------------------
   
   local move_towards = rule_choose_move_towards(#pivot_points)  -- Pivot point to move towards
   
   local last_point = dots[#dots]  -- Last point generated
   
   dots[#dots+1] = rule_choose_position(last_point, move_towards)  -- Choose where to place next dot
end


function love.update()
   --------------------------------------------------
   -- Generate next dot (Careful editing!)
   --------------------------------------------------
   
   if not paused and (not delay or love.timer.getTime() - last_time > delay_length) then
	  get_next_dot()
      last_time = love.timer.getTime()
   end
end


function love.draw()
   --------------------------------------------------
   -- Draw all dots (Careful editing!)
   --------------------------------------------------
   
   love.graphics.setColor(dot_color)  -- Set color to draw
   
   -- Draw all dots
   for i, loc in ipairs(dots) do
      love.graphics.circle("fill", loc[1], loc[2], dot_size)
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
