import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:prms/main.dart';
import 'package:prms/utility/prms_data_check.dart';
import 'package:prms/widgets/binding_prms_card.dart';
import 'package:prms/widgets/global_nav_bar.dart';
import 'package:prms/widgets/global_nav_bar_export.dart';
import 'package:prms/widgets/toast_util.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'main_page.dart';

class PageTakeOffFlow extends StatefulWidget {
  final GlobalKey<GlobalNavBarState>? navBarKey;
  const PageTakeOffFlow({super.key, this.navBarKey});

  @override
  State<PageTakeOffFlow> createState() => _PageTakeOffFlowState();
}

class _PageTakeOffFlowState extends State<PageTakeOffFlow> {
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
  // User , Machine , Old_PR , Old_Tube
  String page_stage = "User"; // User , Machine , Old_PR , Old_Tube , Complete
  //String p_user_id = "220653 / HHCHENX"; // 220653
  String p_user_id = ""; // 220653
  String p_machine_id = "";
  String p_old_pr_id = "";
  String p_old_tube_id = "";

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
        p_machine_id.isNotEmpty &&
        p_old_pr_id.isNotEmpty &&
        p_old_tube_id.isNotEmpty) {
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
              page_stage = "Machine";
            });
          }
        } else if (page_stage == "Machine") {
          // 当符合 Machine ID 的格式时，才会更新 p_machine_id
          // 以M開頭+5位數字，可依實際需求調整
          if (PrmsDataCheck.isValidMachineId(scanContent)) {
            setState(() {
              p_machine_id = scanContent;
              page_stage = "Old_PR";
            });
          }
        } else if (page_stage == "Old_PR") {
          // 当符合 Old PR ID 的格式时，才会更新 p_old_pr_id
          // PR開頭+6位數字，可依實際需求調整
          if (PrmsDataCheck.isValidPrId(scanContent)) {
            setState(() {
              p_old_pr_id = scanContent;
              page_stage = "Old_Tube";
            });
          }
        } else if (page_stage == "Old_Tube") {
          // 当符合 Old Tube ID 的格式时，才会更新 p_old_pr_id
          // TUBE開頭+6位數字，可依實際需求調整
          if (PrmsDataCheck.isValidTubeId(scanContent)) {
            setState(() {
              p_old_tube_id = scanContent;
              page_stage = "Old_Tube";
            });
          }
        }
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
                                child: Text(
                                  'Flow Stage ( Take Off The Flow ) :',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                    fontWeight: FontWeight.w600,
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
                                    icon:
                                        CupertinoIcons
                                            .gear_big, // 更贴合“机台/生产设备”的图标
                                    label: 'Machine',
                                    selected: page_stage == "Machine",
                                    onTap: () {
                                      setState(() {
                                        page_stage = "Machine";
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
                                              page_stage == "Old_PR"
                                                  ? Color(
                                                    0xFFB8860B,
                                                  ) // 深金色/棕色，代表“旧”
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          CupertinoIcons.barcode,
                                          size: 16,
                                          color:
                                              page_stage == "Old_PR"
                                                  ? Color(0xFFB8860B) // 同上
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                    label: 'Old PR',
                                    selected: page_stage == "Old_PR",
                                    onTap: () {
                                      setState(() {
                                        page_stage = "Old_PR";
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
                                          CupertinoIcons.arrow_merge,
                                          size: 16,
                                          color:
                                              page_stage == "Old_Tube"
                                                  ? Color(
                                                    0xFFB8860B,
                                                  ) // 深金色/棕色，代表“旧”
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          CupertinoIcons.barcode,
                                          size: 16,
                                          color:
                                              page_stage == "Old_Tube"
                                                  ? Color(0xFFB8860B) // 同上
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                    label: 'Old Tube',
                                    selected: page_stage == "Old_Tube",
                                    onTap: () {
                                      setState(() {
                                        page_stage = "Old_Tube";
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
                                final dashWidth = 3.0;
                                final dashSpace = 4.0;
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                page_stage == "User"
                                    ? const Icon(
                                      CupertinoIcons.person,
                                      size: 28,
                                      color: CupertinoColors.activeBlue,
                                    )
                                    : page_stage == "Machine"
                                    ? const Icon(
                                      CupertinoIcons.gear_alt, // 设备图标
                                      size: 28,
                                      color: CupertinoColors.activeBlue,
                                    )
                                    : page_stage == "Old_PR"
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.drop_fill,
                                          size: 24,
                                          color:
                                              page_stage == "Old_PR"
                                                  ? Color(0xFFB8860B)
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          CupertinoIcons.barcode,
                                          size: 24,
                                          color:
                                              page_stage == "Old_PR"
                                                  ? Color(0xFFB8860B)
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                      ],
                                    )
                                    : page_stage == "Old_Tube"
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          CupertinoIcons.arrow_merge,
                                          size: 24,
                                          color:
                                              page_stage == "Old_Tube"
                                                  ? Color(0xFFB8860B)
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          CupertinoIcons.barcode,
                                          size: 24,
                                          color:
                                              page_stage == "Old_Tube"
                                                  ? Color(0xFFB8860B)
                                                  : Color(
                                                    0xFFB8860B,
                                                  ).withOpacity(0.7),
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
                                          size: 24,
                                          color:
                                              page_stage == "Complete"
                                                  ? Color(0xFF1E90FF)
                                                  : Color(
                                                    0xFF1E90FF,
                                                  ).withOpacity(0.7),
                                        ),
                                      ],
                                    )
                                    : const Icon(
                                      CupertinoIcons.add_circled,
                                      size: 28,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                SizedBox(width: 4),
                                Text(
                                  page_stage == "User"
                                      ? 'Scan the barcode on your employee ID card.'
                                      : page_stage == "Machine"
                                      ? 'Scan the barcode on the machine.'
                                      : page_stage == "Old_PR"
                                      ? 'Scan the barcode on the old PR Bottle.'
                                      : page_stage == "Old_Tube"
                                      ? 'Scan the barcode on the tuble (pipeline).'
                                      : '',
                                  style: TextStyle(fontSize: 14),
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
                                            'Machine Id',
                                            p_machine_id,
                                            CupertinoIcons.gear_alt,
                                          ),
                                          _buildDivider(),
                                          _buildInfoRowStyled(
                                            'Old PR Id',
                                            p_old_pr_id,
                                            CupertinoIcons.drop_fill,
                                            color: Color(0xFFB8860B),
                                          ),
                                          _buildDivider(),
                                          _buildInfoRowStyled(
                                            'Old Tube Id',
                                            p_old_tube_id,
                                            CupertinoIcons.arrow_merge,
                                            color: Color(0xFFB8860B),
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
                                    'Scanner visibility: ${visibleFraction * 100}%',
                                  );

                                  if (visibleFraction > 0) {
                                    debugPrint(
                                      'Scanner is visible, starting camera...',
                                    );
                                    _scannerController.start().catchError((
                                      error,
                                    ) {
                                      debugPrint(
                                        'Error starting camera: $error',
                                      );
                                    });
                                  } else {
                                    debugPrint(
                                      'Scanner is not visible, stopping camera...',
                                    );
                                    _scannerController.stop();
                                  }
                                },

                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRect(
                                          // 使用ClipRect裁剪超出邊界部分
                                          child: SizedBox(
                                            width: deviceSize.width,
                                            height:
                                                deviceSize.height *
                                                0.4, // 限制高度比例
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 60,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      4,
                                                    ), // 可选：圆角
                                                child: MobileScanner(
                                                  controller:
                                                      _scannerController,
                                                  fit: BoxFit.cover, // 填满整个区域
                                                  onDetect: _handleScan,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 新增：左上角閃光燈按鈕
                                        Positioned(
                                          top: 16.0,
                                          left: 16.0,
                                          child: CupertinoButton(
                                            padding: const EdgeInsets.all(8.0),
                                            color: CupertinoColors.black
                                                .withValues(
                                                  red: 0,
                                                  green: 0,
                                                  blue: 0,
                                                  alpha: 0.5,
                                                ),
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
                                    // Container(
                                    //   //螢幕中的綠匡(全景掃描不需要)
                                    //   width: scanAreaSize,
                                    //   height: scanAreaSize * 0.8,
                                    //   decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //         color: CupertinoColors.activeGreen, width: 2),
                                    //     borderRadius: BorderRadius.circular(12),
                                    //   ),
                                    // ),
                                  ],
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
                        child: Text(
                          page_stage == "User" && p_user_id.isNotEmpty
                              ? 'User Id : ${p_user_id}'
                              : page_stage == "Machine" &&
                                  p_machine_id.isNotEmpty
                              ? 'Machine Id : ${p_machine_id}'
                              : page_stage == "Old_PR" && p_old_pr_id.isNotEmpty
                              ? 'Old PR Id : ${p_old_pr_id}'
                              : page_stage == "Old_Tube" &&
                                  p_old_tube_id.isNotEmpty
                              ? 'Old Tube Id : ${p_old_tube_id}'
                              : '',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 255),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
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

  // 新增表单行构建方法
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: CupertinoColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
}
