
// WASD Movement
// Get input using WASD keys
right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
down_key = keyboard_check(ord("S"));
up_key = keyboard_check(ord("W"));

// Attack input (Space key)
attack_key = keyboard_check_pressed(vk_space);

// Reload input (R key)
reload_key = keyboard_check_pressed(ord("R"));

// Reload logic
if (reload_key && !is_reloading && !is_attacking && current_ammo < max_ammo) {
    is_reloading = true;
    reload_timer = reload_duration;
}

// Handle reload timer
if (is_reloading) {
    reload_timer--;
    if (reload_timer <= 0) {
        is_reloading = false;
        current_ammo = max_ammo; // Refill ammo
    }
}

// Attack logic - only if we have ammo and not reloading
if (attack_key && !is_attacking && !is_reloading && current_ammo > 0) {
    is_attacking = true;
    attack_timer = attack_duration;
    current_ammo--; // Consume ammo
    sprite_index = spr_wizard_attack1; // Set attack sprite
    image_index = 0; // Restart animation from frame 0
}

// Handle attack timer
if (is_attacking) {
    attack_timer--;
    if (attack_timer <= 0) {
        is_attacking = false;
    }
}

h_input = right_key - left_key;
v_input = down_key - up_key;

// Don't move while attacking or reloading
if (!is_attacking && !is_reloading) {
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
}

// Update facing direction based on horizontal input
if (h_input > 0) {
    facing_direction = 1; // Facing right
} else if (h_input < 0) {
    facing_direction = -1; // Facing left
}

// Change sprite based on state
if (is_attacking) {
    // Attacking - sprite already set when attack started, just handle flipping
    image_xscale = facing_direction; // Flip attack sprite to match facing direction
} else if (h_input != 0 || v_input != 0) {
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
