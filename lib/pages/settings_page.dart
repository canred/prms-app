import 'package:flutter/cupertino.dart';

//void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsForm(); // 直接返回 SettingsForm
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  bool airplaneMode = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'), // 顯示在中間的標題
        previousPageTitle: 'Back', // 顯示上一頁的標題
        backgroundColor: CupertinoColors.systemBlue,
      ),
      // Add safe area widget to place the CupertinoFormSection below the navigation bar.
      child: SafeArea(
        child: CupertinoListSection(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          header: const Text('Connectivity'),
          children: <Widget>[
            CupertinoFormRow(
              prefix: const PrefixWidget(
                icon: CupertinoIcons.bitcoin_circle,
                title: 'Dark mode',
                color: CupertinoColors.systemOrange,
              ),
              child: CupertinoSwitch(
                value: airplaneMode,
                onChanged: (bool value) {
                  setState(() {
                    airplaneMode = value;
                  });
                },
              ),
            ),
            CupertinoFormRow(
              prefix: const PrefixWidget(
                icon: CupertinoIcons.desktopcomputer,
                title: 'Device Binding',
                color: Color.fromARGB(255, 255, 0, 157),
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // 在這裡添加按鈕點擊事件處理邏輯
                  print('QR Code Button Pressed');
                },
                child: const Icon(
                  CupertinoIcons.qrcode,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ),
            const CupertinoFormRow(
              prefix: PrefixWidget(
                icon: CupertinoIcons.wifi,
                title: 'MQTT Connection',
                color: CupertinoColors.systemBlue,
              ),
              error: Text('MQTT unavailable'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Not connected'),
                  SizedBox(width: 5),
                  Icon(CupertinoIcons.forward)
                ],
              ),
            ),
            CupertinoFormRow(
              prefix: const PrefixWidget(
                icon: CupertinoIcons.keyboard,
                title: 'Keyboard Input',
                color: CupertinoColors.secondaryLabel,
              ),
              helper: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: CupertinoTextField(
                  placeholder: 'Enter text',
                  //預設填入文字ABC
                  controller: TextEditingController(text: 'Enter'),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
            const CupertinoFormRow(
              prefix: PrefixWidget(
                icon: CupertinoIcons.goforward_15,
                title: 'Mobile Data',
                color: CupertinoColors.systemGreen,
              ),
              child: Icon(CupertinoIcons.forward),
            ),
          ],
        ),
      ),
    );
  }
}

class PrefixWidget extends StatelessWidget {
  const PrefixWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Icon(icon, color: CupertinoColors.white),
        ),
        const SizedBox(width: 15),
        Text(title)
      ],
    );
  }
}
