import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: NavigationBar(
          height: 60,
          indicatorColor: Colors.black,
          backgroundColor: Colors.black,
          selectedIndex: navigationShell.currentIndex,
          destinations: [
            NavigationDestination(
                label: 'Section A',
                icon: Icon(
                  Icons.home,
                  color: navigationShell.currentIndex == 0
                      ? Colors.white
                      : Colors.grey,
                )),
            NavigationDestination(
                label: 'Section B',
                icon: Icon(
                  Icons.search,
                  color: navigationShell.currentIndex == 1
                      ? Colors.white
                      : Colors.grey,
                )),
            NavigationDestination(
                label: 'Section C',
                icon: Icon(
                  Icons.language,
                  color: navigationShell.currentIndex == 2
                      ? Colors.white
                      : Colors.grey,
                )),
            NavigationDestination(
                label: 'Section D',
                icon: Icon(
                  Icons.person_2_outlined,
                  color: navigationShell.currentIndex == 3
                      ? Colors.white
                      : Colors.grey,
                )),
          ],
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}
