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
                      child: const Text(
                        '更换光阻液',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
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
                        '更换光阻液',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
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
                        '更换光阻液',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
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
                        '更换光阻液',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
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
                        '更换光阻液',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
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
                        '更换光阻液',
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
