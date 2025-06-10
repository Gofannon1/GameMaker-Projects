
// WASD Movement
// Get input using WASD keys
right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
down_key = keyboard_check(ord("S"));
up_key = keyboard_check(ord("W"));

h_input = right_key - left_key;
v_input = down_key - up_key;

// Update facing direction based on horizontal input
if (h_input > 0) {
    facing_direction = 1; // Facing right
} else if (h_input < 0) {
    facing_direction = -1; // Facing left
}

// Normalize diagonal movement
if (h_input != 0 && v_input != 0) {
    h_input *= 0.7071;
    v_input *= 0.7071;
}

// Apply movement
x += h_input * move_speed;
y += v_input * move_speed;

// Keep player within room boundaries
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

// Change sprite based on movement direction
if (h_input != 0 || v_input != 0) {
    // Moving - choose sprite based on direction
    if (v_input > 0) {
        // Moving down
        sprite_index = spr_wizard_down;
        image_xscale = 1; // Don't flip up/down sprites
    } else if (v_input < 0) {
        // Moving up
        sprite_index = spr_wizard_up;
        image_xscale = 1; // Don't flip up/down sprites
    } else {
        // Moving horizontally - use walking sprite
        sprite_index = spr_wizard_walking;
        image_xscale = facing_direction; // Flip to match direction
    }
} else {
    // Not moving - use idle sprite
    sprite_index = spr_wizard_idle;
    image_xscale = facing_direction; // Flip idle sprite to match facing direction
}
