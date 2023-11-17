import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/services/initiativeDB.dart';
import 'package:initiative_support/widgets/initiative/initiative_actions/new_initiative_item.dart';
import 'package:initiative_support/widgets/initiative/initiative_list/initiative_list.dart';
import 'package:initiative_support/models/initiative/initiative_item_model.dart';
import 'package:initiative_support/widgets/main_drawer.dart';
import 'package:initiative_support/screens/statuses_screen.dart';

class Initiative extends ConsumerStatefulWidget {
  const Initiative({super.key});

  @override
  ConsumerState<Initiative> createState() {
    return _InitiativeState();
  }
}

class _InitiativeState extends ConsumerState<Initiative> {
  late Future<void> _initiativeItems;
  List<InitiativeItemModel> _characters = [];
  // final List<InitiativeItemModel> _characters = [
  //   InitiativeItemModel(
  //     id: 1,
  //     monsterId: -1,
  //     name: 'name1',
  //     maxHp: 11,
  //     initiative: 10,
  //     kd: 12,
  //     statuses: {'Stunned': 1, 'Down': -1, 'test': 2},
  //   ),
  //   InitiativeItemModel(
  //     id: 2,
  //     monsterId: -1,
  //     name: 'name2',
  //     maxHp: 11,
  //     initiative: 11,
  //     kd: 12,
  //     statuses: {},
  //   ),
  //   InitiativeItemModel(
  //     id: 3,
  //     monsterId: -1,
  //     name: 'name4',
  //     maxHp: 11,
  //     hasActed: true,
  //     initiative: 13,
  //     kd: 12,
  //     statuses: {},
  //   ),
  //   InitiativeItemModel(
  //     id: 4,
  //     monsterId: -1,
  //     name: 'name3',
  //     maxHp: 11,
  //     initiative: 19,
  //     kd: 12,
  //     statuses: {},
  //   ),
  // ];
  int _round = 1;

  @override
  void initState() {
    super.initState();
    _initiativeItems =
        ref.read(initiativeProvider.notifier).getInitiativeItems();
    // for (var item in _characters) {
    //   ref.read(initiativeProvider.notifier).addInitiativeItem(item);
    // }
  }

  void _saveNewCharacter(InitiativeItemModel item) {
    setState(() {
      ref.read(initiativeProvider.notifier).addInitiativeItem(item);
      // _characters.add(item);
      _sortItems();
    });
  }

  void _sortItems() {
    setState(() {
      if (_characters.every((item) => item.hasActed)) {
        for (var item in _characters) {
          item.hasActed = !item.hasActed;
          item.statuses.updateAll(
            (key, value) => value > 0 ? value - 1 : value,
          );
          item.statuses.removeWhere((key, value) => value == 0);
        }
        _round++;
      }
      if (_characters.length > 1) {
        _characters.sort((first, second) {
          if (first.hasActed == second.hasActed) {
            return second.initiative.compareTo(first.initiative);
          } else {
            return first.hasActed ? 1 : -1;
          }
        });
      }
    });
  }

  void _clear() {
    setState(() {
      _round = 1;
      _characters.clear();
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
          title: const Text('Очистить арену!'),
          content: const Text('Вы уверены, что хотите очистить арену?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _clear();
                Navigator.pop(context);
              },
              child: const Text('Ок'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ]),
    );
  }

  void _removeInitiativeItem(InitiativeItemModel initiativeItemModel) {
    final characterIndex = _characters.indexOf(initiativeItemModel);
    final currentRound = _round;
    setState(() {
      _characters.remove(initiativeItemModel);
      if (_characters.isEmpty) _round = 1;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${initiativeItemModel.name} удалён'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _characters.insert(characterIndex, initiativeItemModel);
              _round = currentRound;
            });
          }),
    ));
  }

  void _setScreen(String identifier) async {
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
    _characters = ref.watch(initiativeProvider);
    Widget mainContent = _characters.isEmpty
        ? Center(
            child: Center(
              child: Text(
                'Боевая арена пуста! \nДобавьте игроков и монстров.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : InitiativeList(
            initiativeItems: _characters,
            sort: _sortItems,
            onRemoveInitiativeItem: _removeInitiativeItem,
          );
    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setScreen),
      appBar: AppBar(
        title: Text('Раунд ${_round.toString()}'),
        actions: [
          if (_characters.isNotEmpty)
            IconButton(
              onPressed: _openConfirmationAlert,
              icon: const Icon(Icons.delete),
            ),
          IconButton(
            onPressed: _openAddItemOverlay,
            icon: const Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
