import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'tabs/members/members_view.dart';
import 'tabs/map/map_view.dart';
import 'tabs/places/places_view.dart';
import 'tabs/settings/settings_view.dart';
import 'tabs/history/history_view.dart';

class TabView extends StatefulWidget {
  final int activeTab;
  TabView({this.activeTab = 2});
  @override
  State<StatefulWidget> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _activeTab = 2;

  @override
  void initState() {
    setState(() {
      _activeTab = widget.activeTab;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _activeTab,
          children: [
            MembersView(),
            PlacesView(),
            MapView(),
            HistoryView(),
            SettingsView()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) => setState(() => _activeTab = i),
        currentIndex: _activeTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.users), label: "Members"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.building), label: "Places"),
          BottomNavigationBarItem(icon: Icon(Icons.location_pin), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
      ),
    );
  }
}
