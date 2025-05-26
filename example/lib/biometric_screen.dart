
import 'package:flutter/material.dart';
import 'package:ui_biometrics_plugin/biometric_wrapper.dart';

class BiometricsScreen extends StatelessWidget{
  const BiometricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BiometricWrapper(
     // userCredentials: {"name":"sara"},
      biometricOnly: true,
      child: Center(
        child: Text('Authentication Result: UI Biometrics plugin'),
      ),
    );
  }
}

