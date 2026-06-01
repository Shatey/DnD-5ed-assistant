import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/screens/tabs.dart';

const _lightSeedColor = Color.fromARGB(255, 96, 59, 181);
const _darkSeedColor = Color.fromARGB(255, 5, 99, 125);

final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: _lightSeedColor,
);

final _darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: _darkSeedColor,
);

void main() {
  runApp(
    const ProviderScope(
      child: DndAssistant(),
    ),
  );
}

/// Root application widget.
class DndAssistant extends StatelessWidget {
  /// Creates the DnD assistant app.
  const DndAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DnD 5e Assistant',
      theme: _buildTheme(_lightColorScheme),
      darkTheme: _buildTheme(_darkColorScheme),
      home: const TabsScreen(),
    );
  }
}

ThemeData _buildTheme(ColorScheme colorScheme) {
  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
  );

  return baseTheme.copyWith(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: colorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSecondaryContainer,
      ),
    ),
    textTheme: baseTheme.textTheme.copyWith(
      titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSecondaryContainer,
      ),
    ),
  );
}
