import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission manager for handling microphone and storage permissions
class PermissionManager {
  /// Check if microphone permission is granted
  static Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Request microphone permission
  static Future<PermissionStatus> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status;
  }

  /// Check and request microphone permission if needed
  static Future<bool> ensureMicrophonePermission() async {
    if (await hasMicrophonePermission()) {
      return true;
    }

    final status = await requestMicrophonePermission();
    return status.isGranted;
  }

  /// Open app settings if permission is permanently denied
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Get permission status message for UI
  static String getPermissionMessage(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Microphone access granted';
      case PermissionStatus.denied:
        return 'Microphone access denied. Please enable it in settings.';
      case PermissionStatus.permanentlyDenied:
        return 'Microphone access permanently denied. Please enable it in app settings.';
      case PermissionStatus.restricted:
        return 'Microphone access is restricted on this device.';
      case PermissionStatus.limited:
        return 'Microphone access is limited.';
      case PermissionStatus.provisional:
        return 'Microphone access is provisional.';
    }
  }
}

/// Permission request result
class PermissionResult {
  const PermissionResult({
    required this.isGranted,
    required this.status,
    this.message,
  });

  final bool isGranted;
  final PermissionStatus status;
  final String? message;

  /// Create success result
  factory PermissionResult.granted() {
    return const PermissionResult(
      isGranted: true,
      status: PermissionStatus.granted,
      message: 'Permission granted',
    );
  }

  /// Create denied result
  factory PermissionResult.denied(PermissionStatus status) {
    return PermissionResult(
      isGranted: false,
      status: status,
      message: PermissionManager.getPermissionMessage(status),
    );
  }
}

/// Permission dialog helper
class PermissionDialog {
  /// Show permission rationale dialog
  static Future<bool> showRationale(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission'),
        content: const Text(
          'This app needs microphone access to record your voice messages. '
          'Your recordings are stored locally and never shared without your consent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Show permission denied dialog with settings option
  static Future<void> showDeniedDialog(BuildContext context, {bool isPermanent = false}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(
          isPermanent
              ? 'Microphone permission is required to record audio. '
                'Please enable it in your device settings.'
              : 'Microphone permission was denied. You can enable it later in settings.',
        ),
        actions: [
          if (!isPermanent)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          if (isPermanent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                PermissionManager.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }

  /// Request permission with UI flow
  static Future<PermissionResult> requestWithUI(BuildContext context) async {
    // Check current status
    final currentStatus = await Permission.microphone.status;
    
    if (currentStatus.isGranted) {
      return PermissionResult.granted();
    }

    // Show rationale if not permanently denied
    if (!currentStatus.isPermanentlyDenied) {
      final shouldRequest = await showRationale(context);
      if (!shouldRequest) {
        return PermissionResult.denied(PermissionStatus.denied);
      }
    }

    // Request permission
    final status = await PermissionManager.requestMicrophonePermission();

    if (!status.isGranted && context.mounted) {
      await showDeniedDialog(
        context,
        isPermanent: status.isPermanentlyDenied,
      );
    }

    return status.isGranted
        ? PermissionResult.granted()
        : PermissionResult.denied(status);
  }
}


