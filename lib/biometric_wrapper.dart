import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:flutter/material.dart';
import 'package:ui_biometrics_plugin/view/widgets/settings_alert.dart';

class BiometricWrapper extends StatefulWidget {
  final Widget child;
  final bool triggerManually;
  final String? localizedReason;
  final Map<dynamic, dynamic>? userCredentials;
  final bool? biometricOnly;
  final bool? sensitiveTransaction;
  final bool? stickyAuth;
  final VoidCallback? onCancelSettingsAlert;
  const BiometricWrapper({
    super.key,
    this.triggerManually = false,
    required this.child,
    this.localizedReason,
    this.userCredentials,
    this.biometricOnly,
    this.stickyAuth,
    this.sensitiveTransaction,
    this.onCancelSettingsAlert,
  });

  @override
  BiometricWrapperState createState() => BiometricWrapperState();
}

class BiometricWrapperState extends State<BiometricWrapper>
    with WidgetsBindingObserver {
  final biometric = BiometricAuth();
  bool _isAuthenticated = false;
  bool _dialogShown = false;
  late BiometricStatus biometricStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!widget.triggerManually) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        triggerAuth();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        biometricStatus != BiometricStatus.userCancelBiometric) {
      await triggerAuth();
    }
  }

  Future<BiometricStatus> triggerAuth() async {
    if (_isAuthenticated) return BiometricStatus.success;
     biometricStatus = await biometric.authenticate(
      userCredentials: widget.userCredentials,
      biometricOnly: widget.biometricOnly ?? false,
      localizedReason: widget.localizedReason,
      sensitiveTransaction: widget.sensitiveTransaction ?? true,
      stickyAuth: widget.stickyAuth ?? true,
    );
    if (biometricStatus == BiometricStatus.biometricNotActivated &&
        !_dialogShown) {
      //if (!mounted) return;
      _dialogShown = true;
      Future.delayed(Duration(milliseconds: 200), () {
        showDialog(
          context: context,
          builder: (context) => SettingsAlert(onCancel: widget.onCancelSettingsAlert,),
        ).then((_) {
          _dialogShown = false;
        });
      });
    } else if (biometricStatus == BiometricStatus.success) {
      _isAuthenticated = true;
      print("✅ Authenticated successfully. $biometricStatus");
    }
    return biometricStatus;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
