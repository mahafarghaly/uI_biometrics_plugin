import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class SettingsAlert extends StatelessWidget {
  const SettingsAlert({super.key, this.onCancel, this.onInSettings});

  final VoidCallback? onCancel;
  final VoidCallback? onInSettings;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Biometric Status'),
      content: Text('Biometric is not activated'),
      actions: [
        TextButton(
          onPressed: () async {
            await AppSettings.openAppSettings(type: AppSettingsType.security);
            Navigator.pop(
              context,
            );
            if(onInSettings!=null){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onInSettings!();
              });
            }
          },
          child: Text('Open Settings'),
        ),
        TextButton(
          onPressed:
              onCancel ??
              () {
                Navigator.pop(context);
              },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
