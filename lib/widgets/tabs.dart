import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initiative_support/widgets/initiative/initiative_list/initiative.dart';
import 'package:initiative_support/widgets/main_drawer.dart';
import 'package:initiative_support/widgets/statuses/statuses_screen.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  // final int _selectedPageIndex = 0;

  // void _selectPage(int index) {
  //   setState(() {
  //     _selectedPageIndex = index;
  //   });
  // }

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
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectPage,
      //   currentIndex: _selectedPageIndex,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.set_meal),
      //       label: 'Categories',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.star),
      //       label: 'Favorites',
      //     ),
      //   ],
      // ),
    );
  }
}
