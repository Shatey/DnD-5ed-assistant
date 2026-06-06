import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_support/screens/initiative.dart';
import 'package:initiative_support/services/initiative_db.dart';

class _TestInitiativeNotifier extends InitiativeNotifier {
  @override
  Future<void> loadInitiativeItems() async {
    state = const [];
  }
}

void main() {
  testWidgets('Initiative screen renders empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initiativeProvider.overrideWith((ref) => _TestInitiativeNotifier()),
        ],
        child: const MaterialApp(
          home: Initiative(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline_outlined), findsOneWidget);
  });
}
