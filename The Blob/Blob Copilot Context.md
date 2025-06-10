# The Blob - GameMaker Studio 2 Platformer Project Documentation

*Last Updated: June 10, 2025*

## Project Overview

This document contains comprehensive information about "The Blob" GameMaker Studio 2 platformer project, documenting all development work, features implemented, code patterns, and decisions made during development. This project follows similar conventions and progressive development patterns established in "The Wizard" series.

### Project Structure
```
The Blob/
├── 1 - Essential Platformer Mechanics/  # Basic platformer movement and physics
├── base game/                           # Base implementation for expansion
└── Blob Copilot Context.md            # This documentation file
```

## Development Summary

The Blob project has been implemented with essential platformer mechanics:
1. **Basic Movement**: Left/right movement with A/D keys
2. **Jump System**: Single jump with W key (only when grounded)
3. **Physics**: Gravity, collision detection, ground state management
4. **Boundaries**: Horizontal clamping, vertical fall detection

---

## Current Implementation: Essential Platformer Mechanics

**Purpose**: Implement core platformer movement with clean, expandable code structure
**Status**: ✅ Complete and Optimized

### Key Features
- ✅ Left/Right movement controls (A/D keys)
- ✅ Single jump system (W key, ground-based only)
- ✅ Gravity and physics system
- ✅ Pixel-perfect collision detection
- ✅ Ground state management
- ✅ Room boundary handling
- ✅ Sprite flipping based on movement direction

### Variables (Create_0.gml)
```gml
// Movement variables (following The Wizard conventions)
move_speed = 4;
jump_height = -15;
gravity_force = 0.5;

// Input variables
right_key = false;
left_key = false;
jump_key = false;

// Speed tracking
h_speed = 0;
v_speed = 0;

// State tracking
is_on_ground = false;
facing_direction = 1; // 1 = right, -1 = left

// Tilemap reference
ground_layer = layer_tilemap_get_id("Ground");
```

### Controls
- **A** - Move left
- **D** - Move right
- **W** - Jump (only when on ground)

### Available Sprites
- `spr_player` - Main blob character sprite
- `spr_player_crouch` - Crouched blob sprite (available but not used)
- `spr_ground_ts` - Ground tileset for level construction

### Physics Values
- **Move Speed**: 4 pixels per frame
- **Jump Height**: -15 pixels (negative = upward in GameMaker)
- **Gravity**: 0.5 pixels per frame acceleration

---

## Code Architecture and Patterns

### Movement System
```gml
// Input handling (following The Wizard conventions)
right_key = keyboard_check(ord("D"));
left_key = keyboard_check(ord("A"));
jump_key = keyboard_check_pressed(ord("W"));

// Update facing direction
if (right_key) facing_direction = 1;
if (left_key) facing_direction = -1;

// Horizontal movement
h_speed = (right_key - left_key) * move_speed;
```

### Physics System
```gml
// Apply gravity
v_speed += gravity_force;

// Reset ground state when moving upward (jumping/falling up)
if (v_speed < 0) {
    is_on_ground = false;
}

// Jump when on ground
if (jump_key && is_on_ground) {
    v_speed = jump_height;
    is_on_ground = false; // Immediately set to false when jumping
}
```

### Collision Detection System
```gml
// Horizontal collision
if (place_meeting(x + h_speed, y, ground_layer)) {
    while (!place_meeting(x + sign(h_speed), y, ground_layer)) {
        x += sign(h_speed);
    }
    h_speed = 0;
}
x += h_speed;

// Vertical collision
if (place_meeting(x, y + v_speed, ground_layer)) {
    while (!place_meeting(x, y + sign(v_speed), ground_layer)) {
        y += sign(v_speed);
    }
    
    // Only set grounded when landing (falling downward into ground)
    if (v_speed > 0) {
        is_on_ground = true;
    }
    v_speed = 0;
} else {
    // Not touching ground, so definitely not grounded
    is_on_ground = false;
}
y += v_speed;
```

### Boundary Management System
```gml
// Step Event - Horizontal boundaries (prevent leaving sides)
x = clamp(x, 0, room_width);

// Outside Room Event (Other_0.gml) - Vertical boundary (restart on fall)
if (y > room_height) {
    room_restart();
}
```

### Sprite Management System
```gml
// Sprite flipping (following The Wizard conventions)
image_xscale = facing_direction;
```

---

## Key Development Decisions

### 1. Input System Design
**Decision**: Use The Wizard's variable naming conventions
**Reasoning**: Consistency with established patterns, easier code maintenance and expansion

### 2. Ground Detection Logic
**Decision**: Only set `is_on_ground = true` when falling downward into collision
**Reasoning**: Prevents infinite jumping by distinguishing between landing vs hitting ceiling

### 3. Jump State Management
**Decision**: Immediately set `is_on_ground = false` when jumping
**Reasoning**: Prevents double jumping and ensures clean state transitions

### 4. Boundary Handling Strategy
**Decision**: Clamp horizontal movement, restart room on vertical fall
**Reasoning**: 
- Horizontal: Feels like invisible walls, no death penalty
- Vertical: Standard platformer behavior for falling off screen

### 5. Physics Values Balance
**Decision**: Move speed 4, jump height -15, gravity 0.5
**Reasoning**: Provides responsive but controlled movement with good jump arc

### 6. Collision System Architecture
**Decision**: Separate horizontal and vertical collision with pixel-perfect movement
**Reasoning**: Prevents getting stuck in walls and provides smooth collision response

---

## Fixed Issues During Development

### 1. Ground Detection Logic Error
**Problem**: Original logic set `is_on_ground = true` for any downward movement
**Root Cause**: Missing collision context in ground state logic
**Solution**: Only set grounded when actually colliding with ground while falling
**Status**: ✅ Fixed - Ground detection now properly differentiates landing vs ceiling collision

### 2. Jump State Management
**Problem**: Potential for double jumping due to improper state reset
**Root Cause**: `is_on_ground` not immediately set to false when jumping
**Solution**: Added `is_on_ground = false;` immediately when jump starts
**Status**: ✅ Fixed - Clean jump state transitions

### 3. Room Boundary Handling
**Problem**: All boundaries caused death/restart
**Root Cause**: Single boundary check for all edges
**Solution**: Separate handling - clamp horizontal, restart on vertical fall
**Status**: ✅ Fixed - More user-friendly boundary behavior

### 4. Event Registration Issue
**Problem**: Outside Room event not properly registered in project file
**Root Cause**: Missing event type 7 in obj_player.yy eventList
**Solution**: Added proper event registration to GameMaker project configuration
**Status**: ✅ Fixed - Outside Room event now properly triggers

### 5. Variable Optimization
**Problem**: Unnecessary intermediate variables (`h_input`, `v_input`)
**Root Cause**: Over-engineering from The Wizard patterns
**Solution**: Removed unused variables and simplified calculations
**Status**: ✅ Fixed - Cleaner, more efficient code structure

---

## File Modifications Made

### Both Projects (1 - Essential Platformer Mechanics & base game):

#### `objects/obj_player/Create_0.gml`
- Movement and physics variables
- Input state variables
- Ground state tracking
- Facing direction system
- Tilemap layer reference

#### `objects/obj_player/Step_0.gml`
- Input handling system
- Movement calculation and application
- Gravity and jump physics
- Collision detection (horizontal and vertical)
- Ground state management
- Boundary clamping
- Sprite flipping logic

#### `objects/obj_player/Other_0.gml`
- **NEW** Outside Room event
- Room restart on bottom boundary exit

#### `objects/obj_player/obj_player.yy`
- Added Outside Room event registration (eventType 7)
- Proper event configuration for GameMaker

---

## Testing Results

### Essential Platformer Mechanics: ✅ Fully Working
- **Movement**: Smooth left/right control with responsive input
- **Jumping**: Single jump with proper ground detection
- **Physics**: Realistic gravity and collision response
- **Boundaries**: Horizontal clamping and vertical fall restart working correctly
- **State Management**: Clean ground state transitions
- **Collision**: Pixel-perfect collision with no wall-sticking issues

---

## Available Assets

### Sprites:
- `spr_player` - Main blob character (animated)
- `spr_player_crouch` - Crouched blob sprite (available for future features)
- `spr_ground_ts` - Ground tileset for level construction

### Layers:
- `"Ground"` - Solid collision tilemap layer
- `"Platforms"` - Platform layer reference (not currently used)

---

## Future Enhancement Possibilities

### Gameplay Features (Following The Wizard progression):
- **Attack System** - Blob-specific abilities (stretch, slam, bounce)
- **Health/Lives System** - HP management with GUI display
- **Enemy System** - Enemies with AI and collision damage
- **Collectibles** - Items to collect with scoring system
- **Special Abilities** - Blob powers (wall stick, morph shapes, size changes)
- **Level Progression** - Multiple rooms/levels with transitions
- **Platform System** - Re-enable drop-through platforms
- **Double Jump** - Additional air mobility
- **Wall Jumping** - Advanced movement mechanics

### Technical Improvements:
- **Animation States** - Different sprites for idle, moving, jumping, falling
- **State Machine** - Organized state management system
- **Sound Effects** - Audio feedback for actions
- **Particle Effects** - Visual polish for jumps, landings
- **Coyote Time** - Forgiving jump timing
- **Jump Buffering** - Responsive input handling
- **Save/Checkpoint System** - Progress persistence
- **Screen Shake** - Impact feedback
- **Variable Jump Height** - Hold for higher jumps

### Code Architecture Improvements:
- **Input Manager** - Centralized input handling
- **Physics Manager** - Modular physics systems
- **Animation Controller** - Sprite state management
- **Audio Manager** - Sound effect organization
- **Level Manager** - Room transition handling

---

## Development Efficiency Notes

### 1. **Pattern Recognition from The Wizard**
- Variable naming conventions ensure consistency
- Progressive feature addition maintains clean codebase
- Similar event structure allows for easy feature porting

### 2. **Debugging Process**
- Ground state issues resolved through systematic collision analysis
- Event registration problems solved by examining project configuration files
- Variable optimization improved through usage analysis

### 3. **Code Reusability**
- Core movement patterns can be extended for advanced features
- Collision system architecture supports additional collision types
- Input system designed for easy control expansion

### 4. **GameMaker Best Practices**
- Proper event usage (Step vs Outside Room)
- Pixel-perfect collision implementation
- Clean variable organization in CREATE event

### 5. **Progressive Development**
- Foundation ready for The Wizard-style feature progression
- Modular design supports incremental complexity addition
- Clean separation of concerns for maintainability

---

## Project Status: FOUNDATION COMPLETE ✅

The essential platformer mechanics have been successfully implemented and tested:
- **Core Movement**: Left/right movement with responsive controls ✅
- **Jump System**: Single jump with proper ground detection ✅
- **Physics Engine**: Gravity and collision systems working correctly ✅
- **Boundary Management**: Smart horizontal/vertical boundary handling ✅
- **Code Structure**: Clean, expandable architecture following The Wizard conventions ✅
- **Documentation**: Comprehensive context file created for future development ✅

**Development Time**: Approximately 2-3 hours
**Next Steps**: Ready for progressive feature addition following The Wizard development pattern

**Session Complete**: June 10, 2025 - Foundation established with clean, documented codebase

---

## Comparison with The Wizard Series

### Similarities:
- ✅ Clean variable naming conventions
- ✅ Organized code structure with clear comments
- ✅ Progressive development approach
- ✅ Proper event usage and organization
- ✅ Facing direction system for future sprite management
- ✅ Foundation ready for attack systems, GUI, and advanced features

### Differences:
- **Movement Type**: Platformer (gravity-based) vs top-down (free movement)
- **Physics**: Gravity and jumping vs smooth directional movement
- **Boundaries**: Mixed approach (clamp + restart) vs uniform clamping
- **Collision**: Ground-based vs boundary-based
- **Input**: Discrete jump vs continuous movement

### Ready for Wizard-Style Progression:
1. **Next: Attack System** - Add blob-specific attack mechanics
2. **Then: Health/GUI** - HP system with visual feedback
3. **Then: Enemies** - AI opponents with collision damage
4. **Then: Advanced Features** - Special blob abilities and level progression

*This documentation serves as a complete reference for "The Blob" platformer foundation and provides context for future development following established patterns from "The Wizard" series.*
