import 'package:flutter/cupertino.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: CupertinoColors.systemGrey4,
      margin: const EdgeInsets.symmetric(vertical: 0),
    );
  }
}
