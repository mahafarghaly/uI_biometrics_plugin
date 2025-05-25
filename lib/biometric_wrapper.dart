import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:flutter/material.dart';
import 'package:ui_biometrics_plugin/view/widgets/settings_alert.dart';

class BiometricWrapper extends StatefulWidget {
  final Widget child;
  final String? localizedReason;
  final Map<dynamic, dynamic>? userCredentials;
  final bool? biometricOnly;
  final bool? useErrorDialogs;
  final bool? sensitiveTransaction;
  final bool? stickyAuth;

  const BiometricWrapper({
    super.key,
    required this.child,
    this.localizedReason,
    this.userCredentials,
    this.biometricOnly,
    this.useErrorDialogs,
    this.stickyAuth,
    this.sensitiveTransaction,
  });

  @override
  _BiometricWrapperState createState() => _BiometricWrapperState();
}

class _BiometricWrapperState extends State<BiometricWrapper>
    with WidgetsBindingObserver {
  final biometric = BiometricAuth();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Authenticate on app launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerAuth();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('App resumed, checking biometrics...');
      _triggerAuth();
    }
  }

  Future<void> _triggerAuth() async {
    if (_isAuthenticated) return;
    final status = await biometric.authenticate(
      userCredentials: widget.userCredentials,
      biometricOnly: widget.biometricOnly ?? false,
      localizedReason: widget.localizedReason,
      useErrorDialogs: widget.useErrorDialogs ?? false,
      sensitiveTransaction: widget.sensitiveTransaction ?? true,
      stickyAuth: widget.stickyAuth ?? true,
    );
    if (status == BiometricStatus.biometricNotActivated) {
      Future.delayed(Duration(milliseconds: 200), () {
        showDialog(context: context, builder: (context) => SettingsAlert());
      });
    } else if (status == BiometricStatus.success) {
      _isAuthenticated = true;
      print("✅ Authenticated successfully. $status");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
