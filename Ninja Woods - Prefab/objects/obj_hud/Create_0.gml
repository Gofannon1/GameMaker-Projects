// Initialize HUD and background music
if (!variable_global_exists("coins_collected")) {
    global.coins_collected = 0;
}

// Start background music from ninja woods prefab
// Play the background music on loop
var bg_music = ::io.gamemaker.ninjawoods-1.0.0::MP3_Ninja_Woods_Game;
audio_play_sound(bg_music, 1, true); // Priority 1, Loop = true

// Store music state for toggle control
global.music_playing = true;