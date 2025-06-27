import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prmsapp/widgets/user_profile_card.dart';
import 'package:provider/provider.dart';
import '../widgets/keyboard_wizard_card.dart';
import 'package:prmsapp/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SettingTab extends StatelessWidget {
  const SettingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsForm();
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  @override
  void initState() {
    super.initState();
    // 不再初始化 msal，交由 provider 處理
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    if (auth.isLoggedIn) await auth.fetchUserProfile();
                  },
                ),
                SliverToBoxAdapter(
                  child: UserProfileCard(
                    userName: auth.userName,
                    userEmail: auth.userEmail,
                    avatarBytes: auth.userAvatar,
                    mobilePhone: auth.mobilePhone ?? '',
                    officeLocation: auth.officeLocation,
                    isLoggedIn: auth.isLoggedIn,
                    onLogin: () async {
                      try {
                        await auth.signIn();
                        if (!mounted) return;
                        showCupertinoDialog(
                          context: context,
                          builder:
                              (ctx) => CupertinoAlertDialog(
                                title: const Text('Login Successful'),
                                content: Text('Welcome, ${auth.userName}!'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                ],
                              ),
                        );
                      } catch (e, stack) {
                        if (!mounted) return;

                        showCupertinoDialog(
                          context: context,
                          builder:
                              (ctx) => CupertinoAlertDialog(
                                title: const Text('Login Failed'),
                                content: Text(e.toString()),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                ],
                              ),
                        );
                      }
                    },
                    onLogout: () async {
                      await auth.signOut();
                      showCupertinoDialog(
                        context: context,
                        builder:
                            (ctx) => CupertinoAlertDialog(
                              title: const Text('Logout Successful'),
                              content: const Text('You have been logged out.'),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ),

                // 第三張卡片 - Keyboard Wizard
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    child: KeyboardWizardCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (auth.isAuthLoading)
          Positioned.fill(
            child: Container(
              color: CupertinoColors.systemGrey.withOpacity(0.3),
              child: const Center(
                child: SpinKitFadingCircle(
                  color: CupertinoColors.activeBlue,
                  size: 48.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<int> _getPrefsSize() async {
    final directory = await SharedPreferences.getInstance();
    int total = 0;
    for (final key in directory.getKeys()) {
      final value = directory.get(key);
      total += key.length;
      if (value is String) {
        total += value.length;
      } else if (value is List) {
        total += value.toString().length;
      } else if (value != null) {
        total += value.toString().length;
      }
    }
    return total;
  }

  Future<void> _clearCacheAndShowResult() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {});
    if (!mounted) return; // 再次檢查，確保 context 有效
    showCupertinoDialog(
      context: context,
      builder:
          (ctx) => CupertinoAlertDialog(
            title: const Text('Cache cleared'),
            content: const Text(
              'All cached data and error logs have been removed.',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }
}
