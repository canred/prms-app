// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prms/pages/page_cumsume.dart';
import 'package:prms/pages/page_move_in_rack.dart';
import 'package:prms/pages/page_move_out_rack.dart';
import 'package:prms/pages/page_put_on_flow.dart';
import 'package:prms/pages/page_take_off_flow.dart';
import 'package:prms/pages/page_clean_flow.dart';

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
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE3F2FD), // 浅蓝色
            Color(0xFFFFFFFF), // 白色
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                  icon: CupertinoIcons.arrow_2_squarepath, // 交换/置换的合适图标
                  label: 'Consume',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PageCunsume(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6),
                // 光阻液上防爆柜
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.tray_arrow_down, // 更贴合“放进柜子”功能的图标
                  label: 'Move In Rack',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PageMoveInRack(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6),
                // 光阻液下防爆柜
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.tray_arrow_up, // 更贴合“从柜子取出”功能的图标
                  label: 'Move Out Rack',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PageMoveOutRack(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6),
                // 光阻液上机
                _buildCupertinoButtonWithIcons(
                  context,
                  icons: [
                    CupertinoIcons.arrow_up,
                    CupertinoIcons.gear,
                  ], // 上传+机台
                  label: 'Put On Flow',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PagePutOnFlow(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6),
                // 光阻液下机
                _buildCupertinoButtonWithIcons(
                  context,
                  icons: [CupertinoIcons.arrow_down, CupertinoIcons.gear],
                  label: 'Take Off Flow',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PageTakeOffFlow(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 6),
                // 光阻液解除 Alert
                _buildCupertinoButton(
                  context,
                  icon: CupertinoIcons.refresh_circled, // 更贴合“清除/重置”用途的图标
                  label: 'Clean Flow',
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const PageCleanFlow(),
                      ),
                    );
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
                      color: CupertinoColors.activeBlue, // 更活泼的蓝色
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      shadows: [
                        Shadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.2),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
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

  // 新增多icon按钮构建方法
  Widget _buildCupertinoButtonWithIcons(
    BuildContext context, {
    required List<IconData> icons,
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
            Row(
              children:
                  icons
                      .map(
                        (icon) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            icon,
                            color: CupertinoColors.activeBlue,
                            size: 22,
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(width: 8),
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
