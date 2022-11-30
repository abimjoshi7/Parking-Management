import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartparking/constants/app_indentifier.dart';
import 'package:smartparking/screens/screens.dart';

import '../constants/theme.dart';

class RootScreen extends StatefulWidget {
  static const name = 'home-screen';
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // late NetworkHelper _networkHelper;
  final List<Widget> _widgets = [
    const CheckIn(),
    const CheckOut(),
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    // _networkHelper = NetworkHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    } else {
      args = {"user_id": "0", "user_name": "Test User"};
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
              onDoubleTap: () {
                Navigator.pushNamed(context, TestScreen.name);
              },
              child: Text('Welcome, ' + args["user_name"])),
          automaticallyImplyLeading: false,
          actions: [
            Row(
              children: [
                //settings
                Visibility(
                  visible: args["user_name"] == "Super Admin" ? true : false,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Settings.name,
                          arguments: args);
                    },
                    icon: const Icon(
                      Icons.settings,
                    ),
                  ),
                ),
                //print
                IconButton(
                  onPressed: () async {
                    // final preferences = await SharedPreferences.getInstance();
                    // print(preferences.getString(logIn));
                    Navigator.pushNamed(context, PrintTask.name);
                  },
                  icon: const Icon(Icons.print),
                ),
                //logout
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(
                          "Smart Parking",
                          textAlign: TextAlign.center,
                        ),
                        content: const Text(
                          "Are you sure?",
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              final preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove(logIn).then((value) =>
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.name));
                              // if (args["user_name"] == "Super Admin" &&
                              //     args["user_id"] == "1") {
                              //   _networkHelper.deleteConfig().then(
                              //         (value) => Navigator.popAndPushNamed(
                              //             context, LoginScreen.name),
                              //       );
                              // }
                            },
                            child: const Text("Logout"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: kColorPrimary),
        ),
        body: _widgets[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.door_front_door_outlined),
                  label: "Check-in"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.door_back_door_outlined),
                  label: "Check-out"),
            ]),
      ),
    );
  }
}
