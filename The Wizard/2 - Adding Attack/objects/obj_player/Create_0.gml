// Initialize player variables
move_speed = 1;

// Input variables
right_key = false;
left_key = false;
down_key = false;
up_key = false;
h_input = 0;
v_input = 0;

// Attack variables
attack_key = false;
is_attacking = false;
attack_timer = 0;
attack_duration = 55; // frames for attack animation (11 frames at 12fps = 55 game frames at 60fps)

// Direction facing (for sprite flipping)
facing_direction = 1; // 1 = right, -1 = left