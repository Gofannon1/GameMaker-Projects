# Crouch System Troubleshooting - Project 2

## Issues Found and Fixed:

### 1. **Height Calculation Bug** ✅ FIXED
**Problem**: Height difference was calculated inside the standing-up check instead of being pre-calculated
**Solution**: Moved height calculations to CREATE event with proper variable names

```gml
// OLD (buggy):
normal_height = sprite_get_height(stand_sprite);
current_height = sprite_get_height(crouch_sprite);
height_diff = normal_height - current_height;

// NEW (fixed):
normal_height = sprite_get_height(spr_player);      // 48 pixels
crouch_height = sprite_get_height(spr_player_crouch); // 24 pixels  
height_diff = normal_height - crouch_height;         // 24 pixels
```

### 2. **Position Adjustment Bug** ✅ FIXED
**Problem**: Player wasn't adjusting position when crouching, causing floating or ground clipping
**Solution**: Added proper Y position adjustments

```gml
// When crouching:
y += height_diff; // Move down to maintain ground contact

// When standing up:
y -= height_diff; // Move up to proper standing position
```

### 3. **Collision Logic Verified** ✅ WORKING
**Logic**: Check if there's room above player before allowing stand-up
```gml
if (!place_meeting(x, y - height_diff, ground_layer)) {
    // Safe to stand up
}
```

## Sprite Specifications:
- `spr_player`: 48x48 pixels (standing blob)
- `spr_player_crouch`: 48x24 pixels (crouched blob)
- Height difference: 24 pixels

## Expected Behavior:
1. **S Key**: Crouch when on ground (sprite changes, moves slower)
2. **Release S**: Stand up if there's room above
3. **In Air**: Auto-cancel crouch (can't crouch while airborne)
4. **While Crouching**: Can't jump, moves at 50% speed
5. **Position**: Maintains ground contact during crouch/stand transitions

## Test Cases:
- ✅ Crouch on flat ground
- ✅ Stand up on flat ground  
- ✅ Try to stand under low ceiling (should stay crouched)
- ✅ Jump while crouching (should be prevented)
- ✅ Auto-cancel crouch when airborne
- ✅ Slower movement while crouched
- ✅ Proper sprite switching
