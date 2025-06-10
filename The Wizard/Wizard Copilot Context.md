# The Wizard - GameMaker Studio 2 Project Documentation

*Last Updated: June 9, 2025*

## Project Overview

This document contains comprehensive information about "The Wizard" series of GameMaker Studio 2 projects, documenting all development work, features implemented, code patterns, and decisions made during development.

### Project Structure
```
The Wizard/
├── 1 - WASD with Sprites/          # Basic movement and sprite handling
├── 2 - Adding Attack/              # Movement + attack system  
├── 3 - Ammo GUI/                   # Full system with ammo and GUI
├── 4 - Fireball Projectile/        # Projectile system with fireballs
└── Assets/                         # Shared sprite assets
```

## Development Summary

All four projects have been successfully implemented with the following progression:
1. **Project 1**: Basic WASD movement with proper sprite handling
2. **Project 2**: Added spacebar attack system with movement lock
3. **Project 3**: Complete system with ammo management and GUI
4. **Project 4**: Fireball projectile system with directional shooting

---

## Project 1: WASD with Sprites

**Purpose**: Implement basic player movement with WASD controls and proper sprite handling
**Status**: ✅ Complete and Optimized

### Key Features
- ✅ WASD movement controls
- ✅ Diagonal movement normalization (0.7071 multiplier)
- ✅ Sprite directional handling with selective flipping
- ✅ Room boundary collision
- ✅ Facing direction system

### Variables (Create_0.gml)
```gml
move_speed = 1;
right_key = false;
left_key = false;
down_key = false;
up_key = false;
h_input = 0;
v_input = 0;
facing_direction = 1; // 1 = right, -1 = left
```

### Controls
- **W** - Move up
- **A** - Move left 
- **S** - Move down
- **D** - Move right

### Available Sprites
- `spr_wizard_idle` - Stationary wizard (flips with facing direction)
- `spr_wizard_run` - Horizontal movement (flips for left/right)
- `spr_wizard_up` - Moving up (no flipping)
- `spr_wizard_down` - Moving down (no flipping)

### Key Design Decision
**No sprite flipping for up/down movement** - This was specifically implemented to avoid weird-looking vertical movement animations.

---

## Project 2: Adding Attack

**Purpose**: Movement system + attack mechanics
**Status**: ✅ Complete with animation fix

### Features Implemented
- ✅ All features from Project 1
- ✅ Attack system (Spacebar)
- ✅ Movement lock during attack
- ✅ Attack animation (55 frames timing)
- ✅ Fixed attack animation timing issue

### Additional Variables (Create_0.gml)
```gml
// All Project 1 variables plus:
attack_key = false;
is_attacking = false;
attack_timer = 0;
attack_duration = 55; // 11 frames at 12fps = 55 game frames at 60fps
```

### Controls
- **WASD** - Movement (disabled during attack)
- **Spacebar** - Attack

### Additional Sprite
- `spr_wizard_attack` - Attack animation (flips with facing direction)

### Attack Animation Fix
**Problem**: Attack animation wasn't playing correctly due to no frame reset
**Solution**: 
```gml
// When attack starts:
sprite_index = spr_wizard_attack;
image_index = 0; // Restart animation from frame 0
```

---

## Project 3: Ammo GUI

**Purpose**: Complete wizard game with ammo management and GUI
**Status**: ✅ Complete with full ammo system

### Features Implemented
- ✅ All features from Project 2
- ✅ **Ammo system** (10 max ammo, consumption per attack)
- ✅ **Reload system** (R key, 2-second reload time)
- ✅ **GUI display** (ammo counter, reload progress, warnings)
- ✅ **Movement lock** during reload and attack
- ✅ **Attack animation fix** (same as Project 2)

### Additional Variables (Create_0.gml)
```gml
// All Project 2 variables plus:
max_ammo = 10;
current_ammo = max_ammo;
reload_key = false;
is_reloading = false;
reload_timer = 0;
reload_duration = 120; // 2 seconds at 60fps
```

### Controls
- **WASD** - Movement (disabled during attack/reload)
- **Spacebar** - Attack (requires ammo, disabled during reload)
- **R** - Reload (when ammo < max, disabled during attack)

### GUI System (Draw_64.gml)
- **Ammo Counter**: "Ammo: X/10" (top-left corner)
- **Reload Progress**: "Reloading... X%" (during reload)
- **Out of Ammo Warning**: Red "OUT OF AMMO! Press R to reload" message
- **Font**: Uses `fnt_GUI` for consistent styling

---

## Project 4: Fireball Projectile

**Purpose**: Add projectile system with fireball shooting mechanics
**Status**: ✅ Complete with directional projectiles

### Features Implemented
- ✅ All features from Project 3
- ✅ **Fireball projectile system** (spawns at end of attack animation)
- ✅ **Directional shooting** (left/right based on facing direction)
- ✅ **Projectile positioning** (spawns 25 pixels in front of player)
- ✅ **Projectile movement** (2 pixels per frame speed)
- ✅ **Automatic cleanup** (5-second lifetime, boundary checking)
- ✅ **New fireball object** with proper movement logic
- ✅ **Attack timing** (fireball fires 10 frames before attack animation ends)

### New Objects Created
- `obj_blue_fireball` - Projectile object with movement and cleanup

### Additional Sprite
- `spr_blue_fireball` - Blue fireball projectile animation

### Fireball System Logic
```gml
// Player Create Event - Add fireball tracking
fireball_spawned = false; // Track if fireball has been spawned for current attack

// Player attack starts (no immediate fireball)
if (attack_key && !is_attacking && !is_reloading && current_ammo > 0) {
    is_attacking = true;
    attack_timer = attack_duration;
    fireball_spawned = false; // Reset for new attack
    // ...other attack setup...
}

// Fireball spawns near end of attack animation
if (attack_timer == 10 && !fireball_spawned) {
    fireball_spawned = true;
    var spawn_x = x + (facing_direction * 25); // 25 pixels in front
    var spawn_y = y;
    var fireball = instance_create_layer(spawn_x, spawn_y, "Instances", obj_blue_fireball);
    fireball.direction = (facing_direction == 1) ? 0 : 180;
}
```

### Fireball Object Variables (Create_0.gml)
```gml
speed = 2; // Pixels per frame
direction = 0; // Set when created by player
lifetime = 300; // 5 seconds at 60fps before auto-destroy
```

### Player Attack Variables (Create_0.gml addition)
```gml
fireball_spawned = false; // Track if fireball has been spawned for current attack
```

### Projectile Movement (Step_0.gml)
```gml
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
```

---

## Code Architecture and Patterns

### Movement System (All Projects)
```gml
// Input handling
right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
down_key = keyboard_check(ord("S"));
up_key = keyboard_check(ord("W"));

h_input = right_key - left_key;
v_input = down_key - up_key;

// Diagonal normalization
if (h_input != 0 && v_input != 0) {
    h_input *= 0.7071;
    v_input *= 0.7071;
}

// Movement application (only when not attacking/reloading)
if (!is_attacking && !is_reloading) {
    x += h_input * move_speed;
    y += v_input * move_speed;
}

// Boundary checking
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);
```

### Attack System Pattern
```gml
// Attack initiation (Project 4 with delayed fireball spawning)
if (attack_key && !is_attacking && !is_reloading && current_ammo > 0) {
    is_attacking = true;
    attack_timer = attack_duration;
    sprite_index = spr_wizard_attack1;
    image_index = 0; // Critical for animation
    current_ammo--; // Project 3+ only
    fireball_spawned = false; // Reset fireball flag for new attack
}

// Attack timer countdown with delayed fireball spawning
if (is_attacking) {
    attack_timer--;
    
    // Spawn fireball near end of attack (10 frames before completion)
    if (attack_timer == 10 && !fireball_spawned) {
        fireball_spawned = true;
        var spawn_x = x + (facing_direction * 25); // 25 pixels in front
        var spawn_y = y;
        var fireball = instance_create_layer(spawn_x, spawn_y, "Instances", obj_blue_fireball);
        fireball.direction = (facing_direction == 1) ? 0 : 180;
    }
    
    if (attack_timer <= 0) {
        is_attacking = false;
    }
}
```

### Sprite Management System
```gml
// Facing direction tracking
if (h_input > 0) facing_direction = 1;
if (h_input < 0) facing_direction = -1;

// Sprite selection with selective flipping
if (is_attacking) {
    sprite_index = spr_wizard_attack;
    image_xscale = facing_direction;
} else if (h_input != 0) {
    sprite_index = spr_wizard_run;
    image_xscale = facing_direction;
} else if (v_input > 0) {
    sprite_index = spr_wizard_down;
    image_xscale = 1; // No flipping for vertical
} else if (v_input < 0) {
    sprite_index = spr_wizard_up;
    image_xscale = 1; // No flipping for vertical
} else {
    sprite_index = spr_wizard_idle;
    image_xscale = facing_direction;
}
```

### Ammo and Reload System (Project 3+)
```gml
// Reload initiation
if (reload_key && !is_reloading && !is_attacking && current_ammo < max_ammo) {
    is_reloading = true;
    reload_timer = reload_duration;
}

// Reload timer countdown
if (is_reloading) {
    reload_timer--;
    if (reload_timer <= 0) {
        is_reloading = false;
        current_ammo = max_ammo;
    }
}
```

### Projectile System Pattern (Project 4)
```gml
// Fireball Create Event
speed = 2; // Movement speed
direction = 0; // Set by creator
lifetime = 300; // Auto-destroy timer

// Fireball Step Event
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Boundary checking
if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32) {
    instance_destroy();
}

// Lifetime countdown
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
}
```

---

## Key Development Decisions

### 1. Sprite Flipping Strategy
**Decision**: Only flip horizontal movement, idle, and attack sprites
**Reasoning**: Up/down movement sprites look unnatural when flipped horizontally

### 2. Movement Lock During Actions
**Decision**: Prevent movement during attacks and reloads
**Reasoning**: Creates intentional gameplay mechanics and prevents animation conflicts

### 3. Attack Animation Timing
**Decision**: 55-frame attack duration with sprite reset
**Reasoning**: Matches sprite animation timing and ensures proper playback

### 4. Diagonal Movement Normalization
**Decision**: Use 0.7071 multiplier for diagonal movement
**Reasoning**: Mathematical accuracy (1/√2) prevents diagonal speed advantage

### 5. Ammo System Balance
**Decision**: 10 max ammo, 2-second reload time
**Reasoning**: Encourages strategic ammo management without being frustrating

### 6. Projectile System Design (Project 4)
**Decision**: Delayed spawning 25 pixels ahead with timing-based firing
**Reasoning**: Creates more realistic attack timing and prevents fireballs from spawning inside the player

---

## Fixed Issues During Development

### 1. Attack Animation Not Playing Correctly
**Problem**: Animation would sometimes start from wrong frame
**Root Cause**: No frame reset when changing to attack sprite
**Solution**: Set `sprite_index` and `image_index = 0` when attack begins
**Status**: ✅ Fixed in Projects 2 and 3

### 2. Weird Vertical Movement Sprites
**Problem**: Up/down walking sprites looked strange when flipped
**Root Cause**: All sprites were being flipped based on facing direction
**Solution**: Only flip horizontal movement, idle, and attack sprites
**Status**: ✅ Fixed in all projects

### 3. Diagonal Movement Too Fast
**Problem**: Diagonal movement was √2 times faster than cardinal movement
**Solution**: Apply 0.7071 multiplier to both inputs when both are non-zero
**Status**: ✅ Fixed in all projects

---

## File Modifications Made

### Project 1 Files:
- `objects/obj_player/Create_0.gml` - Basic movement variables
- `objects/obj_player/Step_0.gml` - Movement and sprite logic
- `objects/obj_player/obj_player.yy` - Object configuration

### Project 2 Files:
- `objects/obj_player/Create_0.gml` - Added attack variables
- `objects/obj_player/Step_0.gml` - Added attack system with animation fix
- `objects/obj_player/obj_player.yy` - Object configuration

### Project 3 Files:
- `objects/obj_player/Create_0.gml` - Added ammo system variables
- `objects/obj_player/Step_0.gml` - Full system with ammo and reload
- `objects/obj_player/Draw_64.gml` - **NEW** GUI rendering system
- `objects/obj_player/obj_player.yy` - Added Draw GUI event

### Project 4 Files:
- `objects/obj_player/Create_0.gml` - Same as Project 3
- `objects/obj_player/Step_0.gml` - Added fireball spawning to attack system
- `objects/obj_player/Draw_64.gml` - Same as Project 3
- `objects/obj_player/obj_player.yy` - Same as Project 3
- `objects/obj_blue_fireball/Create_0.gml` - **NEW** Fireball initialization
- `objects/obj_blue_fireball/Step_0.gml` - **NEW** Fireball movement logic
- `objects/obj_blue_fireball/obj_blue_fireball.yy` - **NEW** Fireball object config

---

## Testing Results

### Project 1: ✅ Fully Working
- Movement: Smooth WASD control with diagonal normalization
- Sprites: Correct directional animations with selective flipping
- Boundaries: Player properly constrained to room

### Project 2: ✅ Fully Working  
- All Project 1 features maintained
- Attack: Animation plays correctly from start
- Movement: Properly locked during attack

### Project 3: ✅ Fully Working
- All Project 2 features maintained
- Ammo: Consumption and display working correctly
- Reload: Progress indicator and refill working
- GUI: All elements displaying properly

### Project 4: ✅ Fully Working
- All Project 3 features maintained
- Projectiles: Fireballs spawn correctly on attack
- Direction: Fireballs shoot left/right based on facing direction
- Cleanup: Projectiles destroy properly at boundaries and timeout

---

## Available Assets

### Sprites:
- `spr_wizard_idle` - Stationary wizard
- `spr_wizard_walking` - Horizontal movement (Projects 1-4)
- `spr_wizard_up` - Upward movement
- `spr_wizard_down` - Downward movement  
- `spr_wizard_attack1` - Attack animation (Projects 2-4)
- `spr_blue_fireball` - Blue fireball projectile (Project 4)

### Fonts:
- `fnt_GUI` - User interface font (used in Projects 3-4)

---

## Future Enhancement Possibilities

### Gameplay Features:
- Enemy systems with AI
- Health/damage mechanics
- Multiple weapon types
- Level progression system
- Sound effects and music
- Particle effects

### Technical Improvements:
- State machine architecture
- Animation system with events
- Input buffering system
- Screen shake effects
- Save/load functionality

This documentation serves as a complete reference for all work completed on "The Wizard" project series and provides context for future development or troubleshooting.

### Development Efficiency Notes:
1. **Pattern Recognition**: Common systems can be copied and modified between projects
2. **Debugging Process**: Most issues resolved through systematic variable tracking
3. **Animation Timing**: Critical to reset sprite frames for proper animation playback
4. **Projectile Architecture**: Modular design allows for easy weapon system expansion
5. **Code Reusability**: Common patterns can be applied across similar projects

---

## Project Status: COMPLETE ✅

All four projects in "The Wizard" series have been successfully implemented and tested:
- **Project 1**: Basic movement system ✅
- **Project 2**: Attack system integration ✅  
- **Project 3**: Ammo and GUI implementation ✅
- **Project 4**: Fireball projectile system ✅

**Development Time**: Approximately 4-5 hours total
**Next Steps**: Ready for additional features or new project development

*This context file represents the complete development cycle for a foundational 2D action game in GameMaker Studio 2, demonstrating proper movement, combat, UI, and projectile systems that serve as a solid foundation for more complex game development.*
