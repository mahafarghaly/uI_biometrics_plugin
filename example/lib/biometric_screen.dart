
import 'package:flutter/material.dart';
import 'package:ui_biometrics_plugin/biometric_wrapper.dart';

class BiometricsScreen extends StatelessWidget{
   BiometricsScreen({super.key});
  final _wrapperKey = GlobalKey<BiometricWrapperState>();
  @override
  Widget build(BuildContext context) {
    return BiometricWrapper(
    userCredentials: {"name":"maha","password":"1234"},
      biometricOnly: false,
     key: _wrapperKey,
      triggerManually: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Authentication Result: UI Biometrics plugin'),
        ElevatedButton(
          onPressed: () async {
            await _wrapperKey.currentState?.triggerAuth();
          },
          child: Text("Authenticate with Biometrics"),
        ),
          ],
        ),
      ),
    );
  }
}

