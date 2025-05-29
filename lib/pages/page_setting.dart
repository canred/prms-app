import 'package:flutter/cupertino.dart';
import '../widgets/global_nav_bar.dart';
import '../pages/main_page.dart';

/// 主頁籤：QR 碼與條碼掃描
class SettingTab extends StatefulWidget {
  const SettingTab({super.key});

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  /// 控制相機掃描功能的控制器

  @override
  /// 初始化頁面狀態
  void initState() {
    super.initState();
    // Hide the globalNavBar when this tab is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        globalNavBarKey.currentState?.setNavBarVisible(false);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    // Restore the globalNavBar when leaving this tab
    try {
      globalNavBarKey.currentState?.setNavBarVisible(true);
    } catch (_) {}
    super.dispose();
  }

  @override
  /// Build a lively and clear system settings UI
  Widget build(BuildContext context) {
    // Example data, replace with real data as needed
    const userName = 'John Doe';
    const userEmail = 'john.doe@example.com';
    const backendHost = 'api.prms.com';
    const systemVersion = 'v1.2.3';
    const developer = 'PRMS Dev Team';
    const supportContact = 'support@prms.com / +1-800-123-4567';

    final List<_SettingItem> items = [
      _SettingItem(
        'User Account',
        userName,
        CupertinoIcons.person,
        CupertinoColors.activeBlue,
      ),
      _SettingItem(
        'Email',
        userEmail,
        CupertinoIcons.mail,
        CupertinoColors.systemGreen,
      ),
      _SettingItem(
        'Backend Host',
        backendHost,
        CupertinoIcons.cloud,
        CupertinoColors.systemPurple,
      ),
      _SettingItem(
        'System Version',
        systemVersion,
        CupertinoIcons.info,
        CupertinoColors.systemOrange,
      ),
      _SettingItem(
        'Developer',
        developer,
        CupertinoIcons.person_2,
        CupertinoColors.systemPink,
      ),
      _SettingItem(
        'Support Contact',
        supportContact,
        CupertinoIcons.phone,
        CupertinoColors.systemRed,
      ),
    ];

    // Use a CupertinoPageScaffold without navigationBar for this tab
    return CupertinoPageScaffold(
      navigationBar: null,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(
                    CupertinoIcons.gear_solid,
                    size: 32,
                    color: CupertinoColors.activeBlue,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'System Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.10),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    return Column(
                      children: [
                        _livelyInfoRow(item),
                        if (i != items.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              height: 1,
                              color: CupertinoColors.systemGrey4,
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Enjoy your PRMS experience! 🎉',
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '© 2025 PRMS. All Rights Reserved',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lively info row with colored icon and clear layout
  Widget _livelyInfoRow(_SettingItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: item.iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(item.icon, color: item.iconColor, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Data class for settings item
class _SettingItem {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  const _SettingItem(this.title, this.value, this.icon, this.iconColor);
}
