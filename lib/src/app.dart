import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/avatar_widget.dart';
import 'widgets/message_list.dart';
import 'widgets/mic_button.dart';
import 'widgets/particles_background.dart';
import 'widgets/parallax_layer.dart';
import 'widgets/scroll_reveal.dart';
import 'core/theme.dart';
import 'core/typography.dart';
import 'providers/theme_provider.dart';

/// Premium Lusion-inspired voice companion interface
class CompanionApp extends HookConsumerWidget {
  const CompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(currentThemeProvider);
    final personality = ref.watch(currentPersonalityProvider);

    // Configure system UI for immersive experience
    useEffect(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      final isDark = personality == Personality.dark;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      );
      return null;
    }, [personality]);

    return MaterialApp(
      title: 'Comrade',
      theme: theme,
      home: const PremiumCompanionScreen(),
    );
  }
}

/// Premium companion screen with scroll-based layout
class PremiumCompanionScreen extends HookConsumerWidget {
  const PremiumCompanionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Premium background
          const PremiumBackground(),

          // Scrollable content
          CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top spacing
              SliverToBoxAdapter(
                child: SizedBox(height: LusionSpacing.xxxl),
              ),

              // Messages section with fixed height
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  padding: EdgeInsets.symmetric(
                    horizontal: LusionSpacing.md,
                  ),
                  child: AutoScrollMessageList(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // Spacer
              SliverToBoxAdapter(
                child: SizedBox(height: LusionSpacing.xxxl),
              ),

              // Avatar section (hero)
              SliverToBoxAdapter(
                child: ScrollReveal(
                  child: ParallaxLayer(
                    scrollController: scrollController,
                    speed: 0.3,
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        child: AvatarWidget(
                          scrollController: scrollController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom spacing for mic button
              SliverToBoxAdapter(
                child: SizedBox(height: LusionSpacing.massive),
              ),
            ],
          ),

          // Floating mic button
          Positioned(
            bottom: LusionSpacing.xxxl,
            left: 0,
            right: 0,
            child: Center(
              child: ScrollOpacity(
                scrollController: scrollController,
                startOpacity: 1.0,
                endOpacity: 0.95,
                startOffset: 0,
                endOffset: 100,
                child: const InstructionalMicButton(
                  size: 80,
                  showInstructions: true,
                ),
              ),
            ),
          ),
        ],
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

