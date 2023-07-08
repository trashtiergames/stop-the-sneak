playstate = class()

function playstate:init()
  points = 0
  sunny = false
  player = player()
  sneaky = sneaky()
end

function playstate:update()
  if (btnp(5)) sunny = true debug = "btn 5 pressed"
  sneaky:update()
  player:update()
  update_light(player.direction)
  check_for_sneaky()
end

function playstate:draw()
  -- clear screen
	cls()
  palette_swap_table = {
    [1] = 5,
    [2] = 4,
    [3] = 11,
    [9] = 10,
    [13] = 6,
    [14] = 7
  }
  map(0, 0, 0, 0)
	player:draw()
  clip(
    player.light.x, 
    player.light.y, 
    player.light.w, 
    player.light.h
  )
  if sunny then
    pal(palette_swap_table)
    -- pal(5, 6)
    -- -- palt(0, false)
    -- pal(0, 5)
    map(0, 0, 0, 0)
  end
  -- sneaky:draw()
  pal()
  clip()
  sneaky:draw()
  print(debug, 0, 100)
  print("points: " .. points)
end