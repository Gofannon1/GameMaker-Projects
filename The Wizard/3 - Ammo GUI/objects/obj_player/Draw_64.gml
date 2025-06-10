// Draw GUI for ammo display
// Set font and color
draw_set_font(fnt_GUI);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw ammo counter in top-left corner
var ammo_text = "Ammo: " + string(current_ammo) + "/" + string(max_ammo);
draw_text(20, 20, ammo_text);

// Draw reload status if reloading
if (is_reloading) {
    var reload_progress = (reload_duration - reload_timer) / reload_duration;
    var reload_text = "Reloading... " + string(round(reload_progress * 100)) + "%";
    draw_text(20, 50, reload_text);
}

// Draw "Out of Ammo" warning if no ammo
if (current_ammo <= 0 && !is_reloading) {
    draw_set_color(c_red);
    draw_text(20, 50, "OUT OF AMMO - Press R to Reload");
    draw_set_color(c_white);
}

// Reset text alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
