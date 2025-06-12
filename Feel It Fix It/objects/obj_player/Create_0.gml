// Player movement variables
move_speed = 4;
jump_speed = -15; // Increased by 25% (was -12, now -15)
double_jump_speed = -10.5; // 70% power of main jump (-15 * 0.7)
gravity_force = 0.8;
max_fall_speed = 10;

// Movement state
hspeed = 0;
vspeed = 0;
on_ground = false;

// Jump state
can_double_jump = false;

// Drop through platforms
can_drop_through = false;
drop_timer = 0;
