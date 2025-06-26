import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'homescreen.dart';
import 'splash_screen.dart';

class FingerprintScan extends StatefulWidget {
  const FingerprintScan({super.key});

  @override
  State<FingerprintScan> createState() => _FingerprintScanState();
}

class _FingerprintScanState extends State<FingerprintScan> with WidgetsBindingObserver {
  final LocalAuthentication _localAuth = LocalAuthentication();

  String _statusMessage = 'Authenticating...';
  bool _isAuthenticating = true;
  bool _authCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAuthentication();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isAuthenticating && !_authCompleted) {
      // Navigate to splash screen after short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
          );
        }
      });
    }
  }

  Future<void> _startAuthentication() async {
    setState(() {
      _isAuthenticating = true;
      _statusMessage = 'Authenticating...';
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        setState(() {
          _statusMessage = "Biometric authentication not supported.";
          _isAuthenticating = false;
        });
        _exitAppAfterDelay();
        return;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: "Authenticate with fingerprint or device PIN",
        options: const AuthenticationOptions(
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );

      if (!didAuthenticate) {
        setState(() {
          _statusMessage = "Authentication failed or cancelled.";
          _isAuthenticating = false;
        });
        _exitAppAfterDelay();
        return;
      }

      // Authentication successful
      _authCompleted = true;
      await authProvider.markLoggedIn();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Authentication error: $e";
        _isAuthenticating = false;
      });
      _exitAppAfterDelay();
    }
  }

  void _exitAppAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAuthenticating)
              const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
