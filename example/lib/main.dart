import 'package:flutter/material.dart';
import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:ui_biometrics_plugin/biometric_wrapper.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BiometricStatus status;
  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('Biometric UI Plugin'),backgroundColor: Colors.amber,),
        body: BiometricsScreen(),
      ),
    );
  }
}
class BiometricsScreen extends StatelessWidget{
  BiometricsScreen({super.key});
  final _wrapperKey = GlobalKey<BiometricWrapperState>();
  BiometricStatus? biometricStatus;
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
                biometricStatus= await _wrapperKey.currentState?.triggerAuth();
                print("@@@✅$biometricStatus");
              },
              child: Text("Authenticate with Biometrics"),
            ),
          ],
        ),
      ),
    );
  }
}