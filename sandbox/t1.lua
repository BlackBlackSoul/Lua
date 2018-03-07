function load()
    world = love.physics.newWorld(2000, 2000)
    world:setGravity(0, 50)
    ground = love.physics.newBody(world, 0, 0, 0)
 
    ground_shape = love.physics.newRectangleShape(ground, 400, 500, 600, 10)
    ground_shape:setData("Ground")
 
    body = love.physics.newBody(world, 400, 450)
    hector = love.physics.newRectangleShape(body, 0, 20, 40, 40)
    hector:setRestitution(0.3)
    hector:setData("Hector")
   
    body:setMassFromShapes()
   
    world:setCallback(hit_ground)
 
  lg = love.graphics
  hecty = lg.newColor(126,186,103)
  white = lg.newColor(0xFF, 0xFF, 0xFF)
  black = lg.newColor(0, 0, 0)
 
  --foomp = love.audio.newSound("foomp.ogg")
end
 
function update(dt)
    world:update(dt)
end
 
function draw()
    lg.setBackgroundColor(white)
  lg.setColor(black)   
    lg.polygon(love.draw_line, ground_shape:getPoints())
 
  lg.setColor(hecty)   
    lg.rectangle(love.draw_fill, body:getX(), body:getY(), 40, 40)
  lg.setColor(black)   
    lg.rectangle(love.draw_line, body:getX(), body:getY(), 40, 40)
end
 
directions = {
  [love.key_up] = {0, -200000},
  [love.key_left] = {-100000, 0},
  [love.key_right] = {100000, 0}
}
 
function move(x, y)
  if in_air then
    y = 0
  end
 
  if not in_air then
    x = 0
    if not (y == 0) then in_air = true end
  end
 
  body:applyImpulse(x, y)
end
 
in_air = false
function keypressed(k)
  local d = directions[k]
 
  if d then move(d[1], d[2])    end
end
 
function hit_ground(a, b, c)
  local a_ground = a == "Ground"
  local b_ground = b == "Ground"
 
  if not(a_ground or b_ground) then return end
  if not(b_ground) then return hit_ground(b, a) end
  if a_ground then return end
 
  -- Now ensured that a is not ground and b is.
 
  in_air = false
  if not love.audio.isPlaying() then
--    love.audio.play(foomp)
  end
end