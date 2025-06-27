import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:prmsapp/widgets/divider_line.dart';

class UserProfileCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Uint8List? avatarBytes;
  final String mobilePhone;
  final String officeLocation;
  final bool isLoggedIn;
  final VoidCallback onLogin;
  final VoidCallback onLogout;

  const UserProfileCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.avatarBytes,
    required this.mobilePhone,
    required this.officeLocation,
    required this.isLoggedIn,
    required this.onLogin,
    required this.onLogout,
  });

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemGroupedBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (isLoggedIn) {
                    _showLogoutDialog(context);
                  } else {
                    onLogin();
                  }
                },
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color:
                        isLoggedIn
                            ? CupertinoColors.activeBlue.withOpacity(0.1)
                            : CupertinoColors.systemGrey5.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border:
                        isLoggedIn
                            ? null
                            : Border.all(
                              color: CupertinoColors.systemGrey5,
                              width: 2,
                            ),
                  ),
                  child:
                      isLoggedIn && avatarBytes != null
                          ? ClipOval(
                            child: Image.memory(
                              avatarBytes!,
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Icon(
                            isLoggedIn
                                ? CupertinoIcons.person_solid
                                : CupertinoIcons.person_add_solid,
                            size: isLoggedIn ? 32 : 28,
                            color:
                                isLoggedIn
                                    ? CupertinoColors.activeBlue
                                    : CupertinoColors.systemGrey,
                          ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const DividerLine(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mobilePhone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Office Location',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      officeLocation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
