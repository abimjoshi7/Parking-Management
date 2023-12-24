import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartparking/constants/connection_apis.dart';
import 'package:smartparking/screens/login.dart';
import 'package:smartparking/screens/root_screen.dart';

class SplashScreen extends StatefulWidget {
  static const name = "splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  final BluetoothDevice _device =
      BluetoothDevice(bluetoothName, bluetoothAddress);
  SharedPreferences? preferences;
  bool? isLogged;

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> toggleLogged() async {
    if (preferences?.getString('logIn') == null) {
      setState(() {
        isLogged = false;
      });
    } else {
      setState(() {
        isLogged = true;
      });
    }
    // print(isLogged);
  }

  Future<void> connectBluetooth() async {
    try {
      if (await bluetooth.isAvailable == true && await bluetooth.isOn == true) {
        await bluetooth.connect(_device);
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initializePreferences();
    toggleLogged();
    connectBluetooth();
    // try{
    //   if(bluetooth.isAvailable == true && bluetooth.isOn == true){
    //
    //   }
    // }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.network(
          "https://podamibenepal.com/wp-content/uploads/2022/03/cropped-podamibe-logo-1.png"),
      nextScreen: isLogged == false ? const LoginScreen() : const RootScreen(),
      backgroundColor: Colors.white,
    );
  }
}
