import 'dart:ui';

import 'package:flutter/material.dart';

import '../apps/app_registry.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({
    super.key,
    required this.onLaunch,
    required this.onClose,
    required this.bottomInset,
  });

  final void Function(AppDef app) onLaunch;
  final VoidCallback onClose;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: Colors.black.withValues(alpha: 0.35),
          padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset),
          child: Column(
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: ShapeDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 18, color: Colors.white54),
                    SizedBox(width: 10),
                    Text('Search apps',
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 110,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: appRegistry.length,
                  itemBuilder: (context, i) {
                    final app = appRegistry[i];
                    return GestureDetector(
                      onTap: () => onLaunch(app),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: app.colors,
                              ),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: Icon(app.icon,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(height: 8),
                          Text(app.name,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}