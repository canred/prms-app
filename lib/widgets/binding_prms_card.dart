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
        color: const Color.fromARGB(255, 194, 206, 244), // 更濃郁的灰色
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
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 更换光阻液
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey3,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CupertinoButton(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const PageFun1(),
                          ),
                        );
                      },
                      // 更换光阻液
                      child: const Text(
                        'Consume',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                  // 光阻液上防爆柜
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey3,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CupertinoButton(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: () {
                        print('Button 2 clicked');
                      },
                      child: const Text(
                        'Move In Rack',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                  // 光阻液下防爆柜
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey3,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CupertinoButton(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: () {
                        print('Button 3 clicked');
                      },
                      child: const Text(
                        'Move Out Rack',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                  // 光阻液上机
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey3,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CupertinoButton(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: () {
                        print('Button 4 clicked');
                      },
                      child: const Text(
                        'Put On Flow',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                  // 光阻液下机
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey3,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CupertinoButton(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: () {
                        print('Button 5 clicked');
                      },
                      child: const Text(
                        'Take Off Flow',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                  // 光阻液解除 Alert
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey3,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CupertinoButton(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: () {
                        print('Button 6 clicked');
                      },
                      child: const Text(
                        'Clean Flow',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 底部版权信息
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 4.0),
                child: Text(
                  'Copyright © 2025 VIS,VSMC. All rights reserved.',
                  style: TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 13.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
