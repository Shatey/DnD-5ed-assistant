import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/screens/statuses_screen.dart';
import 'package:initiative_support/services/initiative_db.dart';
import 'package:initiative_support/widgets/initiative/initiative_actions/new_initiative_item.dart';
import 'package:initiative_support/widgets/initiative/initiative_list/initiative_list.dart';
import 'package:initiative_support/widgets/main_drawer.dart';

/// Main combat tracker screen.
///
/// Shows the current combat round, active participants, and actions for adding
/// or clearing initiative entries.
class Initiative extends ConsumerStatefulWidget {
  /// Creates the initiative screen.
  const Initiative({super.key});

  @override
  ConsumerState<Initiative> createState() => _InitiativeState();
}

class _InitiativeState extends ConsumerState<Initiative> {
  int _round = 1;

  @override
  void initState() {
    super.initState();
    ref.read(initiativeProvider.notifier).loadInitiativeItems();
  }

  Future<void> _saveNewCharacter(InitiativeItemModel item) async {
    await ref.read(initiativeProvider.notifier).addInitiativeItem(item);
  }

  void _sortItems() {
    final nextRound = ref.read(initiativeProvider.notifier).normalizeRound(_round);

    setState(() {
      _round = nextRound;
    });
  }

  Future<void> _clear() async {
    await ref.read(initiativeProvider.notifier).clearInitiative();
    setState(() {
      _round = 1;
    });
  }

  void _openAddItemOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewInitiativeItem(save: _saveNewCharacter),
    );
  }

  void _openConfirmationAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Очистить арену?'),
        content: const Text('Все участники текущей боевой сцены будут удалены.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton.tonal(
            onPressed: () async {
              await _clear();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  void _removeInitiativeItem(InitiativeItemModel initiativeItemModel) {
    final characters = ref.read(initiativeProvider);
    final characterIndex = characters.indexOf(initiativeItemModel);
    final currentRound = _round;

    setState(() {
      characters.remove(initiativeItemModel);
      if (characters.isEmpty) _round = 1;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${initiativeItemModel.name} удалён'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              characters.insert(characterIndex, initiativeItemModel);
              _round = currentRound;
            });
          },
        ),
      ),
    );
  }

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
    final characters = ref.watch(initiativeProvider);
    final mainContent = characters.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Боевая арена пуста!\nДобавьте игроков и монстров.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : InitiativeList(
            initiativeItems: characters,
            sort: _sortItems,
            onRemoveInitiativeItem: _removeInitiativeItem,
          );

    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setScreen),
      appBar: AppBar(
        title: Text('Раунд $_round'),
        actions: [
          if (characters.isNotEmpty)
            IconButton(
              tooltip: 'Очистить арену',
              onPressed: _openConfirmationAlert,
              icon: const Icon(Icons.delete_outline),
            ),
          IconButton(
            tooltip: 'Добавить участника',
            onPressed: _openAddItemOverlay,
            icon: const Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
      body: SafeArea(child: mainContent),
    );
  }
}
