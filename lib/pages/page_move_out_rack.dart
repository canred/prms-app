// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:prms/utility/prms_data_check.dart';
import 'package:prms/widgets/global_nav_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'main_page.dart';
import 'package:flutter/material.dart';

class PageMoveOutRack extends StatefulWidget {
  final GlobalKey<GlobalNavBarState>? navBarKey;
  const PageMoveOutRack({super.key, this.navBarKey});

  @override
  State<PageMoveOutRack> createState() => _PageMoveOutRackState();
}

class _PageMoveOutRackState extends State<PageMoveOutRack> {
  /// 控制相機掃描功能的控制器
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    // 使用1080p解析度，以16:9比例顯示相機畫面，iphone上不需設定改為null
    cameraResolution: null,
    // 不指定formats參數，讓掃描器支援所有類型的條碼
  );

  final Key _scannerVisibilityKey = UniqueKey();

  // 分别为5个阶段的处理作业
  // User , PR , Rack
  String page_stage =
      "User"; // User , Machine , Old_PR , Old_Tube , New_PR, New_Tube , Complete
  //String p_user_id = "220653 / HHCHENX"; // 220653
  String p_user_id = "";
  List<String> p_pr = <String>[];
  String p_rack_id = "";

  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    // 為 VisibilityDetector 新增一個唯一的 Key

    // Flutter 没有 afterLoad 生命周期，但可以用 addPostFrameCallback 实现类似效果
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterLoad();
    });
  }

  void _afterLoad() {
    // 通过 globalNavBarKey.currentState 调用 setTitle
    globalNavBarKey.currentState?.setTitle('PRMS APP pageFun1');
  }

  checkStage() {
    if (p_user_id.isNotEmpty &&
        p_pr[0].trim().isNotEmpty &&
        p_rack_id.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// 處理掃描結果，支援單次與連續模式，並彈出對話框或更新畫面
  void _handleScan(BarcodeCapture barcodes) {
    // 加入冷卻時間判斷，避免因為相機畫面殘影、手抖、或多條碼同時入鏡時，短時間內重複觸發掃描
    // final now = DateTime.now();
    // if (_lastScanTime != null &&
    //     now.difference(_lastScanTime!).inMilliseconds < 1000) {
    //   debugPrint('冷卻中，忽略本次掃描');
    //   return;
    // }
    // _lastScanTime = now;

    // // 在單次掃描模式下，如果已經掃描過，則忽略
    // if (!_isContinuousScanMode && _hasScanned) {
    //   debugPrint('單次掃描已完成，忽略新的掃描結果');
    //   return;
    // }

    for (final barcode in barcodes.barcodes) {
      if (barcode.rawValue != null) {
        final scanContent = barcode.rawValue!;
        debugPrint('掃描結果: $scanContent');
        if (page_stage == "User") {
          // 当符合 员工ID 的格式时，才会更新 p_user_id
          // scanContent 必須是6位數字，
          if (PrmsDataCheck.isValidUserId(scanContent)) {
            setState(() {
              p_user_id = scanContent;
              page_stage = "PR";
            });
          }
        } else if (page_stage == "PR") {
          // 当符合 Machine ID 的格式时，才会更新 p_machine_id
          // 以M開頭+5位數字，可依實際需求調整
          if (PrmsDataCheck.isValidPrId(scanContent)) {
            setState(() {
              p_pr.add(scanContent);
            });
          }
        } else if (page_stage == "Rack") {
          // 当符合 Old PR ID 的格式时，才会更新 p_old_pr_id
          // PR開頭+6位數字，可依實際需求調整
          if (PrmsDataCheck.isVaildRackId(scanContent)) {
            setState(() {
              p_rack_id = scanContent;
              page_stage = "Complete";
            });
          }
        }

        // 在這裡可以根據需要處理掃描結果，例如顯示對話框或更新畫面
        // showDialog(
        //   context: context,
        //   builder: (context) => CupertinoAlertDialog(
        //     title: const Text('掃描結果'),
        //     content: Text(scanContent),
        //     actions: [
        //       CupertinoDialogAction(
        //         child: const Text('確定'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ],
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: screenWidth * 0.006,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4.0,
                                  bottom: 4.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.systemGrey3,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Flow Stage ( Move Out Rack )',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: CupertinoColors.activeBlue,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStageButton(
                                    context,
                                    icon: CupertinoIcons.person,
                                    label: 'User',
                                    selected: page_stage == "User",
                                    onTap: () {
                                      setState(() {
                                        page_stage = "User";
                                      });
                                    },
                                    height: 56,
                                  ),
                                  _buildStageButton(
                                    context,
                                    iconWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.drop_fill,
                                          size: 16,
                                          color:
                                              page_stage == "PR"
                                                  ? Color(
                                                    0xFF1E90FF,
                                                  ) // Dodger Blue，代表“新”
                                                  : Color(
                                                    0xFF1E90FF,
                                                  ).withOpacity(0.7),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          CupertinoIcons.barcode,
                                          size: 16,
                                          color:
                                              page_stage == "PR"
                                                  ? Color(0xFF1E90FF) // 同上
                                                  : Color(
                                                    0xFF1E90FF,
                                                  ).withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                    label: 'PR',
                                    selected: page_stage == "PR",
                                    onTap: () {
                                      setState(() {
                                        page_stage = "PR";
                                      });
                                    },
                                    height: 56,
                                  ),
                                  _buildStageButton(
                                    context,
                                    iconWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inventory_2,
                                          size: 16,
                                          color:
                                              page_stage == "Rack"
                                                  ? Color(0xFF1E90FF) // 同上
                                                  : Color(
                                                    0xFF1E90FF,
                                                  ).withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                    label: 'Rack',
                                    selected: page_stage == "Rack",
                                    onTap: () {
                                      setState(() {
                                        page_stage = "Rack";
                                      });
                                    },
                                    height: 56,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 加入灰色dash样式的水平线
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final dashWidth = 1.5; // 更细腻
                                final dashSpace = 2.0; // 间距更小
                                final dashCount =
                                    (constraints.maxWidth /
                                            (dashWidth + dashSpace))
                                        .floor();
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(dashCount, (_) {
                                    return Container(
                                      width: dashWidth,
                                      height: 1,
                                      color: const Color(0xFF888888), // 深一点的灰色
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 当前阶段提示区域优化
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // 阶段图标
                                      page_stage == "User"
                                          ? const Icon(
                                            CupertinoIcons.person,
                                            size: 32,
                                            color: CupertinoColors.activeBlue,
                                          )
                                          : page_stage == "PR"
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons.drop_fill,
                                                size: 28,
                                                color: Color(0xFF1E90FF),
                                              ),
                                              SizedBox(width: 2),
                                              Icon(
                                                CupertinoIcons.barcode,
                                                size: 28,
                                                color: Color(0xFF1E90FF),
                                              ),
                                            ],
                                          )
                                          : page_stage == "Rack"
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.inventory_2,
                                                size: 28,
                                                color: Color(0xFF1E90FF),
                                              ),
                                            ],
                                          )
                                          : page_stage == "Complete"
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .check_mark_circled_solid,
                                                size: 28,
                                                color: Color(0xFF1E90FF),
                                              ),
                                            ],
                                          )
                                          : const Icon(
                                            CupertinoIcons.add_circled,
                                            size: 32,
                                            color: CupertinoColors.activeBlue,
                                          ),
                                      SizedBox(width: 10),
                                      // 阶段提示语
                                      Flexible(
                                        child: Text(
                                          page_stage == "User"
                                              ? 'Scan the barcode on your employee ID card.'
                                              : page_stage == "PR"
                                              ? 'Scan the barcode on the PR Bottle.'
                                              : page_stage == "Rack"
                                              ? 'Scan the barcode on the Rack.'
                                              : page_stage == "Complete"
                                              ? 'Complete, Below List to confirm.'
                                              : '',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: CupertinoColors.activeBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                page_stage == "Complete"
                                    ? EdgeInsets.only(bottom: 0.0)
                                    : EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              page_stage == "Complete"
                                  ? ""
                                  : 'Scan your barcode or QR code in the box.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color.fromARGB(255, 222, 60, 60),
                              ),
                            ),
                          ),

                          // 我要加入 MobileScanner 功能
                          page_stage == "Complete"
                              ? Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.systemGrey4
                                          .withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Consume Information',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: CupertinoColors.activeBlue,
                                        letterSpacing: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: CupertinoColors.systemGrey
                                                .withOpacity(0.18),
                                            offset: Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: CupertinoColors.systemGrey4
                                                .withOpacity(0.12),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: CupertinoColors.systemGrey4,
                                          width: 0.7,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildInfoRowStyled(
                                            'User Id',
                                            p_user_id,
                                            CupertinoIcons.person,
                                          ),
                                          _buildDivider(),
                                          _buildInfoRowStyled(
                                            'PR',
                                            p_pr.join(', '),
                                            CupertinoIcons.gear_alt,
                                          ),
                                          _buildDivider(),

                                          _buildInfoRowStyled(
                                            'Rack Id',
                                            p_rack_id,
                                            CupertinoIcons.drop_fill,
                                            color: Color(0xFF1E90FF),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 28),
                                    Center(
                                      child: SizedBox(
                                        width: 200,
                                        child: GestureDetector(
                                          onTapDown:
                                              (_) => setState(
                                                () => _isButtonPressed = true,
                                              ),
                                          onTapUp:
                                              (_) => setState(
                                                () => _isButtonPressed = false,
                                              ),
                                          onTapCancel:
                                              () => setState(
                                                () => _isButtonPressed = false,
                                              ),
                                          onTap: () {
                                            // TODO: 在这里处理确认逻辑
                                          },
                                          child: AnimatedScale(
                                            scale:
                                                _isButtonPressed == true
                                                    ? 0.96
                                                    : 1.0,
                                            duration: Duration(
                                              milliseconds: 80,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    CupertinoColors.activeBlue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: CupertinoColors
                                                        .systemGrey4
                                                        .withOpacity(0.18),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .paperplane_fill,
                                                    color:
                                                        CupertinoColors.white,
                                                    size: 32,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Confrim & Submit',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          CupertinoColors.white,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : VisibilityDetector(
                                key: _scannerVisibilityKey,
                                onVisibilityChanged: (visibilityInfo) {
                                  if (!mounted) return;
                                  final visibleFraction =
                                      visibilityInfo.visibleFraction;
                                  debugPrint(
                                    'Scanner visibility: \\${visibleFraction * 100}%',
                                  );
                                  if (visibleFraction > 0) {
                                    debugPrint(
                                      'Scanner is visible, starting camera...',
                                    );
                                    _scannerController.start().catchError((
                                      error,
                                    ) {
                                      debugPrint(
                                        'Error starting camera: \\${error}',
                                      );
                                    });
                                  } else {
                                    debugPrint(
                                      'Scanner is not visible, stopping camera...',
                                    );
                                    _scannerController.stop();
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    width: deviceSize.width * 0.85,
                                    height: deviceSize.height * 0.36,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGrey6
                                          .withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: CupertinoColors.systemGrey4
                                              .withOpacity(0.18),
                                          blurRadius: 16,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          child: MobileScanner(
                                            controller: _scannerController,
                                            fit: BoxFit.cover,
                                            onDetect: _handleScan,
                                          ),
                                        ),
                                        // 四角高亮
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: _buildCornerDecoration(
                                            alignment: Alignment.topLeft,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: _buildCornerDecoration(
                                            alignment: Alignment.topRight,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: _buildCornerDecoration(
                                            alignment: Alignment.bottomLeft,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: _buildCornerDecoration(
                                            alignment: Alignment.bottomRight,
                                          ),
                                        ),
                                        // 闪光灯按钮
                                        Positioned(
                                          top: 16.0,
                                          left: 16.0,
                                          child: CupertinoButton(
                                            padding: const EdgeInsets.all(8.0),
                                            color: CupertinoColors.black
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                            onPressed:
                                                () =>
                                                    _scannerController
                                                        .toggleTorch(),
                                            child: Icon(
                                              CupertinoIcons.bolt_fill,
                                              size: deviceSize.width * 0.06,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 16.0,
                          left: screenWidth * 0.1,
                          right: screenWidth * 0.1,
                        ),
                        child: _buildBottomInfo(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {
      _scannerController.stop();
    } catch (e) {
      debugPrint('Error stopping camera: $e');
    }
    _scannerController.dispose();
    super.dispose();
  }

  // 新增iOS风格按钮构建方法
  Widget _buildStageButton(
    BuildContext context, {
    IconData? icon,
    Widget? iconWidget,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    double height = 48, // 新增height参数，默认48
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: SizedBox(
          height: height, // 统一高度
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            color:
                selected
                    ? const Color(0xFF204080)
                    : CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(8),
            onPressed: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconWidget ??
                    Icon(
                      icon,
                      size: 22,
                      color:
                          selected
                              ? CupertinoColors.white
                              : CupertinoColors.activeBlue,
                    ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        selected
                            ? CupertinoColors.white
                            : CupertinoColors.systemGrey,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 專業iOS表單行（帶圖標與顏色）
  Widget _buildInfoRowStyled(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: color ?? CupertinoColors.systemGrey),
          SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: CupertinoColors.label,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 專業iOS分隔線
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      height: 1,
      color: CupertinoColors.systemGrey5,
    );
  }

  // 优化底部信息显示，减少重复判断
  Widget _buildBottomInfo() {
    String info = '';
    if (page_stage == "User" && p_user_id.isNotEmpty) {
      info = 'User Id : ' + p_user_id;
    } else if (page_stage == "PR" && p_pr.isNotEmpty) {
      info = 'PR : ' + p_pr.join(', ');
    } else if (page_stage == "Rack" && p_rack_id.isNotEmpty) {
      info = 'Rack : ' + p_rack_id;
    }
    if (info.isEmpty) return const SizedBox.shrink();
    return Text(
      info,
      style: const TextStyle(
        color: Color(0xFF204080), // 柔和蓝色
        fontSize: 20.0, // 更大
        fontWeight: FontWeight.w600, // 半粗体
        letterSpacing: 0.5,
        shadows: [
          Shadow(color: Color(0x22000000), offset: Offset(0, 1), blurRadius: 2),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  // 四角高亮装饰方法
  Widget _buildCornerDecoration({required Alignment alignment}) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                        alignment == Alignment.topRight
                    ? BorderSide(color: CupertinoColors.activeBlue, width: 4)
                    : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                        alignment == Alignment.bottomLeft
                    ? BorderSide(color: CupertinoColors.activeBlue, width: 4)
                    : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                        alignment == Alignment.bottomRight
                    ? BorderSide(color: CupertinoColors.activeBlue, width: 4)
                    : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                        alignment == Alignment.bottomRight
                    ? BorderSide(color: CupertinoColors.activeBlue, width: 4)
                    : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft:
                alignment == Alignment.topLeft
                    ? Radius.circular(18)
                    : Radius.zero,
            topRight:
                alignment == Alignment.topRight
                    ? Radius.circular(18)
                    : Radius.zero,
            bottomLeft:
                alignment == Alignment.bottomLeft
                    ? Radius.circular(18)
                    : Radius.zero,
            bottomRight:
                alignment == Alignment.bottomRight
                    ? Radius.circular(18)
                    : Radius.zero,
          ),
        ),
      ),
    );
  }
}
