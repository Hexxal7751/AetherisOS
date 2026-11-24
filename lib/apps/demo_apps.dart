import 'package:flutter/material.dart';

class FilesApp extends StatelessWidget {
  const FilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Documents', Icons.folder_rounded),
      ('Downloads', Icons.download_rounded),
      ('Pictures', Icons.photo_library_rounded),
      ('Music', Icons.library_music_rounded),
      ('Projects', Icons.code_rounded),
    ];
    return ListView(
      children: [
        for (final (name, icon) in items)
          ListTile(
            dense: true,
            leading: Icon(icon, color: const Color(0xFFFFC857)),
            title: Text(name),
            subtitle: const Text('Folder'),
          ),
      ],
    );
  }
}

class SettingsApp extends StatefulWidget {
  const SettingsApp({super.key});

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  final Map<String, bool> _flags = {
    'Dark mode': true,
    'Focus Mode': false,
    'Wi-Fi 7': true,
    'Bluetooth LE': true,
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final e in _flags.entries)
          SwitchListTile(
            dense: true,
            title: Text(e.key),
            value: e.value,
            onChanged: (v) => setState(() => _flags[e.key] = v),
          ),
      ],
    );
  }
}

class TerminalApp extends StatelessWidget {
  const TerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      child: const SingleChildScrollView(
        child: Text(
          'Aetheris OS 4.0 (Build 2026.Q2)\n'
          'aetheris@os:~\$ uname -a\n'
          'AetherisKernel 4.0 x86_64 NT-isolated\n'
          'aetheris@os:~\$ nowbar --status\n'
          'NowBar service: running\n'
          'aetheris@os:~\$ _',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: Color(0xFF7CFFB2),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class PlaceholderApp extends StatelessWidget {
  const PlaceholderApp({super.key, required this.name, required this.icon});

  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.white38),
          const SizedBox(height: 12),
          Text('$name — coming soon',
              style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}