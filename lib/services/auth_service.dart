import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static const String _pinKey = 'kyc_pin';
  static const String _agentIdKey = 'agent_id';
  static const String _agentNameKey = 'agent_name';
  
  final _secureStorage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  Future<bool> hasPin() async {
    final pin = await _secureStorage.read(key: _pinKey);
    return pin != null && pin.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = await _secureStorage.read(key: _pinKey);
    return storedPin == pin;
  }

  Future<bool> authenticateBiometrics() async {
    try {
      final isDeviceSupported = await _localAuth.canCheckBiometrics;
      final isDeviceSecure = await _localAuth.deviceSupportsBiometrics;

      if (!isDeviceSupported && !isDeviceSecure) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Offline Vault KYC',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> setAgentInfo(String agentId, String agentName) async {
    await _secureStorage.write(key: _agentIdKey, value: agentId);
    await _secureStorage.write(key: _agentNameKey, value: agentName);
  }

  Future<String?> getAgentId() async {
    return await _secureStorage.read(key: _agentIdKey);
  }

  Future<String?> getAgentName() async {
    return await _secureStorage.read(key: _agentNameKey);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _agentIdKey);
    await _secureStorage.delete(key: _agentNameKey);
  }
}
