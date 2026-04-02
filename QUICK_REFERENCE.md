# Offline Vault KYC - Quick Reference

## Installation & Build

```bash
# 1. Install dependencies
flutter pub get

# 2. Build Debug APK (for testing)
flutter build apk --debug

# 3. Build Release APK (for production)
flutter build apk --release

# 4. Install on device
flutter install

# 5. Run app
flutter run
```

## APK Locations

- **Debug**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release**: `build/app/outputs/flutter-apk/app-release.apk`

## Default Credentials (First Time)

```
Agent ID: AG001
Agent Name: Demo Agent
PIN: 1234
```

## File Paths

**KYC Packages**: `/data/data/com.example.offline_vault_kyc/app_flutter/kyc_packages/`

**Package Contents**:
- `{customer_id}_data.json` - Customer information
- `passport_photo.jpg` - Passport photo
- `id_card_photo.jpg` - ID card photo
- `signature.png` - Digital signature

## Key Features

| Feature | Status | Details |
|---------|--------|---------|
| PIN Authentication | ✅ | 4-digit PIN |
| Biometric Auth | ✅ | Fingerprint/Face |
| Customer Form | ✅ | Full validation |
| Photo Capture | ✅ | Camera & Gallery |
| Signature | ✅ | Canvas drawing |
| ZIP Packaging | ✅ | Secure archive |
| Encryption | ✅ | AES-256 ready |
| Offline Mode | ✅ | 100% offline |

## Permissions Required

- `CAMERA` - Photo capture
- `READ_EXTERNAL_STORAGE` - Gallery access
- `WRITE_EXTERNAL_STORAGE` - File storage
- `USE_BIOMETRIC` - Biometric auth
- `USE_FINGERPRINT` - Fingerprint auth

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Camera not working | Enable camera permission in settings |
| Biometric fails | Enroll fingerprint/face in device |
| Build errors | Run `flutter clean && flutter pub get` |
| APK too large | Use release build (smaller size) |
| Slow performance | Use release build, not debug |

## Development Commands

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run tests
flutter test

# Check code
flutter analyze

# Format code
dart format lib/

# Build APK
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle
```

## Deployment Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Test on actual device
- [ ] Verify all permissions work
- [ ] Test offline functionality
- [ ] Check file storage paths
- [ ] Build release APK
- [ ] Sign APK with keystore
- [ ] Test signed APK
- [ ] Upload to Play Store

## Performance Metrics

| Metric | Value |
|--------|-------|
| Min SDK | 21 |
| Target SDK | 33+ |
| Debug Build Time | 5-10 min |
| Release Build Time | 10-15 min |
| Debug APK Size | 50-80 MB |
| Release APK Size | 30-50 MB |
| Typical Enrollment | 2-3 min |
| Package Size | 5-10 MB |

## Support Resources

- Flutter Docs: https://flutter.dev/docs
- Camera Plugin: https://pub.dev/packages/camera
- Local Auth: https://pub.dev/packages/local_auth
- Android Docs: https://developer.android.com/docs

---

**Version**: 1.0.0 | **Updated**: April 2026
