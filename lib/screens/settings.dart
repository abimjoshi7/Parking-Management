import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartparking/networking.dart';

import '../constants/app_indentifier.dart';
import '../constants/theme.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  bool isDisplayPan = false;
  bool isDisplayPowered = false;
  static const name = 'settings';
  Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late NetworkHelper _networkHelper;

  final _formKey = GlobalKey<FormState>();

  String initialPanNum = "";
  String initialHeading = "";
  String initialAddress = "";
  String initialCopyright = "";
  String initialAppId = "";
  String initialAppLogo = "";
  String initialConfigUrl = "";
  String initialLoginUrl = "";

  SharedPreferences? preferences;

  @override
  void initState() {
    initializePreferences().whenComplete(() => setState(() {}));
    super.initState();
    _networkHelper = NetworkHelper();
  }

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration"),
        actions: [
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
                      "Do you want to delete all configuration?",
                      textAlign: TextAlign.center,
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          _networkHelper.deleteConfig();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text("Confirm"),
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
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(children: [
            ExpansionTile(
              textColor: kColorPrimary,
              iconColor: kColorPrimary,
              title: const Text("Header"),
              children: [
                ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          title: const Text(
                            "Display PAN Number",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          value: preferences?.getBool(isPan) ??
                              widget.isDisplayPan,
                          onChanged: (value) {
                            setState(() {
                              widget.isDisplayPan = value;
                              preferences?.setBool(isPan, widget.isDisplayPan);
                            });
                          },
                          activeColor: kColorPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue:
                                preferences?.getString(panNumber) ?? "",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(panNumber, v);
                                initialPanNum = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(panNumber, v!);
                                initialPanNum = v!;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: "Pan Number"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue:
                                preferences?.getString(headerTitle) ?? "",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(headerTitle, v);
                                initialHeading = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(headerTitle, v!);
                                initialHeading = v!;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Header Title"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue:
                                preferences?.getString(singleLineAddress) ?? "",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(singleLineAddress, v);
                                initialAddress = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(singleLineAddress, v!);
                                initialAddress = v!;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Single Line Address"),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            ExpansionTile(
              textColor: kColorPrimary,
              iconColor: kColorPrimary,
              title: const Text("Footer"),
              children: [
                ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          title: const Text(
                            "Display Powered By",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          value: preferences?.getBool(isPowered) ??
                              widget.isDisplayPowered,
                          onChanged: (value) {
                            setState(() {
                              widget.isDisplayPowered = value;
                              preferences?.setBool(
                                  isPowered, widget.isDisplayPowered);
                            });
                          },
                          activeColor: kColorPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue:
                                preferences?.getString(copyrightText) ?? "",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(copyrightText, v);
                                initialCopyright = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(copyrightText, v!);
                                initialCopyright = v!;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Copyright Text"),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            ExpansionTile(
              textColor: kColorPrimary,
              iconColor: kColorPrimary,
              title: const Text("App Identifier"),
              children: [
                ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue: preferences?.getString(appId) ?? "",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(appId, v);
                                initialAppId = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(appId, v!);
                                initialAppId = v!;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Application Id"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue:
                                preferences?.getString(appLogo) ?? "https://",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(appLogo, v);
                                initialAppLogo = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(appLogo, v!);
                                initialAppLogo = v!;
                              });
                            },
                            decoration:
                                const InputDecoration(labelText: "Logo URL"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue:
                                preferences?.getString(configURL) ?? "https://",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(configURL, v);
                                initialConfigUrl = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(configURL, v!);
                                initialConfigUrl = v!;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Configuration API Url"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 18),
                          child: TextFormField(
                            initialValue:
                                preferences?.getString(loginURL) ?? "https://",
                            onChanged: (v) {
                              setState(() {
                                preferences?.setString(loginURL, v);
                                initialLoginUrl = v;
                              });
                            },
                            onSaved: (v) {
                              setState(() {
                                preferences?.setString(loginURL, v!);
                                initialLoginUrl = v!;
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: "Login API Url"),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
