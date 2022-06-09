import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  late double iconSize = (MediaQuery.of(context).size.width) * (30 / 100);

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
          child: Theme(
            data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent),
            child: InkWell(
                onTap: () async {
                  if (await isFlashAvailable()) {
                    appBackgroundColor =
                        (await TorchControl.toggle()) ? light : spaceBlack;
                    setStatusBarIconColorToDark = TorchControl.isOn;
                    setState(() {});
                  }
                },
                child: SvgPicture.asset(
                  TorchControl.isOn
                      ? 'assets/icons/torch_on.svg'
                      : 'assets/icons/torch_off.svg',
                  height: iconSize,
                  width: iconSize,
                )),
          ),
        ),
      );
}
