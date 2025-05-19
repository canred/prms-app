import 'package:flutter/cupertino.dart';
import 'package:viscanner/services/mqtt_service.dart';
import 'package:viscanner/pages/page_fun1.dart';

class BindingPrmsCard extends StatefulWidget {
  const BindingPrmsCard({super.key});

  @override
  State<BindingPrmsCard> createState() => _BindingPCCardState();
}

class _BindingPCCardState extends State<BindingPrmsCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: 15.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF), // 更清晰的iOS风格淡灰蓝底色
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.10),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 更换光阻液
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.arrow_down_circle,
                  label: 'Consume',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PageFun1(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6),
                // 光阻液上防爆柜
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.cube_box,
                  label: 'Move In Rack',
                  onPressed: () {
                    print('Button 2 clicked');
                  },
                ),
                SizedBox(height: 6),
                // 光阻液下防爆柜
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.cube_box_fill,
                  label: 'Move Out Rack',
                  onPressed: () {
                    print('Button 3 clicked');
                  },
                ),
                SizedBox(height: 6),
                // 光阻液上机
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.arrow_up_right_square,
                  label: 'Put On Flow',
                  onPressed: () {
                    print('Button 4 clicked');
                  },
                ),
                SizedBox(height: 6),
                // 光阻液下机
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.arrow_down_right_square,
                  label: 'Take Off Flow',
                  onPressed: () {
                    print('Button 5 clicked');
                  },
                ),
                SizedBox(height: 6),
                // 光阻液解除 Alert
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.clear_circled,
                  label: 'Clean Flow',
                  onPressed: () {
                    print('Button 6 clicked');
                  },
                ),
                SizedBox(height: 6),
                // 计算最后一个按钮和底部版权信息之间的剩余空间
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                  child: Text(
                    'Copyright © 2025 VIS,VSMC. All rights reserved.',
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey3, width: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CupertinoButton(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: CupertinoColors.activeBlue, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.right_chevron,
              color: CupertinoColors.systemGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
