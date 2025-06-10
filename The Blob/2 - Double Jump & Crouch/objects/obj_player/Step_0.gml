// Input handling (following The Wizard conventions)
right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
jump_key = keyboard_check_pressed(ord("W"));
crouch_key = keyboard_check(ord("S"));
drop_key = keyboard_check_pressed(ord("M")); // Drop through platforms

// Update facing direction
if (right_key) facing_direction = 1;
if (left_key) facing_direction = -1;

// Horizontal movement
h_speed = (right_key - left_key) * move_speed;

// Crouch system
if (crouch_key && is_on_ground) {
    if (!is_crouching) {
        // Store feet position before changing sprite
        var feet_position = y + sprite_height/2;
        
        is_crouching = true;
        sprite_index = crouch_sprite;
        
        // Adjust position so feet stay at same level
        y = feet_position - sprite_height/2;
    }
    h_speed = h_speed * 0.5; // Slower movement while crouching
} 
else if (is_crouching) {
    // Check if there's room to stand up
    var normal_height = sprite_get_height(stand_sprite);
    var feet_position = y + sprite_height/2;
    
    if (!place_meeting(x, feet_position - normal_height, ground_layer)) {
        is_crouching = false;
        sprite_index = stand_sprite;
        
        // Adjust position so feet stay at same level
        y = feet_position - normal_height/2;
    }
}

// Platform drop-through system
if (drop_key && is_on_ground && place_meeting(x, y + 1, platform_layer)) {
    can_pass_through = false;
    drop_cooldown = drop_delay;
    v_speed = 1; // Small downward velocity to pass through
    is_on_ground = false;
}

// Platform drop cooldown management
if (drop_cooldown > 0) {
    drop_cooldown--;
    if (drop_cooldown <= 0) {
        can_pass_through = true;
    }
}

// Apply gravity
v_speed += gravity_force;

// Reset ground state when moving upward (jumping/falling up)
if (v_speed < 0) {
    is_on_ground = false;
    // Cancel crouch when airborne (simplified - no position adjustment needed)
    if (is_crouching) {
        is_crouching = false;
        sprite_index = stand_sprite;
    }
}

// Jump system (single and double jump)
if (jump_key && !is_crouching) { // Can't jump while crouching
    if (is_on_ground) {
        // First jump from ground
        v_speed = jump_height;
        jumps_done = 1;
        can_double_jump = true;
        is_on_ground = false;
    } 
    else if (can_double_jump && jumps_done < max_jumps) {
        // Double jump in air
        v_speed = jump_height * 0.8; // Slightly weaker second jump
        jumps_done++;
        can_double_jump = false;
    }
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
        jumps_done = 0; // Reset jump counter when landing
    }
    v_speed = 0;
} else {
    is_on_ground = false;
}

// Platform collision (only when falling down and can pass through)
if (v_speed > 0 && can_pass_through && !place_meeting(x, y, platform_layer)) {
    if (place_meeting(x, y + v_speed, platform_layer)) {
        while (!place_meeting(x, y + 1, platform_layer)) {
            y += 1;
        }
        
        is_on_ground = true;
        jumps_done = 0; // Reset jump counter when landing on platform
        v_speed = 0;
    }
}

y += v_speed;

// Keep player within horizontal room boundaries
x = clamp(x, 0, room_width);

// Sprite flipping (following The Wizard conventions)
image_xscale = facing_direction;