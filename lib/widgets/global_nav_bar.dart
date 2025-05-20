import 'package:flutter/cupertino.dart';

class GlobalNavBar extends StatefulWidget
    implements ObstructingPreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool showBorder;
  final Widget? leading;
  final Widget? trailing;

  const GlobalNavBar({
    super.key,
    required this.title,
    this.backgroundColor = CupertinoColors.systemBackground,
    this.showBorder = false,
    this.leading,
    this.trailing,
  });

  @override
  State<GlobalNavBar> createState() => GlobalNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}

class GlobalNavBarState extends State<GlobalNavBar> {
  late String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
  }

  void setTitle(String newTitle) {
    setState(() {
      _title = newTitle;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {}); // 强制刷新画面
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(
        _title,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
      backgroundColor: widget.backgroundColor,
      border: widget.showBorder ? null : Border.all(style: BorderStyle.none),
      leading: widget.leading,
      trailing: widget.trailing,
    );
  }
}

// 检查是否有 PRMS 字样，若有则替换为 prms
