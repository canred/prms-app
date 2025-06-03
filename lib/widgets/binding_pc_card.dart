// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:prmsapp/services/mqtt_service.dart';

class BindingPCCard extends StatefulWidget {
  final String selectedPC;
  final List<String> pcList;
  final VoidCallback onQRScan;
  final VoidCallback onShowPicker;

  const BindingPCCard({
    super.key,
    required this.selectedPC,
    required this.pcList,
    required this.onQRScan,
    required this.onShowPicker,
  });

  @override
  State<BindingPCCard> createState() => _BindingPCCardState();
}

class _BindingPCCardState extends State<BindingPCCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder<bool>(
      valueListenable: MqttService().isConnected,
      builder: (context, connected, _) {
        final Color cardColor =
            connected ? const Color(0xFFE6F9EA) : const Color(0xFFFDEAEA);
        final Color iconColor =
            connected ? CupertinoColors.activeGreen : CupertinoColors.systemRed;
        final Color textColor = iconColor;

        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              isTapped = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isTapped = false;
            });
            widget.onShowPicker();
          },
          onTapCancel: () {
            setState(() {
              isTapped = false;
            });
          },
          onLongPress: widget.onQRScan,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 15.0,
            ),
            decoration: BoxDecoration(
              color: isTapped ? cardColor.withOpacity(0.7) : cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.10), // 陰影加深
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Binding PC',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: CupertinoColors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onQRScan,
                      child: Icon(
                        CupertinoIcons.device_laptop,
                        size: screenWidth * 0.12,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.selectedPC,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                size: 14,
                                color: CupertinoColors.black,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                connected
                                    ? CupertinoIcons.check_mark_circled_solid
                                    : CupertinoIcons.xmark_circle_fill,
                                color: iconColor,
                                size: 22,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            connected ? 'Connected !' : 'Disconnected',
                            style: TextStyle(color: textColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: widget.onQRScan,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          CupertinoIcons.qrcode,
                          size: screenWidth * 0.08,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
