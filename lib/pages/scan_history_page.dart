import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viscanner/widgets/scan_history_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:viscanner/widgets/toast_util.dart';

/// 掃描歷史頁面
///
/// 顯示使用者的所有掃描歷史記錄，並提供：
/// - 搜尋功能：按內容或類型過濾記錄
/// - 滑動操作：複製、刪除、重新發送記錄
/// - 詳細視圖：查看記錄的完整信息
class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  State<ScanHistoryPage> createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  final ScanHistoryManager _historyManager = ScanHistoryManager();
  late List<ScanHistoryItem> _scanHistory;
  late List<ScanHistoryItem> _filteredScanHistory; // 過濾後的歷史記錄列表
  final TextEditingController _searchController =
      TextEditingController(); // 搜尋控制器

  @override
  void initState() {
    super.initState();
    _scanHistory = _historyManager.scanHistory;
    _filteredScanHistory = _scanHistory; // 初始化過濾列表
    // 添加監聽器，當歷史記錄變更時更新UI
    _historyManager.addListener(_updateHistoryFromManager);
    _searchController.addListener(_filterHistoryData); // 添加搜尋文字變更監聽
  }

  @override
  void dispose() {
    // 移除監聽器，避免記憶體洩漏
    _historyManager.removeListener(_updateHistoryFromManager);
    _searchController.removeListener(_filterHistoryData); // 移除搜尋文字變更監聽
    _searchController.dispose(); // 釋放搜尋控制器資源
    super.dispose();
  }

  /// 從歷史管理器更新歷史記錄列表
  void _updateHistoryFromManager() {
    setState(() {
      _scanHistory = _historyManager.scanHistory;
      _filterHistoryData(); // 更新後重新過濾
    });
  }

  /// 根據搜尋文字過濾歷史資料
  ///
  /// 能夠同時檢索內容和掃描類型，不區分大小寫
  void _filterHistoryData() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredScanHistory = _scanHistory;
      } else {
        _filteredScanHistory = _scanHistory
            .where((item) =>
                item.content
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                item.type
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Scan History'),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scan Records',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (_scanHistory.isNotEmpty)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Clear'),
                      onPressed: () {
                        _showClearConfirmDialog(context);
                      },
                    ),
                ],
              ),
            ),
            // Search box
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search scan records',
              ),
            ),
            Expanded(
              child: _scanHistory.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _filteredScanHistory.length, // 使用過濾後的列表長度
                      itemBuilder: (context, index) {
                        final item = _filteredScanHistory[index]; // 使用過濾後的項目
                        return _buildSwipeableHistoryItem(context, item, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 構建空狀態視圖
  ///
  /// 當沒有掃描記錄時顯示
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.doc_text_search,
            size: 70,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No scan records yet',
            style: TextStyle(
              fontSize: 18,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start scanning to record history',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  /// 構建可滑動的歷史記錄項
  ///
  /// [context] - 構建上下文
  /// [item] - 歷史記錄項
  /// [index] - 項目在列表中的索引
  Widget _buildSwipeableHistoryItem(
      BuildContext context, ScanHistoryItem item, int index) {
    return Slidable(
      key: ValueKey('history_$index'),
      // 左側滑動操作區域
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _resendScanItem(item),
            backgroundColor: CupertinoColors.activeBlue,
            foregroundColor: CupertinoColors.white,
            icon: CupertinoIcons.share,
            label: 'Resend',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          SlidableAction(
            onPressed: (_) => _copyToClipboard(item.content),
            backgroundColor: CupertinoColors.activeGreen,
            foregroundColor: CupertinoColors.white,
            icon: CupertinoIcons.doc_on_clipboard,
            label: 'Copy',
          ),
        ],
      ),
      // 右側滑動操作區域
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => _deleteHistoryItem(index),
          confirmDismiss: () async {
            final confirmed = await _confirmDelete(context);
            return confirmed;
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) => _deleteHistoryItem(index),
            backgroundColor: CupertinoColors.destructiveRed,
            foregroundColor: CupertinoColors.white,
            icon: CupertinoIcons.delete,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHistoryItem(context, item, index),
          const Divider(height: 1, indent: 70),
        ],
      ),
    );
  }

  /// 顯示刪除確認對話框
  ///
  /// [context] - 構建上下文
  /// 返回用戶是否確認刪除操作
  Future<bool> _confirmDelete(BuildContext context) async {
    bool? result = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this scan record?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// 構建歷史記錄項的內容視圖
  ///
  /// [context] - 構建上下文
  /// [item] - 歷史記錄項
  /// [index] - 項目在列表中的索引
  Widget _buildHistoryItem(
      BuildContext context, ScanHistoryItem item, int index) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        _showDetailsActionSheet(context, item, index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(item.type),
                color: CupertinoColors.systemBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.content,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.label,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.type} · ${item.formattedDateTime}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey3,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// 顯示記錄詳情動作表
  ///
  /// [context] - 構建上下文
  /// [item] - 歷史記錄項
  /// [index] - 項目在列表中的索引
  void _showDetailsActionSheet(
      BuildContext context, ScanHistoryItem item, int index) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Scan Details'),
        message: Column(
          children: [
            const SizedBox(height: 12),
            Text('Type: ${item.type}'),
            const SizedBox(height: 8),
            Text('Content: ${item.content}'),
            const SizedBox(height: 8),
            Text('Time: ${item.formattedDateTime}'),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Copy Content'),
            onPressed: () {
              _copyToClipboard(item.content);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Resend'),
            onPressed: () {
              Navigator.pop(context);
              _resendScanItem(item);
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _deleteHistoryItem(index);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  /// 顯示清空所有記錄的確認對話框
  ///
  /// [context] - 構建上下文
  void _showClearConfirmDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Clear All'),
          content: const Text(
              'Are you sure you want to clear all scan records? This action cannot be undone.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Clear All'),
              onPressed: () {
                _clearAllHistory();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 將文字複製到剪貼簿
  ///
  /// [text] - 要複製的文字
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      // Show success toast
      ToastUtil.show(context, 'Copied to clipboard');
    });
  }

  /// 重新發送掃描項目
  ///
  /// [item] - 要重新發送的歷史記錄項
  void _resendScanItem(ScanHistoryItem item) {
    // Implement resend or share functionality as needed
    ToastUtil.show(context, 'Resend: ${item.content}');
  }

  /// 刪除指定索引的歷史記錄項
  ///
  /// [index] - 要刪除的記錄索引
  void _deleteHistoryItem(int index) {
    setState(() {
      _historyManager.deleteScanRecord(index);
    });
  }

  /// 清空所有歷史記錄
  void _clearAllHistory() {
    setState(() {
      _historyManager.clearAllRecords();
    });
  }

  /// 根據掃描類型獲取對應的圖標
  ///
  /// [type] - 掃描類型
  /// 返回與類型相對應的圖標
  IconData _getIconForType(String type) {
    switch (type) {
      case 'QR Code':
        return CupertinoIcons.qrcode;
      case 'Barcode':
        return CupertinoIcons.barcode;
      case 'Text':
        return CupertinoIcons.doc_text;
      default:
        return CupertinoIcons.qrcode;
    }
  }
}
