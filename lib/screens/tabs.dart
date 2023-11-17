import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/screens/initiative.dart';
import 'package:initiative_support/widgets/main_drawer.dart';
import 'package:initiative_support/screens/statuses_screen.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  // late Future<void> _monstersFuture;

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
  void initState() {
    super.initState();
    // ref.read(bestiaryProvider.notifier).addBestiary(MonsterDetails(
    //       // id: 3,
    //       name: "name",
    //       size: "size",
    //       type: "type",
    //       alignment: "alignment",
    //       armorClass: "armorClass",
    //       hitPoints: "hitPoints",
    //       speed: "speed",
    //       strength: "18 (+4)",
    //       dexterity: "24 (+7)",
    //       constitution: "24 (+7)",
    //       intelligence: "16 (+3)",
    //       wisdom: "21 (+5)",
    //       charisma: "23 (+6)",
    //       damageImmunities: "damageImmunities",
    //       conditionImmunities: "conditionImmunities",
    //       savingThrows: "savingThrows",
    //       skills: "skills",
    //       senses: "senses",
    //       languages: "languages",
    //       challengeRange: "11 challengeRange",
    //       proficiencyBonus: "proficiencyBonus",
    //       source: "source",
    //       specialActions: "special Actions".split(' '),
    //       actions: "acti ons".split(' '),
    //       bonusActions: "bonus Actions".split(' '),
    //       legendaryActions: "legendary Actions".split(' '),
    //       mythicActions: "mythic Actions".split(' '),
    //       description: "descript ion".split(' '),
    //     ));
    // _monstersFuture = ref.read(bestiaryProvider.notifier).getBestiary();
    // ref.read(bestiaryProvider.notifier).clearBestiary();
  }

  @override
  Widget build(BuildContext context) {
    // final monsters = ref.watch(bestiaryProvider);
    Widget activePage = const Initiative();
    var activePageTitle = 'Боевая сцена';

    // if (_selectedPageIndex == 1) {
    //   activePage = const StatusesScreen();
    //   activePageTitle = 'Statuses';
    // }

    return Scaffold(
      appBar: activePageTitle == 'Боевая сцена'
          ? null
          : AppBar(
              title: Text(activePageTitle),
            ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
    );
  }
}
