import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:viscanner/widgets/scan_history_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:viscanner/widgets/toast_util.dart';

/// 主頁籤：QR 碼與條碼掃描
class QRscanTab extends StatefulWidget {
  const QRscanTab({super.key});

  @override
  State<QRscanTab> createState() => _QRscanTabState();
}

class _QRscanTabState extends State<QRscanTab> {
  /// 控制相機掃描功能的控制器
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    // 使用1080p解析度，以16:9比例顯示相機畫面，iphone上不需設定改為null
    cameraResolution: null,
    // 不指定formats參數，讓掃描器支援所有類型的條碼
  );

  /// 標記是否已經完成掃描 (主要用於單次掃描模式)
  bool _hasScanned = false;

  /// 儲存掃描得到的結果內容
  String _scanResult = '';

  /// 管理掃描歷史記錄的工具實例
  final ScanHistoryManager _historyManager = ScanHistoryManager();

  // 為 VisibilityDetector 新增一個唯一的 Key
  final Key _scannerVisibilityKey = UniqueKey();

  // 新增狀態變數
  bool _isContinuousScanMode = false;
  DateTime? _lastScanTime;

  @override

  /// 初始化頁面狀態
  void initState() {
    super.initState();
    debugPrint('QR掃描頁面初始化');
    // 載入歷史記錄以確保可以檢查重複條碼
    _historyManager.reloadHistory().then((_) {
      debugPrint('QR掃描頁面: 歷史記錄已載入，可用於判斷重複條碼');
    });
  }

  @override

  /// 停止並釋放掃描控制器
  void dispose() {
    debugPrint('QR掃描頁面 dispose');
    _scannerController.stop();
    _scannerController.dispose();
    super.dispose();
  }

  /// 根據掃描內容判斷其類型：QR Code、Barcode 或 Text
  String _determineScanType(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      return 'QR Code';
    } else if (RegExp(r'^[0-9]+$').hasMatch(content)) {
      return 'Barcode';
    } else {
      return 'Text';
    }
  }

  /// 處理掃描結果，支援單次與連續模式，並彈出對話框或更新畫面
  void _handleScan(BarcodeCapture barcodes) {
    // 加入冷卻時間判斷，避免因為相機畫面殘影、手抖、或多條碼同時入鏡時，短時間內重複觸發掃描
    final now = DateTime.now();
    if (_lastScanTime != null && now.difference(_lastScanTime!).inMilliseconds < 1000) {
      debugPrint('冷卻中，忽略本次掃描');
      return;
    }
    _lastScanTime = now;

    // 在單次掃描模式下，如果已經掃描過，則忽略
    if (!_isContinuousScanMode && _hasScanned) {
      debugPrint('單次掃描已完成，忽略新的掃描結果');
      return;
    }

    for (final barcode in barcodes.barcodes) {
      if (barcode.rawValue != null) {
        final scanContent = barcode.rawValue!;
        final scanType = _determineScanType(scanContent);

        debugPrint('識別掃描類型: $scanType');
        debugPrint('嘗試添加掃描記錄: $scanContent');

        try {
          _historyManager.addScanRecord(scanContent, scanType);
          debugPrint('掃描記錄已提交到 ScanHistoryManager');
        } catch (e) {
          debugPrint('添加掃描記錄時出錯: $e');
        }

        if (_isContinuousScanMode) {
          setState(() {
            _scanResult = scanContent;
          });
          ToastUtil.show(context, ' $scanContent');
        } else {
          // 單次掃描模式
          if (mounted) {
            // 確保 widget 仍然在樹中
            _scannerController.stop(); // 在 setState 之前停止相機
            setState(() {
              _scanResult = scanContent;
              _hasScanned = true;
              debugPrint('UI已更新為顯示掃描結果');
            });
          }
        }
        break;
      }
    }
  }

  @override

  /// 構建掃描畫面：相機預覽、結果顯示與操作按鈕
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 7, // 修改 flex 為 7，使其佔據 70% 空間
            child: (!_isContinuousScanMode && _hasScanned)
                ? Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceSize.width * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Scan Result',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: deviceSize.width * 0.8,
                              minWidth: deviceSize.width * 0.5,
                            ),
                            child: Text(
                              _scanResult,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 40),
                          CupertinoButton.filled(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceSize.width * 0.1),
                            onPressed: () {
                              setState(() {
                                _hasScanned = false;
                                _scanResult = '';
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scannerController.start();
                              });
                            },
                            child: const Text('Scan Again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : VisibilityDetector(
                    key: _scannerVisibilityKey,
                    onVisibilityChanged: (visibilityInfo) {
                      if (!mounted) return;
                      final visibleFraction = visibilityInfo.visibleFraction;
                      debugPrint(
                          'Scanner visibility: ${visibleFraction * 100}%');

                      if (visibleFraction > 0) {
                        debugPrint('Scanner is visible, starting camera...');
                        _scannerController.start().catchError((error) {
                          debugPrint('Error starting camera: $error');
                        });
                      } else {
                        debugPrint(
                            'Scanner is not visible, stopping camera...');
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
                                height: deviceSize.height * 0.7, // 限制高度比例
                                child: MobileScanner(
                                  controller: _scannerController,
                                  fit: BoxFit.cover, // 使用cover來填滿整個區域
                                  onDetect: _handleScan,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16.0,
                              right: 16.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.black.withValues(
                                      red: 0, green: 0, blue: 0, alpha: 0.7),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _isContinuousScanMode
                                          ? 'Continuous Scan'
                                          : 'Single Scan',
                                      style: const TextStyle(
                                          color: CupertinoColors.white,
                                          fontSize: 12),
                                    ),
                                    const SizedBox(width: 8),
                                    CupertinoSwitch(
                                      value: _isContinuousScanMode,
                                      activeTrackColor:
                                          CupertinoColors.activeGreen,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _isContinuousScanMode = value;
                                          _hasScanned = false;
                                          _scanResult = '';
                                          debugPrint(
                                              '掃描模式切換為: ${_isContinuousScanMode ? "連續" : "單次"}');
                                        });
                                      },
                                    ),
                                  ],
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
                                    red: 0, green: 0, blue: 0, alpha: 0.5),
                                borderRadius: BorderRadius.circular(20.0),
                                onPressed: () =>
                                    _scannerController.toggleTorch(),
                                child: Icon(
                                  CupertinoIcons.bolt_fill,
                                  size: deviceSize.width * 0.06,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ),
                            // 新增：右上角切換相機按鈕
                            Positioned(
                              top: 16.0,
                              right: 16.0,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(8.0),
                                color: CupertinoColors.black.withValues(
                                    red: 0, green: 0, blue: 0, alpha: 0.5),
                                borderRadius: BorderRadius.circular(20.0),
                                onPressed: () =>
                                    _scannerController.switchCamera(),
                                child: Icon(
                                  CupertinoIcons.switch_camera,
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
          ),
          // 新增 Expanded Widget 以佔據下半部分空間
          Expanded(
            flex: 3, // 修改 flex 為 3，使其佔據 30% 空間
            child: Container(), // 這裡留空，您可以後續添加其他 Widget
          ),
        ],
      ),
    );
  }
}
