# Ninja Woods Copilot Context

## Project Overview
A complete ninja character implementation in GameMaker Studio using the ninja woods prefab assets. The project features full movement mechanics, sprite animations, tileset collision, particle effects, coin collection system, HUD display, and background music functionality.

## Project Structure
```
Ninja Woods - Prefab/
├── Ninja Woods - Prefab.yyp (Main project file)
├── Ninja Woods Copilot Context.md (This documentation)
├── objects/
│   ├── obj_ninja/         # Main player character
│   ├── obj_coin/          # Collectible coins
│   ├── obj_dust_particle/ # Jump/landing particles
│   └── obj_hud/           # UI display system
├── sprites/
│   ├── spr_player_idle/   # 8-frame idle animation
│   ├── spr_player_walk/   # 8-frame walking animation
│   ├── spr_player_jump/   # Single frame jump sprite
│   ├── spr_player_fall/   # 4-frame falling animation
│   └── spr_player_hurt/   # Hurt state sprite
├── fonts/
│   └── fnt_HUD/           # Custom HUD font
├── datafiles/             # Additional game data
├── options/               # Project configuration
└── rooms/
    └── Room1/             # Main game room with tilemap
```

## Implemented Features

### 🥷 Ninja Character System (obj_ninja)
- **Movement Controls**: WASD keys and arrow keys for movement
- **Jump Mechanics**: Spacebar, W key, or Up arrow for jumping with gravity physics
- **Jump Buffer System**: 8-frame jump buffering for responsive controls
- **Hurt State System**: Temporary invulnerability with hurt timer (30 frames)
- **Sprite Animations**: 
  - Idle: 8-frame animation loop
  - Walking: 8-frame animation (12 FPS)
  - Jumping: Single frame sprite
  - Falling: 4-frame animation
  - Hurt: Damage state sprite
- **Physics**: 
  - Horizontal velocity: 4 pixels/frame
  - Jump velocity: -15 pixels (enhanced from -12)
  - Gravity: 0.8 pixels/frame² (enhanced from 0.5)
  - Max fall speed: 10 pixels/frame
  - Velocity thresholds for smooth movement

### 🧱 Collision Detection
- **Tilemap System**: Uses "Ground" layer for collision detection
- **Implementation**: `tilemap_get_at_pixel()` for precise collision
- **Performance**: Cached tilemap reference (`cached_tilemap`) for optimization
- **Collision Points**: Checks multiple points around character bounds

### ✨ Particle Effects System (obj_dust_particle)
- **Trigger Events**: Jump and landing dust particles
- **Sprite**: Uses `::io.gamemaker.ninjawoods-1.0.0::spr_part_character_jump`
- **Lifecycle**: 30-frame lifetime with fade effect
- **Positioning**: Spawns at ninja's feet with slight randomization

### 🪙 Coin Collection System (obj_coin)
- **Animation**: Floating motion with `sin()` wave function
- **Sprites**: Uses ninja woods prefab coin sprites
- **Collection**: Collision detection with ninja character
- **Counter**: Global tracking with `global.coins` variable
- **Visual Feedback**: Coins animate and disappear when collected

### 📊 HUD Display System (obj_hud)
- **Font**: Custom `fnt_HUD` font for clean display
- **Layout**: Coin icon + "x [number]" counter format
- **Positioning**: Top-left corner (32, 32) coordinates
- **Clean Design**: No text shadows for modern appearance
- **Real-time Updates**: Dynamic coin counter display

### 🎵 Background Music System
- **Audio**: Uses `::io.gamemaker.ninjawoods-1.0.0::MP3_Ninja_Woods_Game`
- **Auto-start**: Music begins automatically when HUD is created
- **Toggle Control**: M key to turn music on/off
- **State Tracking**: `global.music_playing` boolean variable
- **Looping**: Continuous background audio with `audio_play_sound(bg_music, 1, true)`

### 🛡️ Advanced Game Systems

#### Jump Buffer System
- **Buffer Time**: 8 frames of jump input buffering
- **Purpose**: Allows responsive jumping even if input occurs slightly before landing
- **Implementation**: `jump_buffer` and `jump_buffer_time` variables
- **Enhanced Feel**: Prevents missed jumps due to timing issues

#### Hurt State System
- **Invulnerability**: 30-frame temporary immunity after taking damage
- **Visual Feedback**: Special hurt sprite during damage state
- **State Management**: `is_hurt`, `hurt_timer`, and `hurt_duration` variables
- **Input Blocking**: Movement disabled during hurt state for impact feedback

## Technical Implementation Details

### Key Code Patterns

#### Movement System (obj_ninja Step_0.gml)
```gml
// Handle hurt state first
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
    
    // Jump buffer system
    if (jump_pressed) {
        jump_buffer = jump_buffer_time;
    }
    if (jump_buffer > 0) {
        jump_buffer--;
    }
}

// Sprite animation based on state
if (vspeed < -2) {
    sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_player_jump;
} else if (vspeed > 2) {
    sprite_index = spr_player_fall;
} else if (abs(hspeed) > 0.1) {
    sprite_index = spr_player_walk;
} else {
    sprite_index = spr_player_idle;
}
```

#### Character Initialization (obj_ninja Create_0.gml)
```gml
// Enhanced physics values
move_speed = 4;
jump_speed = -15;     // More powerful jump
gravity_force = 0.8;  // Stronger gravity for responsiveness
max_fall_speed = 10;

// Advanced state management
is_hurt = false;
hurt_timer = 0;
hurt_duration = 30;   // frames of invulnerability

// Jump buffer system
jump_buffer = 0;
jump_buffer_time = 8; // frames of jump buffering
```

#### Collision Detection Pattern
```gml
// Cache tilemap for performance
if (!variable_instance_exists(id, "cached_tilemap")) {
    cached_tilemap = layer_tilemap_get_id("Ground");
}

// Check collision at specific points
var collision = tilemap_get_at_pixel(cached_tilemap, x, y + sprite_height/2);
```

#### Particle System Creation
```gml
// Spawn dust particles on landing
if (on_ground && vspeed_prev > 2) {
    instance_create_layer(x, y + sprite_height/2, "Instances", obj_dust_particle);
}
```

### Prefab Asset Integration
GameMaker Studio prefabs are pre-built asset packages that can be imported into projects. The ninja woods prefab provides sprites, sounds, and other assets.

#### **How Prefabs Work**
- **Installation**: Prefabs are imported through the GameMaker Marketplace or asset store
- **Reference Format**: Assets are referenced using `::prefab-name::asset-name` syntax
- **Folder Organization**: Prefab assets maintain their own folder structure separate from project assets

#### **Ninja Woods Prefab Structure**
```
io.gamemaker.ninjawoods-1.0.0/
├── sprites/
│   ├── spr_player_idle         # 8-frame ninja idle animation
│   ├── spr_player_walk         # 8-frame ninja walking animation  
│   ├── spr_player_jump         # Single frame jump sprite
│   ├── spr_player_fall         # 4-frame falling animation
│   ├── spr_player_hurt         # Hurt state sprite
│   ├── spr_part_character_jump # Dust particle effect sprite
│   └── spr_coin_*             # Various coin sprites
├── sounds/
│   └── MP3_Ninja_Woods_Game   # Background music track
└── other assets...
```

#### **Prefab Reference Examples**
```gml
// Sprite assignment using prefab reference
sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_player_jump;

// Audio playback from prefab
bg_music = ::io.gamemaker.ninjawoods-1.0.0::MP3_Ninja_Woods_Game;
audio_play_sound(bg_music, 1, true);

// Particle creation with prefab sprite
instance_create_layer(x, y, "Instances", obj_dust_particle);
// In obj_dust_particle Create event:
sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_part_character_jump;
```

#### **Best Practices for Prefab Usage**
1. **Asset References**: Always use the full prefab reference syntax for consistency
2. **Local Copies**: Create local sprite copies if you need to modify prefab assets
3. **Fallback Assets**: Consider fallback sprites in case prefab isn't available
4. **Documentation**: Document which prefab assets your project depends on

#### **Mixed Asset Approach**
This project uses a hybrid approach:
- **Prefab Assets**: Player sprites, particles, background music from ninja woods prefab
- **Custom Assets**: Local sprite copies (`spr_player_walk`, `spr_player_idle`, etc.) for modification
- **Project Assets**: Custom objects, fonts, and logic (HUD, collision system, etc.)

#### **Prefab Dependencies**
- **Required Prefab**: `io.gamemaker.ninjawoods-1.0.0`
- **Project File Reference**: Listed in `ForcedPrefabProjectReferences` in `.yyp` file
- **Folder Structure**: Defined in `folders/io.gamemaker.ninjawoods-1.0.0.yy`

#### **Troubleshooting Prefab Issues**
- **Missing References**: Ensure prefab is properly installed and referenced in project
- **Asset Not Found**: Verify prefab asset names match exactly (case-sensitive)
- **Version Conflicts**: Check prefab version compatibility with GameMaker Studio version

## Common Issues & Solutions

### GameMaker JSON File Corruption
**Problem**: Undo operations can corrupt `.yy` files, causing JSON parsing errors.

**Symptoms**:
- "Field 'preMultiplyAlpha': expected" errors
- "Field 'volume': expected" errors  
- "Cannot resolve link" errors for sprite frames
- "Guid string should only contain hexadecimal characters" errors

**Solutions**:
1. **Missing Fields**: Add required JSON fields like `preMultiplyAlpha: false` and `volume: 1.0`
2. **Frame Mismatches**: Ensure keyframe references match actual frame file names
3. **Invalid GUIDs**: Replace malformed GUIDs with valid hexadecimal characters (0-9, a-f only)
4. **Sequence Length**: Update sequence length to match actual frame count

### Sprite Animation Issues
**Problem**: Jump sprite glitching or animation not playing smoothly.

**Solutions**:
- Use prefab jump sprite: `::io.gamemaker.ninjawoods-1.0.0::spr_player_jump`
- Set proper playback speeds (idle: 8 FPS, walk: 12 FPS)
- Implement velocity thresholds to prevent micro-movements

### Performance Optimization
- Cache tilemap references instead of repeated `layer_tilemap_get_id()` calls
- Use `abs()` function for velocity thresholds
- Limit particle lifetime to prevent memory issues

## Prefab Management Workflow

### **Setting Up Prefabs in GameMaker Studio**
1. **Installation Process**:
   ```
   GameMaker Studio → Marketplace → Search "Ninja Woods"
   → Download/Install → Import into Project
   ```

2. **Project Integration**:
   - Prefab automatically creates folder structure in Asset Browser
   - Assets become available with `::prefab-name::` syntax
   - Project file (`.yyp`) updated with prefab references

3. **Verification Steps**:
   - Check Asset Browser for prefab folder
   - Verify `ForcedPrefabProjectReferences` in project file
   - Test asset references in code

### **Working with Prefab vs Local Assets**
**When to Use Prefab Assets**:
- Need original, unmodified sprites/sounds
- Want automatic updates when prefab is updated
- Prototyping or temporary implementations

**When to Create Local Copies**:
- Need to modify sprites (resize, edit, etc.)
- Want version control over specific assets
- Building final production version

### **Asset Migration Strategy**
```gml
// Step 1: Start with prefab reference for prototyping
sprite_index = ::io.gamemaker.ninjawoods-1.0.0::spr_player_jump;

// Step 2: Create local copy when customization needed
// Import prefab sprite → Create new local sprite → Modify as needed
sprite_index = spr_player_jump; // Now using local copy
```

### **Prefab Version Management**
- **Check Dependencies**: List all prefab assets used in project
- **Version Tracking**: Document prefab version in project documentation
- **Update Strategy**: Test thoroughly when updating prefab versions
- **Backup Plan**: Keep local copies of critical assets as fallbacks

## Development Workflow

### File Editing Best Practices
1. **Always backup**: GameMaker `.yy` files are sensitive to manual edits
2. **Avoid undo operations**: Can corrupt complex JSON structures
3. **Use valid GUIDs**: Only hexadecimal characters (0-9, a-f)
4. **Test frequently**: Validate JSON structure after edits

### Resource Organization
- Objects in `/objects/` folder with proper naming convention
- Sprites maintain prefab folder structure
- Custom assets (fonts, etc.) in appropriate folders
- Consistent naming: `obj_[name]`, `spr_[name]`, `fnt_[name]`

## Future Development Ideas
- Enemy AI system
- Level progression/multiple rooms
- Sound effects for actions (jump, coin collect, etc.)
- Power-ups and abilities
- Score system beyond coin collection
- Level editor functionality
- Mobile touch controls
- Gamepad support

## Asset Dependencies
- **Required Prefab**: io.gamemaker.ninjawoods-1.0.0
- **Key Sprites**: Player animations, coin sprites, particle effects
- **Audio**: Background music track
- **Fonts**: Custom HUD font for UI display

## Current Status
✅ **COMPLETE AND FUNCTIONAL**
- All major systems implemented and tested
- No known bugs or errors
- Ready for gameplay testing
- Extensible architecture for future features

---
*Documentation created during collaborative development with GitHub Copilot*
*Last updated: June 11, 2025 - Updated to reflect actual implementation*
