move_speed = 4;      
jump_height = -15;    
gravity_force = 0.5;  

h_speed = 0;
v_speed = 0;

is_on_ground = false;
can_double_jump = false;
jumps_done = 0;
max_jumps = 2;

is_crouching = false;
stand_sprite = sprite_index;
crouch_sprite = spr_player_crouch;

can_pass_through = true;
drop_cooldown = 0;
drop_delay = 15;

ground_layer = layer_tilemap_get_id("Ground");
platform_layer = layer_tilemap_get_id("Platforms");