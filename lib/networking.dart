import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartparking/constants/theme.dart';

import 'constants/app_indentifier.dart';

class NetworkHelper {
  SharedPreferences? preferences;
  final baseUrl = "https://management.propertycare.online/api/";
  final configUrl = "https://management.propertycare.online/config.json?appId=";

  Future<Map<String, dynamic>> logIn(String password, String username) async {
    preferences = await SharedPreferences.getInstance();
    try {
      final jsonRequest =
          jsonEncode({"password": password, "username": username});
      final response = await http.post(
          Uri.parse(
              preferences?.getString(loginURL).toString() ?? baseUrl + "login"),
          body: jsonRequest);
      return jsonDecode(response.body);
    } catch (e) {
      throw ("POST EXCEPTION:" + e.toString());
    }
  }

  Future<Map<String, dynamic>> logInAdmin(String password) async {
    preferences = await SharedPreferences.getInstance();
    try {
      final jsonRequest = jsonEncode(
          {"password": password, "username": "info@podamibenepal.com"});
      final response =
          await http.post(Uri.parse(baseUrl + "login"), body: jsonRequest);
      return jsonDecode(response.body);
    } catch (e) {
      throw ("POST EXCEPTION:" + e.toString());
    }
  }

  Future<Map<String, dynamic>> getData() async {
    preferences = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(configUrl + "P105"),
    );
    return await jsonDecode(response.body);
  }

  Future<Map<String, dynamic>>? getDataV2() async {
    preferences = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(configUrl + preferences!.get(appId).toString()),
    );
    return await jsonDecode(response.body);
  }

  Future<void> deleteConfig() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(panNumber);
    preferences.remove(headerTitle);
    preferences.remove(singleLineAddress);
    preferences.remove(copyrightText);
    preferences.remove(appId);
    preferences.remove(appLogo);
    preferences.remove(configURL);
    preferences.remove(loginURL);
    preferences.remove(isPowered);
    preferences.remove(isPan);
    preferences.clear();
  }

  Future<void> initialAdminConfig() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(panNumber, "123456789");
    preferences.setString(headerTitle, "Podamibe Nepal Pvt Ltd");
    preferences.setString(singleLineAddress, "Thapathali, Kathmandu, Nepal");
    preferences.setString(copyrightText, "Powered By Podamibe Nepal");
    preferences.setString(appId, "P105");
    preferences.setString(appLogo,
        "https://podamibenepal.com/wp-content/uploads/2022/03/cropped-podamibe-logo-1.png");
    preferences.setString(configURL,
        "https://management.propertycare.online/config.json?appId=P105");
    preferences.setString(
        loginURL, "https://management.propertycare.online/api/login");
    preferences.setBool(isPan, true);
    preferences.setBool(isPowered, true);
  }

  Future<void> postCheckIn(String body) async {
    preferences = await SharedPreferences.getInstance();
    final request = await http.post(Uri.parse(baseUrl + "checkin"), body: body);
    final result = await jsonDecode(request.body);
    await preferences?.setString(checkIn, result["data"]["check_in"]);
    await preferences?.setString(qrToken, result["data"]["qr_token"]);
    await preferences?.setString(rate, result["data"]["rate"]);
    // print("RESULT:" + result.toString());

    Fluttertoast.showToast(
        msg: result["message"].toString(), backgroundColor: kColorPrimary);
  }

  Future<void> postCheckOut(String body) async {
    preferences = await SharedPreferences.getInstance();

    final request =
        await http.post(Uri.parse(baseUrl + "checkout"), body: body);
    final result = await jsonDecode(request.body);
    // print("Response result: " + result.toString());
    await preferences?.setString(checkIn, result["data"]["check_in"]);
    await preferences?.setString(checkOut, result["data"]["check_out"]);
    await preferences?.setString(qrToken, result["data"]["qr_token"]);
    await preferences?.setString(rate, result["data"]["rate"]);
    await preferences?.setString(amount, result["data"]["amount"]);
    await preferences?.setString(
        fullVehicleId, result["data"]["vehicle_number"]);
    await preferences?.setString(receiptNum, result["data"]["receipt_number"]);
    // print("RESULT:" + result.toString());
    Fluttertoast.showToast(
        msg: result["message"].toString(), backgroundColor: kColorPrimary);
  }

  Future<void> postCheckOutByVehicle(String body) async {
    preferences = await SharedPreferences.getInstance();

    final request =
        await http.post(Uri.parse(baseUrl + "checkoutByVehicle"), body: body);
    final result = await jsonDecode(request.body);
    await preferences?.setString(checkIn, result["data"]["check_in"]);
    await preferences?.setString(
        checkOutByVehicle, result["data"]["check_out"]);
    await preferences?.setString(qrToken, result["data"]["qr_token"]);
    await preferences?.setString(rate, result["data"]["rate"]);
    await preferences?.setString(amount, result["data"]["amount"]);
    await preferences?.setString(
        fullVehicleId, result["data"]["vehicle_number"]);
    await preferences?.setString(receiptNum, result["data"]["receipt_number"]);
    // print("RESULT:" + result.toString());
    Fluttertoast.showToast(
        msg: result["message"].toString(), backgroundColor: kColorPrimary);
  }
}
