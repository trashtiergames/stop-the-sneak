function _init()
  wall = 0
  debug = "nothing to debug"

  player = {
    -- grid x and y
    gx = 4,
    gy = 5,
    x = 32,
    y = 40,
    sprite = 64,
    direction = "up"
  }

  sneaky = {
    gx = 0,
    gy = 0,
    x = 0,
    y = 0,
    w = 8,
    h = 8,
    sprite = 65,
    state = "sneaking",
    step = 1,
    step_timer = 0,
    step_timer_max = 1,
    path = {
      {0, 0},
      {1, 0},
      {2, 0},
      {3, 0},
      {4, 0},
      {4, 1},
      {4, 2},
      {4, 3},
      {5, 3},
      {6, 3},
      {6, 4},
      {6, 5},
      {7, 5},
      {7, 6},
      {7, 7}
    },
  }

  player.light = {}
end

function _update60()
  move_sneaky()
  move_player()
  update_light(player.direction)
  check_for_sneaky()
end

function _draw()
	-- clear screen
	cls()
  map(0, 0, 0, 0)
	draw_player()
  clip(
    player.light.x, 
    player.light.y, 
    player.light.w, 
    player.light.h
  )
  draw_sneaky()
  clip()
  print(debug, 0, 100)
end

function draw_player()
  spr(
    player.sprite,
    player.x,
    player.y
  )
  rect(
    player.light.x,
    player.light.y,
    player.light.x + player.light.w,
    player.light.y + player.light.h,
    10
  )
end

function draw_sneaky()
  spr(
    sneaky.sprite,
    sneaky.x,
    sneaky.y
  )
end

function move_player()
	new_x = player.gx
	new_y = player.gy
	
	if (btnp(0)) new_x -= 1 player.direction = "left"
	if (btnp(1)) new_x += 1 player.direction = "right"
	if (btnp(2)) new_y -= 1 player.direction = "up"
	if (btnp(3)) new_y += 1 player.direction = "down"
	
	if can_move(new_x,new_y) then
		player.gx = mid(0,new_x,7)
		player.gy = mid(0,new_y,7)
	else
		-- sfx(0)
	end 
  player.x = player.gx * 8
  player.y = player.gy * 8
  print(player.direction)
end

function move_sneaky()
  sneaky.step_timer += 1/60
  if sneaky.step_timer > sneaky.step_timer_max then
    sneaky.step_timer = 0
    sneaky.step += 1
    local coords = sneaky.path[sneaky.step]
    sneaky.gx, sneaky.gy = coords[1], coords[2]
    sneaky.x = sneaky.gx * 8
    sneaky.y = sneaky.gy * 8
  end
end

function is_tile(tile_type,x,y)
	-- returns true if tile has flag
	-- false otherwise
	tile = mget(x,y)
	has_flag = fget(tile, tile_type)
	return has_flag
end

function can_move(x,y)
	return not is_tile(wall,x,y)
end

function update_light(direction)
  if (player.direction == "left") then
    player.light.x = (player.gx - 1) * 8
    player.light.y = (player.gy - 1) * 8
    player.light.w = 8
    player.light.h = 8 * 3
  elseif (player.direction == "right") then
    player.light.x = (player.gx + 1) * 8
    player.light.y = (player.gy - 1) * 8
    player.light.w = 8
    player.light.h = 8 * 3
  elseif (player.direction == "up") then
    player.light.x = (player.gx - 1) * 8
    player.light.y = (player.gy - 1) * 8
    player.light.w = 8 * 3
    player.light.h = 8
  elseif (player.direction == "down") then
    player.light.x = (player.gx - 1) * 8
    player.light.y = (player.gy + 1) * 8
    player.light.w = 8 * 3
    player.light.h = 8
  end
end

function collides(a, b)
  -- AABB collision detection (a and b need to have x, y, w, h)
  if (a.x < b.x + b.w
      and a.x + a.w > b.x
      and a.y < b.y + b.h
      and a.y + a.h > b.y) then
    return true
  else
    return false
  end
end

function check_for_sneaky()
  if collides(sneaky, player.light) then
    debug = "collision detected"
    sneaky.state = "discovered"
  end
end
