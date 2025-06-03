import 'package:flutter/cupertino.dart';
import 'package:prmsapp/services/mqtt_service.dart';
import 'package:prmsapp/widgets/binding_prms_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // APP畫面顯示後再進行MQTT連線
    MqttService().connect();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Title 固定在最上方
            // Container(
            //   width: double.infinity,
            //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            //   decoration: BoxDecoration(
            //     color: CupertinoColors.systemBackground,
            //     borderRadius: BorderRadius.circular(0),
            //     border: Border.all(
            //       color: CupertinoColors.systemGrey3,
            //       width: 0.5,
            //     ),
            //   ),
            //   child: Text(
            //     'PRMS APP',
            //     style: TextStyle(
            //       fontSize: 32,
            //       fontWeight: FontWeight.bold,
            //       color: const Color.fromARGB(255, 102, 113, 230),
            //     ),
            //   ),
            // ),
            Expanded(child: BindingPrmsCard()),
          ],
        ),
      ),
    );
  }
}
