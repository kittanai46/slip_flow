# Camera Setup Guide for Slip Flow

## iOS Setup

### 1. Update `ios/Podfile`

Uncomment or add the platform line at the top:
```ruby
platform :ios, '11.0'
```

### 2. Update `ios/Runner/Info.plist`

Add camera and photo permissions:
```xml
<dict>
    ...
    <key>NSCameraUsageDescription</key>
    <string>We need access to your camera to scan receipts</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to your photo library to select receipt images</string>
    ...
</dict>
```

### 3. Run setup
```bash
cd ios
pod update
cd ..
```

## Android Setup

### 1. Update `android/app/build.gradle.kts`

```kotlin
android {
    compileSdk 34
    
    defaultConfig {
        applicationId "com.example.slip_flow"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}
```

### 2. Update `android/app/src/main/AndroidManifest.xml`

Add camera and storage permissions:
```xml
<manifest ...>
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <application>
        ...
    </application>
</manifest>
```

### 3. Request Runtime Permissions

Add to `pubspec.yaml`:
```yaml
dependencies:
  permission_handler: ^11.4.0
```

Create `lib/services/permission_service.dart`:
```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }
}
```

Update `lib/views/scan_screen.dart` to request permissions:
```dart
import '../services/permission_service.dart';

Future<void> _initializeCamera() async {
  try {
    // Request permissions
    final cameraGranted = await PermissionService.requestCameraPermission();
    if (!cameraGranted) {
      debugPrint('Camera permission denied');
      return;
    }

    await _initializeCameras();
    // ... rest of initialization
  } catch (e) {
    debugPrint('Error initializing camera: $e');
  }
}
```

## Web Setup (if needed)

For web support, use the `image_picker` plugin instead of `camera`:

```yaml
dependencies:
  image_picker: ^0.8.7
```

## Testing the Camera

### iOS
1. Run on a real device (camera not available in simulator)
2. Check that permission dialog appears
3. Allow camera access
4. Try taking a photo

### Android
1. Run on a real device or emulator with camera
2. Check that permission dialog appears
3. Allow camera access
4. Try taking a photo

### Common Issues

**Issue**: "Camera not available"
- **Solution**: Make sure you're testing on a real device or emulator with camera support

**Issue**: "Permission denied"
- **Solution**: Grant camera permission in app settings

**Issue**: "Camera initialization failed"
- **Solution**: Check logs with `flutter logs`

**Issue**: "Platform exception when taking photo"
- **Solution**: Ensure device has sufficient storage

## Camera Preview Frame

The app includes a custom scanning frame:
- ✅ Receipt-sized frame (3:5 aspect ratio)
- ✅ Green corner brackets
- ✅ Semi-transparent overlay
- ✅ "Frame your receipt" instruction text
- ✅ Circular capture button

## After Camera Setup

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to test on device
3. Tap "Scan Receipt" from home screen
4. Allow camera permission
5. Frame receipt in the scanner box
6. Tap camera button to capture
7. Edit receipt details and save

## Next Steps

1. ✅ Complete camera setup above
2. ✅ Test camera functionality
3. [ ] Implement real OCR (see OCR_INTEGRATION_GUIDE.md)
4. [ ] Add image cropping based on detected frame
5. [ ] Add receipt detection with ML Kit
6. [ ] Optimize camera for low-light receipts

## Resources

- [Camera Plugin Documentation](https://pub.dev/packages/camera)
- [Permission Handler Documentation](https://pub.dev/packages/permission_handler)
- [iOS Camera Setup](https://github.com/flutter/plugins/tree/main/packages/camera/camera_ios)
- [Android Camera Setup](https://github.com/flutter/plugins/tree/main/packages/camera/camera_android)

## Troubleshooting

If camera is not working:

1. Check Flutter version: `flutter --version`
2. Check plugin compatibility: `flutter pub outdated`
3. Clean and rebuild: `flutter clean && flutter pub get && flutter run`
4. Check device logs: `flutter logs`
5. Ensure device/emulator has camera hardware

## Platform-Specific Notes

### iOS
- Uses `AVFoundation` framework
- Camera preview might appear stretched on different aspect ratios
- Requires iOS 11.0 or higher

### Android
- Uses Android Camera2 API
- Requires API level 21 (Android 5.0) or higher
- Takes longer to initialize on first run

### Web
- Not supported by `camera` plugin
- Use `image_picker` instead for web support
