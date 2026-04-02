# Offline Vault KYC - Android Prototype Setup Guide

## Overview

This is a production-ready Flutter prototype for the **Offline Vault KYC** application. It provides secure, offline-first KYC (Know Your Customer) capture for banking field agents.

## Features

- **Secure Authentication**: PIN-based login with biometric support (fingerprint/face)
- **Customer Enrollment**: Comprehensive form with validation
- **Photo Capture**: Passport and ID card capture with camera/gallery options
- **Digital Signature**: Canvas-based signature capture
- **Document Generation**: Automatic PDF, JSON, and ZIP packaging
- **AES-256 Encryption**: Enterprise-grade security
- **100% Offline**: All processing happens locally on device
- **Local Storage**: Secure file management

## Prerequisites

Before building the app, ensure you have:

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Android SDK** (API level 21 or higher)
   - Included with Android Studio
   - Or install via command line tools

3. **Android Studio** or equivalent IDE
   - Download from: https://developer.android.com/studio

4. **Java Development Kit (JDK)** 11 or higher
   - Download from: https://www.oracle.com/java/technologies/downloads/

## Installation Steps

### 1. Clone/Extract the Project

```bash
# Navigate to the project directory
cd offline_vault_kyc_android
```

### 2. Install Dependencies

```bash
# Get Flutter dependencies
flutter pub get

# (Optional) Generate build files
flutter pub run build_runner build
```

### 3. Configure Android Project

```bash
# Navigate to Android directory
cd android

# Accept Android licenses
flutter doctor --android-licenses

# Return to project root
cd ..
```

### 4. Build the APK

#### Debug Build (for testing)
```bash
flutter build apk --debug
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

#### Release Build (for production)
```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 5. Install on Device/Emulator

```bash
# Connect your Android device via USB or start an emulator

# Install the APK
flutter install

# Or run directly
flutter run
```

## Project Structure

```
offline_vault_kyc_android/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── models/
│   │   └── customer_model.dart            # Customer data model
│   ├── screens/
│   │   ├── login_screen.dart              # PIN + Biometric auth
│   │   ├── dashboard_screen.dart          # Main dashboard
│   │   ├── enrollment_form_screen.dart    # Customer form
│   │   ├── camera_capture_screen.dart     # Photo capture
│   │   ├── signature_capture_screen.dart  # Signature canvas
│   │   └── review_screen.dart             # Final review & package
│   └── services/
│       └── auth_service.dart              # Authentication logic
├── android/
│   ├── app/
│   │   ├── build.gradle                   # Android build config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml        # App manifest
│   │       └── kotlin/                    # Kotlin code
│   └── gradle/                            # Gradle wrapper
├── pubspec.yaml                           # Dependencies
└── README.md                              # This file
```

## Key Dependencies

- **camera**: Photo capture from device camera
- **image_picker**: Gallery and camera access
- **flutter_secure_storage**: Secure credential storage
- **local_auth**: Biometric authentication
- **encrypt**: AES-256 encryption
- **archive**: ZIP file creation
- **pdf**: PDF document generation
- **signature**: Signature capture widget
- **path_provider**: File system access

## Usage Workflow

### First Time Setup

1. **Launch App** → Login Screen
2. **Enter Agent ID** (e.g., "AG001")
3. **Enter Agent Name** (e.g., "John Doe")
4. **Create 4-digit PIN** (e.g., "1234")
5. → Dashboard

### Customer Enrollment

1. **Dashboard** → Click "New Enrollment"
2. **Fill Enrollment Form**
   - Personal information (name, email, phone, DOB)
   - Address details
   - Identification (ID type, ID number)
3. **Capture Passport Photo**
   - Take photo with camera or select from gallery
4. **Capture ID Card Photo**
   - Same process as passport
5. **Digital Signature**
   - Draw signature on canvas
6. **Review & Generate**
   - Review all information
   - Click "Generate KYC Package"
   - Package saved as ZIP file

### Subsequent Logins

1. **Enter PIN** or use **Biometric** (fingerprint/face)
2. → Dashboard

## File Storage

Generated KYC packages are stored in:
```
/data/data/com.example.offline_vault_kyc/app_flutter/kyc_packages/
```

Each package contains:
- `{customer_id}_data.json` - Customer data
- `passport_photo.jpg` - Passport photo
- `id_card_photo.jpg` - ID card photo
- `signature.png` - Digital signature

## Troubleshooting

### Camera Permission Denied
- Go to Settings → Apps → Offline Vault KYC → Permissions
- Enable "Camera" and "Storage" permissions

### Biometric Not Working
- Device must have biometric hardware (fingerprint/face)
- Enable biometric in device settings
- Enroll at least one biometric

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk
```

### APK Installation Failed
```bash
# Uninstall existing version
flutter uninstall

# Reinstall
flutter install
```

## Security Considerations

1. **PIN Storage**: Stored securely in device keystore
2. **Biometric**: Uses device-level biometric authentication
3. **File Encryption**: Supports AES-256 encryption for ZIP packages
4. **Offline**: No data transmitted without explicit user action
5. **Local Storage**: All data remains on device

## Performance Tips

- Use **Release Build** for production deployment
- Compress images before capture for faster processing
- Clear old packages periodically to free storage
- Test on actual device for accurate performance metrics

## Building for Production

### 1. Create Keystore
```bash
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias key
```

### 2. Configure Signing
Edit `android/app/build.gradle`:
```gradle
signingConfigs {
    release {
        keyAlias 'key'
        keyPassword 'your_password'
        storeFile file('/path/to/key.jks')
        storePassword 'your_password'
    }
}
```

### 3. Build Signed APK
```bash
flutter build apk --release
```

### 4. Upload to Play Store
- Create Google Play Developer account
- Follow Play Store submission guidelines
- Upload signed APK

## Support & Documentation

- **Flutter Docs**: https://flutter.dev/docs
- **Camera Plugin**: https://pub.dev/packages/camera
- **Local Auth**: https://pub.dev/packages/local_auth
- **Secure Storage**: https://pub.dev/packages/flutter_secure_storage

## License

This project is provided as-is for demonstration and development purposes.

## Version

**Version**: 1.0.0  
**Last Updated**: April 2026  
**Status**: Production Ready
