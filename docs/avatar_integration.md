# Avatar Integration Guide

## ReadyPlayerMe & VRoid → Rive Conversion

This document outlines the pathway to integrate 3D avatars from ReadyPlayerMe or VRoid Studio into the Comrade app using Rive runtime.

## Overview

The Comrade app currently uses a placeholder avatar with icon-based emotions. This guide explains how to integrate realistic 3D avatars with full animation support.

## Prerequisites

- ReadyPlayerMe account (https://readyplayer.me/) OR VRoid Studio (https://vroid.com/)
- Rive Editor account (https://rive.app/)
- Basic understanding of 3D models and rigging
- Blender (optional, for advanced editing)

## Integration Pathways

### Option 1: ReadyPlayerMe → Rive

#### Step 1: Create/Export from ReadyPlayerMe

1. Create your avatar at https://readyplayer.me/
2. Export as `.glb` format
3. Ensure the avatar has facial blendshapes/morph targets

#### Step 2: Import to Rive (when supported)

**Note:** As of 2024, Rive has limited 3D support. Monitor their roadmap:
- https://rive.app/community/doc/3d-in-rive/docQ0l4J8CgI

**Current workaround:**
1. Convert 3D avatar to 2D sprite sheets using Blender
2. Render multiple angles and expressions
3. Import sprite sheets to Rive as artboards
4. Create state machine for emotion transitions

### Option 2: VRoid Studio → Rive

#### Step 1: Create/Export from VRoid

1. Design character in VRoid Studio
2. Export as `.vrm` format (VRM 1.0 recommended)
3. The VRM will include facial expression presets

#### Step 2: Convert VRM to compatible format

1. Import VRM into Blender using VRM importer plugin
2. Export facial expressions as separate animations
3. Render 2D sprite sheets or use alternative workflow

### Option 3: 2D Character Rive (Recommended for Now)

Until full 3D support is available, create a 2D character directly in Rive:

#### Step 1: Design in Rive Editor

1. Open Rive Editor
2. Create vector artwork for character
3. Use bones to rig the character
4. Create facial features as separate layers

#### Step 2: Animation & State Machine

1. Create animations for each emotion:
   - idle
   - listening
   - speaking
   - thinking
   - happy, laugh, smirk, blush
   - sad, angry, shocked
   - heart_eyes, eye_roll, shrug

2. Set up state machine with inputs:
   ```
   - idle (Boolean)
   - listening (Boolean)
   - speaking (Boolean)
   - thinking (Boolean)
   - happy (Boolean)
   - laugh (Boolean)
   ... (for each emotion)
   ```

3. Create transitions between states

#### Step 3: Export and Integrate

1. Export as `.riv` file
2. Replace `assets/animations/companion_placeholder.riv`
3. Update state machine name in code if different from default

## Blendshape Mapping

For 3D avatars with facial expressions, map these standard blendshapes to Comrade emotions:

| Comrade Emotion | VRM Blendshape | ARKit Blendshape |
|----------------|----------------|------------------|
| idle           | neutral        | neutral          |
| listening      | surprised*0.3  | browInnerUp      |
| speaking       | aa             | jawOpen + mouthSmile |
| thinking       | neutral        | browDown         |
| happy          | happy          | mouthSmile       |
| laugh          | happy*1.5      | mouthSmile + jawOpen |
| smirk          | happy*0.5      | mouthSmileLeft   |
| blush          | happy + blink  | mouthSmile + eyesClosed |
| sad            | sad            | mouthFrown       |
| angry          | angry          | browDownRight + browDownLeft |
| shocked        | surprised      | jawOpen + eyesWide |
| heart_eyes     | happy + blink  | mouthKiss + eyesClosed |
| eye_roll       | lookup + blink | eyeLookUp        |
| shrug          | neutral        | mouthShrug       |

## Code Integration

### Update Rive Controller

In `lib/src/core/rive_controller.dart`, ensure the state machine name matches your Rive file:

```dart
final stateMachineController = StateMachineController.fromArtboard(
  artboard,
  'avatar_state_machine', // Match this with your Rive file
);
```

### Trigger Emotions

Emotions are already wired up in the codebase:

```dart
// Trigger emotion from code
ref.read(avatarStateNotifierProvider.notifier).setEmotion(AvatarEmotion.happy);

// Trigger random emotion (for click interaction)
ref.read(avatarStateNotifierProvider.notifier).triggerRandomEmotion();
```

## Performance Optimization

### For 2D Rive Avatars
- Keep artboard size reasonable (< 1000x1000px)
- Limit bone count to < 30
- Use fills over strokes when possible
- Minimize nested clipping

### For Future 3D Avatars
- Keep polygon count < 10K
- Use texture atlases
- Limit bone influences per vertex to 4
- Use LOD (Level of Detail) for different distances

## Testing

1. **Animation Smoothness**: All transitions should be < 300ms
2. **State Machine**: Test all emotion combinations
3. **Performance**: Maintain 60fps on target devices
4. **Memory**: Keep avatar assets < 5MB

## Troubleshooting

### Rive file not loading
- Check file path in `pubspec.yaml`
- Ensure file is in `assets/animations/`
- Verify Rive runtime version compatibility

### Animations not playing
- Verify state machine input names match code
- Check that transitions are properly set up
- Ensure state machine is named correctly

### Performance issues
- Reduce avatar complexity
- Lower frame rate to 30fps
- Disable particle effects on low-end devices

## Future Enhancements

- Lip-sync for speaking state
- Eye tracking to follow user
- Physics-based hair/clothing
- Real-time expression mirroring
- Custom avatar upload

## Resources

- Rive Documentation: https://rive.app/docs
- ReadyPlayerMe API: https://docs.readyplayer.me/
- VRoid Documentation: https://vroid.com/en/wiki
- Blender VRM Plugin: https://github.com/saturday06/VRM-Addon-for-Blender
- Flutter Rive Package: https://pub.dev/packages/rive

## Support

For issues with avatar integration, check:
1. Rive Community Forums
2. GitHub issues in rive-flutter package
3. ReadyPlayerMe/VRoid official support

---

**Last Updated:** November 2024  
**Rive Version:** 0.13.x  
**Flutter Version:** 3.24+


