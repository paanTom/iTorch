import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_torch/utils/app_colors.dart';
import 'package:torch_control/torch_control.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  lockScreenToPortrait();
  setStatusBarToTransparent();
  runApp(const ITorch());
}

void lockScreenToPortrait() => SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

void setStatusBarToTransparent() => SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

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
  final spaceBlack = AppColors.spaceBlack;
  final spaceLight = AppColors.spaceLight;
  late Color appBackgroundColor;

  late double iconSize = (MediaQuery.of(context).size.width) * (30 / 100);

  @override
  void initState() {
    super.initState();
    if (TorchControl.isOff) {
      appBackgroundColor = spaceBlack;
      return;
    }
    appBackgroundColor = spaceLight;
  }

  Future<bool> _isFlashAvailable() async {
    return await TorchControl.ready();
  }

  set _setStatusBarIconColorToDark(bool isTorchOn) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness:
            isTorchOn ? Brightness.dark : Brightness.light));
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
                  if (await _isFlashAvailable()) {
                    appBackgroundColor =
                        (await TorchControl.toggle()) ? spaceLight : spaceBlack;
                    _setStatusBarIconColorToDark = TorchControl.isOn;
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
