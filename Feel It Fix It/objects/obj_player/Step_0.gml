// WASD Movement Input
var move_left = keyboard_check(ord("A"));
var move_right = keyboard_check(ord("D"));
var jump_pressed = keyboard_check_pressed(ord("W"));
var drop_pressed = keyboard_check(ord("S"));

// Horizontal Movement (A/D keys)
var horizontal_input = move_right - move_left;
hspeed = horizontal_input * move_speed;

// Horizontal Collision - prevent moving into sides of platforms and ground
if (hspeed != 0) {
    // Use array-based collision checking for better performance
    if (place_meeting(x + hspeed, y, [obj_ground, obj_platform])) {
        while (!place_meeting(x + sign(hspeed), y, [obj_ground, obj_platform])) {
            x += sign(hspeed);
        }
        hspeed = 0;
    }
}

// Ground Detection - check both ground and platforms
var on_solid_ground = place_meeting(x, y + 1, obj_ground);

// More precise platform detection - only count as "on platform" if standing on top
var on_platform = false;
if (place_meeting(x, y + 1, obj_platform)) {
    var platform_inst = instance_place(x, y + 1, obj_platform);
    if (platform_inst != noone) {
        // Use bbox_bottom for more accurate player bottom detection
        var player_bottom = bbox_bottom;
        var platform_top = platform_inst.y;
        if (player_bottom <= platform_top + 2) { // Small tolerance for standing on top
            on_platform = true;
        }
    }
}

on_ground = on_solid_ground || on_platform;

// Jumping (W key) - now with double jump
if (jump_pressed) {
    if (on_ground) {
        // First jump
        vspeed = jump_speed;
        on_ground = false;
        can_double_jump = true; // Enable double jump
    } else if (can_double_jump) {
        // Double jump
        vspeed = double_jump_speed;
        can_double_jump = false; // Use up the double jump
    }
}

// Drop Through Platforms (S key) - only works on platforms, not solid ground
// Also only works when actually standing on platform (not jumping through)
if (drop_pressed && on_platform && !on_solid_ground && vspeed >= 0) {
    can_drop_through = true;
    drop_timer = 10; // Frames to ignore platform collision
    y += 2; // Move down slightly to pass through platform
    on_ground = false;
}

// Handle drop timer
if (drop_timer > 0) {
    drop_timer--;
    if (drop_timer <= 0) {
        can_drop_through = false;
    }
}

// Apply Gravity
if (!on_ground) {
    vspeed += gravity_force;
    if (vspeed > max_fall_speed) {
        vspeed = max_fall_speed;
    }
}

// Vertical Collision (Landing)
if (vspeed > 0) {
    // Check if player's bottom will hit top of ground/platform
    var will_hit_ground = false;
    var will_hit_platform = false;
    
    // Check collision with ground (always solid - simple collision)
    if (place_meeting(x, y + vspeed, obj_ground)) {
        will_hit_ground = true;
    }
    
    // Check collision with platforms (only if not dropping through)
    if (!can_drop_through && place_meeting(x, y + vspeed, obj_platform)) {
        var platform_inst = instance_place(x, y + vspeed, obj_platform);
        if (platform_inst != noone) {
            // Only land if player is falling downward and will cross the platform's top surface
            var player_bottom_current = bbox_bottom;
            var player_bottom_next = bbox_bottom + vspeed;
            var platform_top = platform_inst.y;
            
            // Land if: currently above platform top AND next frame will be at or below platform top
            if (player_bottom_current < platform_top && player_bottom_next >= platform_top) {
                will_hit_platform = true;
            }
        }
    }
    
    if (will_hit_ground || will_hit_platform) {
        // Land precisely on top of the surface
        if (will_hit_ground) {
            // Simple ground landing - find the ground instance and position on top
            var ground_inst = instance_place(x, y + vspeed, obj_ground);
            y = ground_inst.y - sprite_height;
        } else {
            // Platform landing - precise positioning using bbox
            var platform_inst = instance_place(x, y + vspeed, obj_platform);
            y = platform_inst.y - sprite_height;
        }
        vspeed = 0;
        on_ground = true;
        can_double_jump = false; // Reset double jump when landing
    }
}

// Apply Movement
x += hspeed;
y += vspeed;

// Keep player in room bounds
if (x < 0) x = 0;
if (x > room_width) x = room_width;
if (y > room_height + 100) {
    x = room_width / 2;
    y = 100;
    vspeed = 0;
}
