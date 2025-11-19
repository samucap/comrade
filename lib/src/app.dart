import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/avatar_widget.dart';
import 'widgets/message_list.dart';
import 'widgets/mic_button.dart';
import 'widgets/particles_background.dart';
import 'core/theme.dart';
import 'providers/theme_provider.dart';

/// Main application widget with immersive voice companion interface
class CompanionApp extends HookConsumerWidget {
  const CompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeProvider);
    final personality = ref.watch(currentPersonalityProvider);

    // Battery monitoring temporarily disabled
    final isLowBattery = useState<bool>(false);

    // Configure system UI for immersive experience
    useEffect(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
      return null;
    }, []);

    return MaterialApp(
      title: 'Comrade',
      theme: theme,
      home: Scaffold(
        body: Stack(
          children: [
            // Background layers
            _buildBackground(context, personality, isLowBattery.value),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Message list (35% of screen height)
                  Expanded(
                    flex: 35,
                    child: AutoScrollMessageList(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                  ),

                  // Avatar area (65% of screen height)
                  Expanded(
                    flex: 65,
                    child: _buildAvatarArea(context),
                  ),
                ],
              ),
            ),

            // Mic button overlay
            _buildMicButtonOverlay(context),

            // Bottom gradient overlay for better contrast
            _buildBottomGradient(context),
          ],
        ),
      ),
    );
  }

  /// Build the background layers
  Widget _buildBackground(BuildContext context, Personality personality, bool isLowBattery) {
    return Stack(
      children: [
        // Radial gradient background
        Container(
          decoration: BoxDecoration(
            gradient: personality.radialGradient,
          ),
        ),

        // Particle background (disabled on low battery)
        if (!isLowBattery)
          ParticlesBackground(
            enabled: true,
            particleCount: 30,
            maxSpeed: 0.3,
          ),

        // Low battery indicator
        if (isLowBattery)
          Positioned(
            top: 40.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.battery_alert,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Low Battery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Build the avatar area with pull-down gesture handling
  Widget _buildAvatarArea(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // Handle pull-down gesture for personality switching
        if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
          // Trigger personality switch
          // This will be handled by the AvatarWidget's gesture detector
        }
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 120.h), // Space for mic button
        child: const AvatarWidget(),
      ),
    );
  }

  /// Build the mic button overlay
  Widget _buildMicButtonOverlay(BuildContext context) {
    return Positioned(
      bottom: 32.h,
      left: 0,
      right: 0,
      child: Center(
        child: InstructionalMicButton(
          size: 80.sp,
          showInstructions: true,
        ),
      ),
    );
  }

  /// Build bottom gradient overlay for better UI contrast
  Widget _buildBottomGradient(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 120.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.surface.withOpacity(0.3),
              Theme.of(context).colorScheme.surface.withOpacity(0.6),
            ],
          ),
        ),
      ),
    );
  }
}

/// Performance optimized app wrapper
class PerformanceOptimizedApp extends StatelessWidget {
  const PerformanceOptimizedApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Battery monitoring temporarily disabled
    return const CompanionApp();
  }
}

/// App with battery-aware particle system (temporarily disabled)
class BatteryAwareApp extends StatelessWidget {
  const BatteryAwareApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Battery monitoring temporarily disabled
    return const CompanionApp();
  }
}

/// Hook for battery-aware performance optimization (temporarily disabled)
BatteryInfo useBatteryOptimization() {
  // Battery monitoring temporarily disabled
  return const BatteryInfo(
    level: 100,
    isLowPower: false,
  );
}

/// Battery information for performance optimization
class BatteryInfo {
  const BatteryInfo({
    required this.level,
    required this.isLowPower,
  });

  final int level;
  final bool isLowPower;
}

/// Extension methods for battery-aware widgets
extension BatteryAwareExtensions on Widget {
  /// Wrap widget with battery-aware performance optimizations
  Widget batteryAware() {
    return HookBuilder(
      builder: (context) {
        final batteryInfo = useBatteryOptimization();

        return AnimatedOpacity(
          opacity: batteryInfo.isLowPower ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: this,
        );
      },
    );
  }
}

