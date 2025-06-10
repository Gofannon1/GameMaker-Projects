// Request prediction data if not already doing so
if (!http_request_pending) {
    request_id = http_get("http://localhost:8000/teachable_output.json");
    http_request_pending = true;
}

show_debug_message("Label: " + ai_label);

// Movement
hspeed = 0;
vspeed = 0;

// Animation and movement based on AI label
if (ai_label == "Up") {
    vspeed = -1;
    sprite_index = spr_player_up;
} else if (ai_label == "Down") {
    vspeed = 1;
    sprite_index = spr_player_down;
} else if (ai_label == "Left") {
    hspeed = -1;
    sprite_index = spr_player_left;
} else if (ai_label == "Right") {
    hspeed = 1;
    sprite_index = spr_player_right;
} else if (ai_label == "Idle") {
    sprite_index = spr_player_idle;
}

// Constrain player to room boundaries
if (x < 0) x = 0;
if (y < 0) y = 0;
if (x > room_width - sprite_width) x = room_width - sprite_width;
if (y > room_height - sprite_height) y = room_height - sprite_height;