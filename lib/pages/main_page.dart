import 'package:flutter/cupertino.dart';
import 'package:viscanner/pages/settings_page.dart';
import 'package:viscanner/pages/home_page.dart';
import '../widgets/tab_bar.dart'; // 引入 CustomTabBar
import 'scan_history_page.dart';
import 'qr_scanner.dart';
import 'package:viscanner/widgets/global_nav_bar.dart';

final GlobalKey<GlobalNavBarState> globalNavBarKey =
    GlobalKey<GlobalNavBarState>();
GlobalNavBar globalNavBar = GlobalNavBar(key: globalNavBarKey, title: '首頁');

class MainPage extends StatefulWidget {
  final String title;
  final int initialTabIndex;

  //late GlobalNavBar _GlobalNavBar;

  MainPage({
    required this.title,
    this.initialTabIndex = 0, // 預設為首頁(索引0)
    super.key,
  });

  @override
  State<MainPage> createState() => _PartsPageState();
}

class _PartsPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // 使用 widget.initialTabIndex 作為初始標籤索引
    _selectedIndex = widget.initialTabIndex;
    globalNavBar = GlobalNavBar(title: "PRMS APP");
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: globalNavBar,
      child: CupertinoTabScaffold(
        tabBar: CustomTabBar(currentIndex: _selectedIndex, onTap: _onTabTapped),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return const HomePage();
                case 1:
                  return const QRscanTab();
                case 2:
                  return const ScanHistoryPage();
                case 3:
                  return const SettingsScreen();
                default:
                  return const HomePage();
              }
            },
          );
        },
      ),
    );
  }
}
