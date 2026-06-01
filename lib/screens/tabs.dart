import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/screens/initiative.dart';
import 'package:initiative_support/screens/statuses_screen.dart';
import 'package:initiative_support/widgets/main_drawer.dart';

/// Root screen that hosts the main app drawer and top-level pages.
class TabsScreen extends ConsumerStatefulWidget {
  /// Creates the root tabs screen.
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  Future<void> _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'statuses') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const StatusesScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: const Initiative(),
    );
  }
}
