import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartparking/constants/theme.dart';
import 'package:smartparking/networking.dart';
import 'package:smartparking/screens/screens.dart';

import '../constants/app_indentifier.dart';

class AdminLoginScreen extends StatefulWidget {
  static const name = 'admin-access';
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AdminLoginScreen> {
  late NetworkHelper _networkHelper;
  SharedPreferences? preferences;

  String? password;

  final _formKey = GlobalKey<FormState>();

  late bool isVisible;

  Future<void> initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializePreferences().whenComplete(() => setState(() {}));

    super.initState();
    isVisible = true;
    _networkHelper = NetworkHelper();
    _networkHelper.initialAdminConfig();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: height * 0.35,
                  child: Image.network(
                      "https://podamibenepal.com/wp-content/uploads/2022/03/cropped-podamibe-logo-1.png"),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: height * 0.02,
                ),
              ),
              const SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Podamibe Smart Parking",
                    style: kHeadTitle,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: height * 0.02,
                ),
              ),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: width * 0.10),
                    child: Wrap(runSpacing: 13, children: [
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        obscureText: isVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.key,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                                // print(isVisible);
                              });
                            },
                            icon: Icon(!isVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                          ),
                          labelText: 'Password',
                        ),
                        textInputAction: TextInputAction.done,
                        onSaved: (value) {
                          password = value;
                        },
                        validator: (password) {
                          if (password!.isEmpty) {
                            return "Password should not be empty";
                          }
                          return null;
                        },
                      ),
                    ]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: height * 0.04,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.30, vertical: 8.0),
                  child: _adminLoginButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        final preferences = await SharedPreferences.getInstance();

        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          final result = await _networkHelper.logInAdmin(password!);

          if (result['status'] == "true") {
            preferences.setString(logIn, "log-in");

            Fluttertoast.showToast(
                msg: "You are successfully logged in",
                backgroundColor: kColorPrimary);
            Navigator.pushNamedAndRemoveUntil(
                context, RootScreen.name, (Route route) => route.isFirst,
                arguments: result["data"]);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Invalid Credentials. Please try again.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      },
      child: const Text(
        "LOGIN",
      ),
    );
  }
}
