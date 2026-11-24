import 'package:flutter/material.dart';

import 'shell/desktop_shell.dart';
import 'theme/aetheris_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AetherisApp());
}

class AetherisApp extends StatelessWidget {
  const AetherisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aetheris OS',
      debugShowCheckedModeBanner: false,
      theme: AetherisTheme.dark,
      home: const DesktopShell(),
    );
  }
}