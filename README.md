# Offline Vault KYC - Android Prototype

A production-ready Flutter application for secure, offline-first KYC (Know Your Customer) capture designed for banking field agents.

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release
```

## Key Features

✅ **Offline-First Architecture** - No internet required  
✅ **Secure Authentication** - PIN + Biometric (fingerprint/face)  
✅ **Photo Capture** - Passport & ID card with camera overlay  
✅ **Digital Signature** - Canvas-based signature capture  
✅ **Document Generation** - Auto-generate PDF, JSON, ZIP  
✅ **AES-256 Encryption** - Enterprise-grade security  
✅ **Local Storage** - All data stays on device  
✅ **Field Agent Ready** - Designed for remote deployment  

## Workflow

1. **Login** - PIN or biometric authentication
2. **Enrollment** - Fill customer form with validation
3. **Photo Capture** - Passport and ID card photos
4. **Signature** - Digital signature on canvas
5. **Review** - Verify all information
6. **Package** - Generate secure ZIP file

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── customer_model.dart            # Data model
├── screens/
│   ├── login_screen.dart              # Authentication
│   ├── dashboard_screen.dart          # Main dashboard
│   ├── enrollment_form_screen.dart    # Customer form
│   ├── camera_capture_screen.dart     # Photo capture
│   ├── signature_capture_screen.dart  # Signature
│   └── review_screen.dart             # Final review
└── services/
    └── auth_service.dart              # Auth logic
```

## Dependencies

- **flutter_camera**: Photo capture
- **image_picker**: Gallery & camera access
- **flutter_secure_storage**: Secure storage
- **local_auth**: Biometric authentication
- **encrypt**: AES-256 encryption
- **archive**: ZIP packaging
- **pdf**: PDF generation
- **signature**: Signature widget
- **path_provider**: File system access

## Installation

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed setup instructions.

## Usage

### First Time
1. Enter Agent ID and Name
2. Create 4-digit PIN
3. Access dashboard

### Enrollment
1. Click "New Enrollment"
2. Fill customer form
3. Capture photos
4. Draw signature
5. Generate KYC package

## Security

- PIN stored in device keystore
- Biometric authentication via device
- AES-256 encryption support
- No data transmission without action
- All processing local to device

## File Storage

KYC packages stored in:
```
/data/data/com.example.offline_vault_kyc/app_flutter/kyc_packages/
```

Each package contains:
- Customer data (JSON)
- Passport photo
- ID card photo
- Digital signature

## Troubleshooting

**Camera permission denied?**
- Settings → Apps → Offline Vault KYC → Permissions → Enable Camera

**Biometric not working?**
- Device must have biometric hardware
- Enroll biometric in device settings

**Build errors?**
```bash
flutter clean
flutter pub get
flutter build apk
```

## Performance

- **Debug Build**: ~5-10 minutes
- **Release Build**: ~10-15 minutes
- **App Size**: ~50-80 MB (debug), ~30-50 MB (release)
- **Storage**: ~100-200 MB per 100 enrollments

## Version

**1.0.0** - Production Ready  
**Last Updated**: April 2026

## License

Proprietary - For authorized use only

---

**Need Help?** See [SETUP_GUIDE.md](SETUP_GUIDE.md) for comprehensive documentation.
