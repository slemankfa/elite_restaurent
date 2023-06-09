import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/screens/auth_pages/start_page.dart';
import 'package:elite/screens/map_pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'profile_pages/profile_page.dart';

class MainTabsPage extends StatefulWidget {
  const MainTabsPage({super.key});

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();

  static const routeName = "/main-tabs=page";
}

class _MainTabsPageState extends State<MainTabsPage> {
  int _selectedIndex = 0;
  HelperMethods _helperMethods = HelperMethods();
  bool _isGuestUser = false;

  void _onItemTapped(int index) {
    if (_isGuestUser && index == 1) {
      Navigator.of(context).pushNamed(StartPage.routeName);
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  fetchUserProfile() async {
    final checkIsGuest = await _helperMethods.checkIsGuest();
    _isGuestUser = checkIsGuest;
    if (checkIsGuest) return;

    Provider.of<AuthProvider>(context, listen: false)
        .getUserInformation(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [MapPage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/map.svg",
              color: _selectedIndex == 0
                  ? Styles.mainColor
                  : Styles.unslectedItemColor,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/profile.svg",
              color: _selectedIndex == 1
                  ? Styles.mainColor
                  : Styles.unslectedItemColor,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Styles.mainColor,
        unselectedItemColor: Styles.unslectedItemColor,
        selectedLabelStyle:
            Styles.mainTextStyle.copyWith(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }
}
