// Move the fireball
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Destroy if out of room bounds
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32) {
    instance_destroy();
}

// Countdown lifetime and destroy if expired
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
}
