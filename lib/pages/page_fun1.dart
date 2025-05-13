import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:viscanner/widgets/binding_prms_card.dart';
import 'package:viscanner/widgets/global_nav_bar.dart';
import 'package:viscanner/widgets/global_nav_bar_export.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'main_page.dart';

class PageFun1 extends StatefulWidget {
  final GlobalKey<GlobalNavBarState>? navBarKey;
  const PageFun1({super.key, this.navBarKey});

  @override
  State<PageFun1> createState() => _PageFun1State();
}

class _PageFun1State extends State<PageFun1> {
  /// 控制相機掃描功能的控制器
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    // 使用1080p解析度，以16:9比例顯示相機畫面，iphone上不需設定改為null
    cameraResolution: null,
    // 不指定formats參數，讓掃描器支援所有類型的條碼
  );

  final Key _scannerVisibilityKey = UniqueKey();
  String page_stage = "ID"; // Machine , Change, Old

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
    // for (final barcode in barcodes.barcodes) {
    //   if (barcode.rawValue != null) {
    //     final scanContent = barcode.rawValue!;
    //     final scanType = _determineScanType(scanContent);

    //     debugPrint('識別掃描類型: $scanType');
    //     debugPrint('嘗試添加掃描記錄: $scanContent');

    //     try {
    //       _historyManager.addScanRecord(scanContent, scanType);
    //       debugPrint('掃描記錄已提交到 ScanHistoryManager');
    //     } catch (e) {
    //       debugPrint('添加掃描記錄時出錯: $e');
    //     }

    //     if (_isContinuousScanMode) {
    //       setState(() {
    //         _scanResult = scanContent;
    //       });
    //       ToastUtil.show(context, ' $scanContent');
    //     } else {
    //       // 單次掃描模式
    //       if (mounted) {
    //         // 確保 widget 仍然在樹中
    //         _scannerController.stop(); // 在 setState 之前停止相機
    //         setState(() {
    //           _scanResult = scanContent;
    //           _hasScanned = true;
    //           debugPrint('UI已更新為顯示掃描結果');
    //         });
    //       }
    //     }
    //     break;
    //   }
    // }
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
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      color:
                                          page_stage == "ID"
                                              ? const Color(0xFF204080) // 深蓝色
                                              : CupertinoColors.activeBlue,
                                      onPressed: () {
                                        setState(() {
                                          page_stage = "ID";
                                          setState(() {
                                            page_stage = "ID";
                                          });
                                        });
                                      },
                                      child: const Text(
                                        'ID',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    color:
                                        page_stage == "Machine"
                                            ? const Color(0xFF204080) // 深蓝色
                                            : CupertinoColors.activeBlue,
                                    onPressed: () {
                                      page_stage = "Machine";
                                      setState(() {
                                        page_stage = "Machine";
                                      });
                                    },
                                    child: const Text(
                                      'Machine',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    color:
                                        page_stage == "Change"
                                            ? const Color(0xFF204080) // 深蓝色
                                            : CupertinoColors.activeBlue,
                                    onPressed: () {
                                      page_stage = "Change";
                                      setState(() {
                                        page_stage = "Change";
                                      });
                                    },
                                    child: const Text(
                                      'Change',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    color:
                                        page_stage == "Old"
                                            ? const Color(0xFF204080) // 深蓝色
                                            : CupertinoColors.activeBlue,
                                    onPressed: () {
                                      page_stage = "Old";
                                      setState(() {
                                        page_stage = "Old";
                                      });
                                    },
                                    child: const Text(
                                      'Old',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              page_stage == "ID"
                                  ? const Icon(
                                    CupertinoIcons.person,
                                    size: 40,
                                    color: CupertinoColors.activeBlue,
                                  )
                                  : page_stage == "Machine"
                                  ? const Icon(
                                    CupertinoIcons.device_laptop, // 设备图标
                                    size: 40,
                                    color: CupertinoColors.activeBlue,
                                  )
                                  : page_stage == "Change"
                                  ? const Icon(
                                    CupertinoIcons.cube, // 料件icon
                                    size: 40,
                                    color: CupertinoColors.activeBlue,
                                  )
                                  : const Icon(
                                    CupertinoIcons.add_circled,
                                    size: 40,
                                    color: CupertinoColors.activeBlue,
                                  ),
                              SizedBox(width: 8),
                              Text(
                                page_stage == "ID"
                                    ? 'Scan Pass ID'
                                    : page_stage == "Machine"
                                    ? 'Scan Machine ID'
                                    : page_stage == "Change"
                                    ? 'Scan Change ID'
                                    : 'Scan Old ID',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          // 我要加入 MobileScanner 功能
                          VisibilityDetector(
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
                                _scannerController.start().catchError((error) {
                                  debugPrint('Error starting camera: $error');
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
                                            deviceSize.height * 0.3, // 限制高度比例
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ), // 可选：圆角
                                            child: MobileScanner(
                                              controller: _scannerController,
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
                                        color: CupertinoColors.black.withValues(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoButton(
                                color: CupertinoColors.activeGreen,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                onPressed: () {
                                  // TODO: 按钮点击事件
                                  debugPrint('新按钮被点击');
                                },
                                child: const Text(
                                  '新按钮',
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        child: const Text(
                          'Copyright © 2025 VIS,VSMC. All rights reserved.',
                          style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 13.0,
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
}
