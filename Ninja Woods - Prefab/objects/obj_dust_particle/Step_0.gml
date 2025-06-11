// Update dust particle
life_timer++;

// Fade out over time
image_alpha = 0.8 * (1 - (life_timer / lifetime));

// Destroy when lifetime expires
if (life_timer >= lifetime) {
    instance_destroy();
}