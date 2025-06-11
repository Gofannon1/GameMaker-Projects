// Draw HUD elements
draw_set_font(fnt_HUD); // Use custom HUD font
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw coin icon from prefab
var coin_icon = ::io.gamemaker.ninjawoods-1.0.0::spr_hud_coins;
draw_sprite(coin_icon, 0, 20, 20);

// Get the width of the coin sprite to position text properly
var coin_sprite_width = sprite_get_width(coin_icon);
var text_x = 20 + coin_sprite_width + 8; // 8 pixels padding after coin sprite
var text_y = 38; // Centered vertically with the coin sprite

// Draw coin counter to the right of the icon
draw_set_color(c_white);
draw_text(text_x, text_y, "x " + string(global.coins_collected)); // Main text

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);