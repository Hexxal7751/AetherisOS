import 'package:flutter/material.dart';

import 'demo_apps.dart';

class AppDef {
  AppDef({
    required this.id,
    required this.name,
    required this.icon,
    required this.colors,
    required this.builder,
    this.pinned = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final List<Color> colors;
  final WidgetBuilder builder;
  final bool pinned;
}

final List<AppDef> appRegistry = [
  AppDef(
    id: 'files',
    name: 'Files',
    icon: Icons.folder_rounded,
    colors: const [Color(0xFFFFB347), Color(0xFFFF7E5F)],
    pinned: true,
    builder: (_) => const FilesApp(),
  ),
  AppDef(
    id: 'browser',
    name: 'Browser',
    icon: Icons.public_rounded,
    colors: const [Color(0xFF4DA3FF), Color(0xFF2563EB)],
    pinned: true,
    builder: (_) =>
        const PlaceholderApp(name: 'Browser', icon: Icons.public_rounded),
  ),
  AppDef(
    id: 'terminal',
    name: 'Terminal',
    icon: Icons.terminal_rounded,
    colors: const [Color(0xFF4B5563), Color(0xFF111827)],
    pinned: true,
    builder: (_) => const TerminalApp(),
  ),
  AppDef(
    id: 'settings',
    name: 'Settings',
    icon: Icons.settings_rounded,
    colors: const [Color(0xFF9B5CFF), Color(0xFF6D28D9)],
    pinned: true,
    builder: (_) => const SettingsApp(),
  ),
  AppDef(
    id: 'notes',
    name: 'Notes',
    icon: Icons.sticky_note_2_rounded,
    colors: const [Color(0xFFFACC15), Color(0xFFEAB308)],
    builder: (_) =>
        const PlaceholderApp(name: 'Notes', icon: Icons.sticky_note_2_rounded),
  ),
  AppDef(
    id: 'music',
    name: 'Music',
    icon: Icons.music_note_rounded,
    colors: const [Color(0xFFFB7185), Color(0xFFE11D48)],
    builder: (_) =>
        const PlaceholderApp(name: 'Music', icon: Icons.music_note_rounded),
  ),
];