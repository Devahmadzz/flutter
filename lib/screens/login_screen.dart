import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _pinController = TextEditingController();
  final _agentIdController = TextEditingController();
  final _agentNameController = TextEditingController();
  
  String _errorMessage = '';
  bool _isFirstTime = false;
  bool _isLoading = false;
  bool _showPin = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final hasPin = await _authService.hasPin();
    setState(() {
      _isFirstTime = !hasPin;
    });
    if (!_isFirstTime) {
      _tryBiometric();
    }
  }

  Future<void> _tryBiometric() async {
    final success = await _authService.authenticateBiometrics();
    if (success && mounted) {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final pin = _pinController.text;
      if (pin.length != 4) {
        setState(() => _errorMessage = 'PIN must be 4 digits');
        return;
      }

      if (_isFirstTime) {
        final agentId = _agentIdController.text.trim();
        final agentName = _agentNameController.text.trim();

        if (agentId.isEmpty || agentName.isEmpty) {
          setState(() => _errorMessage = 'Please enter Agent ID and Name');
          return;
        }

        await _authService.setPin(pin);
        await _authService.setAgentInfo(agentId, agentName);
        if (mounted) _navigateToDashboard();
      } else {
        final success = await _authService.verifyPin(pin);
        if (success) {
          if (mounted) _navigateToDashboard();
        } else {
          setState(() => _errorMessage = 'Invalid PIN');
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock_outline, size: 80, color: Colors.teal),
                const SizedBox(height: 24),
                Text(
                  _isFirstTime ? 'Setup Staff Account' : 'Offline Vault KYC',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isFirstTime
                      ? 'Create your PIN and agent profile'
                      : 'Enter your PIN to continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 40),
                if (_isFirstTime) ...[
                  TextField(
                    controller: _agentIdController,
                    decoration: InputDecoration(
                      labelText: 'Agent ID',
                      hintText: 'e.g., AG001',
                      prefixIcon: const Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _agentNameController,
                    decoration: InputDecoration(
                      labelText: 'Agent Name',
                      hintText: 'Your full name',
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: !_showPin,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    hintText: '****',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_showPin ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showPin = !_showPin),
                    ),
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Continue'),
                ),
                if (!_isFirstTime) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _tryBiometric,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Use Biometric'),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _agentIdController.dispose();
    _agentNameController.dispose();
    super.dispose();
  }
}
