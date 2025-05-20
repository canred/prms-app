import 'package:flutter/cupertino.dart';

class ToastUtil {
  static void show(BuildContext context, String message) {
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 100,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey.withAlpha(220),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: CupertinoColors.white),
                ),
              ),
            ),
          ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  static void show_error(BuildContext context, String message) {
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 100,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed.withAlpha(220), // 改為紅色
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: CupertinoColors.white),
                ),
              ),
            ),
          ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
