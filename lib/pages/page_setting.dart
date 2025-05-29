import 'package:flutter/cupertino.dart';

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
  }

  @override
  /// Build the system settings display: all info in a single card, professional and modern design
  Widget build(BuildContext context) {
    // Example data, replace with real data as needed
    const userName = 'John Doe';
    const userEmail = 'john.doe@example.com';
    const backendHost = 'api.prms.com';
    const systemVersion = 'v1.2.3';
    const developer = 'PRMS Dev Team';
    const supportContact = 'support@prms.com / +1-800-123-4567';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Settings',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('User Account', userName, CupertinoIcons.person),
                  const SizedBox(height: 10),
                  _infoRow('Email', userEmail, CupertinoIcons.mail),
                  const SizedBox(height: 10),
                  _infoRow('Backend Host', backendHost, CupertinoIcons.cloud),
                  const SizedBox(height: 10),
                  _infoRow(
                    'System Version',
                    systemVersion,
                    CupertinoIcons.info,
                  ),
                  const SizedBox(height: 10),
                  _infoRow('Developer', developer, CupertinoIcons.person_2),
                  const SizedBox(height: 10),
                  _infoRow(
                    'Support Contact',
                    supportContact,
                    CupertinoIcons.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                '© 2025 PRMS. All Rights Reserved',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 信息行小部件，带图标
  Widget _infoRow(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: CupertinoColors.activeBlue, size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
