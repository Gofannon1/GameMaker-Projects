// Movement variables (following The Wizard conventions)
move_speed = 4;
jump_height = -15;
gravity_force = 0.5;

// Input variables
right_key = false;
left_key = false;
jump_key = false;
crouch_key = false;

// Speed tracking
h_speed = 0;
v_speed = 0;

// State tracking
is_on_ground = false;
facing_direction = 1; // 1 = right, -1 = left

// Double jump system
jumps_done = 0;
max_jumps = 2; // Allow double jump
can_double_jump = false;

// Crouch system
is_crouching = false;
stand_sprite = spr_player;
crouch_sprite = spr_player_crouch;

// Tilemap reference
ground_layer = layer_tilemap_get_id("Ground");