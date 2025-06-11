// Input handling (following The Wizard conventions)
right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
jump_key = keyboard_check_pressed(ord("W"));

// Update facing direction
if (right_key) facing_direction = 1;
if (left_key) facing_direction = -1;

// Horizontal movement
h_speed = (right_key - left_key) * move_speed;

// Apply gravity
v_speed += gravity_force;

// Reset ground state when moving upward (jumping/falling up)
if (v_speed < 0) {
    is_on_ground = false;
}

// Jump when on ground
if (jump_key && is_on_ground) {
    v_speed = jump_height;
    is_on_ground = false; // Immediately set to false when jumping
}

// Horizontal collision
if (place_meeting(x + h_speed, y, ground_layer)) {
    while (!place_meeting(x + sign(h_speed), y, ground_layer)) {
        x += sign(h_speed);
    }
    h_speed = 0;
}
x += h_speed;

// Vertical collision
if (place_meeting(x, y + v_speed, ground_layer)) {
    while (!place_meeting(x, y + sign(v_speed), ground_layer)) {
        y += sign(v_speed);
    }
    
    if (v_speed > 0) {
        is_on_ground = true;
    }
    
    v_speed = 0;
} else {
    is_on_ground = false;
}
y += v_speed;

// Keep player within horizontal room boundaries
x = clamp(x, 0, room_width);

// Sprite flipping (following The Wizard conventions)
image_xscale = facing_direction;