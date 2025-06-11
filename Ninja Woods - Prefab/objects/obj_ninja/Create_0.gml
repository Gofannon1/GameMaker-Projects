// Ninja movement variables
move_speed = 4;
jump_speed = -15; // Increased jump power
gravity_force = 0.8; // Increased gravity for more responsive feel
max_fall_speed = 10;

// Movement state
hspeed = 0;
vspeed = 0;
on_ground = false; // Let ninja fall to ground naturally
facing_right = true;

// State variables
is_hurt = false;
hurt_timer = 0;
hurt_duration = 30; // frames

// Jump buffer
jump_buffer = 0;
jump_buffer_time = 8;

// Walking dust particle system
walk_dust_timer = 0;
walk_dust_interval = 8; // frames between walking dust particles