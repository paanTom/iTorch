import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_control/torch_control.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const ITorch());
}

class ITorch extends StatelessWidget {
  const ITorch({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iTorch',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final spaceBlack = const Color(0xFF1D1D1F);
  final light = Colors.white;
  late Color appBackgroundColor;

  @override
  void initState() {
    super.initState();
    if (TorchControl.isOff) {
      appBackgroundColor = spaceBlack;
      return;
    }
    appBackgroundColor = light;
  }

  Future<bool> isFlashAvailable() async {
    return await TorchControl.ready();
  }

  set setStatusBarIconColorToDark(bool isTorchOn) {
    if (isTorchOn) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
      return;
    }
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: appBackgroundColor,
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                if (await isFlashAvailable()) {
                  appBackgroundColor =
                      (await TorchControl.toggle()) ? light : spaceBlack;
                  setStatusBarIconColorToDark = TorchControl.isOn;
                  setState(() {});
                }
              },
              child: const Text("iTorch")),
        ),
      );
}
