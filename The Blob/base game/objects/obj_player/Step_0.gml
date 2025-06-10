var key_right = keyboard_check(ord("D"));
var key_left = keyboard_check(ord("A"));
var key_jump = keyboard_check_pressed(ord("W"));
var key_crouch = keyboard_check(ord("S"));
var key_drop = keyboard_check_pressed(ord("M"));

var move_direction = key_right - key_left;
h_speed = move_direction * move_speed;

v_speed += gravity_force;

if (key_crouch && is_on_ground) {
    if (!is_crouching) {
        var feet_position = y + sprite_height/2;
        
        is_crouching = true;
        sprite_index = crouch_sprite;
        
        y = feet_position - sprite_height/2;
    }
    h_speed = h_speed * 0.5;
} 
else if (is_crouching) {
    var normal_height = sprite_get_height(stand_sprite);
    var feet_position = y + sprite_height/2;
    
    if (!place_meeting(x, feet_position - normal_height, ground_layer)) {
        is_crouching = false;
        sprite_index = stand_sprite;
        
        y = feet_position - normal_height/2;
    }
}

if (key_jump) {
    if (is_on_ground) {
        v_speed = jump_height;
        jumps_done = 1;
        can_double_jump = true;
        is_on_ground = false;
    } 
    else if (can_double_jump && jumps_done < max_jumps) {
        v_speed = jump_height * 0.8;
        jumps_done++;
        can_double_jump = false;
    }
}

if (key_drop && is_on_ground && place_meeting(x, y + 1, platform_layer)) {
    can_pass_through = false;
    drop_cooldown = drop_delay;
    v_speed = 1;
    is_on_ground = false;
}

if (drop_cooldown > 0) {
    drop_cooldown--;
    if (drop_cooldown <= 0) {
        can_pass_through = true;
    }
}

if (place_meeting(x + h_speed, y, ground_layer)) {
    while (!place_meeting(x + sign(h_speed), y, ground_layer)) {
        x += sign(h_speed);
    }
    h_speed = 0;
}

x += h_speed;

if (place_meeting(x, y + v_speed, ground_layer)) {
    while (!place_meeting(x, y + sign(v_speed), ground_layer)) {
        y += sign(v_speed);
    }
    
    if (v_speed > 0) {
        is_on_ground = true;
        jumps_done = 0;
    }
    
    v_speed = 0;
} else {
    is_on_ground = false;
}

if (v_speed > 0 && can_pass_through && !place_meeting(x, y, platform_layer)) {
    if (place_meeting(x, y + v_speed, platform_layer)) {
        while (!place_meeting(x, y + 1, platform_layer)) {
            y += 1;
        }
        
        is_on_ground = true;
        jumps_done = 0;
        v_speed = 0;
    }
}

y += v_speed;

if (h_speed != 0) {
    image_xscale = sign(h_speed);
}