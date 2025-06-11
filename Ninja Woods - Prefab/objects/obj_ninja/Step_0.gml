// Handle hurt state
if (is_hurt) {
    hurt_timer--;
    if (hurt_timer <= 0) {
        is_hurt = false;
    }
}

// Input handling (only if not hurt)
if (!is_hurt) {
    var move_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var move_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var jump_pressed = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    
    // Horizontal movement
    var horizontal_input = move_right - move_left;
    hspeed = horizontal_input * move_speed;
    
    // Update facing direction
    if (horizontal_input != 0) {
        facing_right = (horizontal_input > 0);
        image_xscale = facing_right ? 1 : -1;
    }
    
    // Jump buffer
    if (jump_pressed) {
        jump_buffer = jump_buffer_time;
    }
    if (jump_buffer > 0) {
        jump_buffer--;
    }
    
    // Optimized tilemap collision with better performance
    var tilemap = layer_tilemap_get_id("Ground");
    
    // Cache tilemap ID to avoid repeated layer lookups
    if (!variable_instance_exists(id, "cached_tilemap")) {
        cached_tilemap = layer_tilemap_get_id("Ground");
    }
    
    // Use cached tilemap for better performance
    // Check if on ground using tileset collision
    on_ground = tilemap_get_at_pixel(cached_tilemap, x, y + sprite_height/2) > 0;
    
    // Jumping
    if (jump_buffer > 0 && on_ground) {
        vspeed = jump_speed;
        jump_buffer = 0;
        on_ground = false;
        
        // Create dust particle effect at ninja's feet when jumping
        var dust_effect = instance_create_layer(x, y + sprite_height/2, "Instances", obj_dust_particle);
        dust_effect.sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_part_character_jump;
    }
}

// Apply gravity
if (!on_ground) {
    vspeed += gravity_force;
    if (vspeed > max_fall_speed) {
        vspeed = max_fall_speed;
    }
}

// Tileset collision for vertical movement
var tilemap = layer_tilemap_get_id("Ground");

// Check for ground collision below ninja
if (vspeed > 0) { // Falling down
    var ground_y = y + sprite_height/2 + vspeed;
    if (tilemap_get_at_pixel(tilemap, x, ground_y) > 0) {
        // Store the fall speed before landing for dust effect
        var fall_speed = vspeed;
        
        // Land on the tile
        var tile_y = floor(ground_y / 32) * 32;
        y = tile_y - sprite_height/2;
        vspeed = 0;
        on_ground = true;
        
        // Create dust particle effect when landing (if was falling fast enough)
        if (fall_speed > 3) {
            var land_dust = instance_create_layer(x, y + sprite_height/2, "Instances", obj_dust_particle);
            land_dust.sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_part_character_jump;
        }
    }
}

// Keep ninja within room bounds horizontally
if (x < sprite_width/2) {
    x = sprite_width/2;
    hspeed = 0;
}
if (x > room_width - sprite_width/2) {
    x = room_width - sprite_width/2;
    hspeed = 0;
}

// Also check for horizontal tile collision
if (hspeed != 0) {
    var check_x = x + sign(hspeed) * (sprite_width/2 + abs(hspeed));
    var check_y = y;
    if (tilemap_get_at_pixel(tilemap, check_x, check_y) > 0) {
        hspeed = 0;
    }
}

// Enhanced sprite management with animation control
if (is_hurt) {
    sprite_index = spr_player_hurt;
    image_speed = 1; // Normal animation speed
} else if (!on_ground) {
    // In air - check if jumping or falling with buffer to prevent glitching
    if (vspeed < -1) { // More threshold for jump sprite
        sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_player_jump; // Use prefab jump sprite
        image_speed = 0.5; // Slower jump animation
    } else if (vspeed > 1) { // More threshold for fall sprite
        sprite_index = spr_player_fall;
        image_speed = 0.8; // Medium fall animation
    }
    // Keep current sprite if velocity is close to 0 (prevents glitching)
} else {
    // On ground - check if moving or idle
    if (abs(hspeed) > 0.1) {
        sprite_index = spr_player_walk;
        image_speed = abs(hspeed) / move_speed; // Animation speed matches movement speed
    } else {
        sprite_index = spr_player_idle;
        image_speed = 0.3; // Slow idle breathing animation
    }
}

// Coin collection
var collected_coin = instance_place(x, y, obj_coin);
if (collected_coin != noone) {
    // Increase score (we'll track this in a global variable)
    if (!variable_global_exists("coins_collected")) {
        global.coins_collected = 0;
    }
    global.coins_collected++;
    
    // Destroy the coin
    instance_destroy(collected_coin);
    
    // Optional: Add sound effect here if you have one
    // audio_play_sound(snd_coin_collect, 1, false);
}

// Background Music Toggle Control
// Press M to toggle background music on/off
if (keyboard_check_pressed(ord("M"))) {
    var bg_music = ::io.gamemaker.ninjawoods-1.0.0::MP3_Ninja_Woods_Game;
    
    if (global.music_playing) {
        // Stop the music
        audio_stop_sound(bg_music);
        global.music_playing = false;
    } else {
        // Start the music
        audio_play_sound(bg_music, 1, true); // Priority 1, Loop = true
        global.music_playing = true;
    }
}

// Fallback: prevent ninja from falling out of room
if (y > room_height + 100) {
    y = 100; // Reset to top of room if it falls too far
    vspeed = 0;
}