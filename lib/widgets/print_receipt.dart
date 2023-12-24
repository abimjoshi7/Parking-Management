import 'dart:math';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_indentifier.dart';

class PrintReceipt {
  String getRandomString(int length) {
    const characters =
        '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(
          random.nextInt(
            characters.length,
          ),
        ),
      ),
    );
  }

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  printCheckIn() async {
    final preferences = await SharedPreferences.getInstance();

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            preferences.getString(headerTitle).toString(), 0, 1);
        bluetooth.printCustom(
            preferences.getString(singleLineAddress).toString(), 0, 1);

        preferences.getBool(isPan) == true
            ? bluetooth.printCustom(
                "Pan Number : ${preferences.getString(panNumber)}", 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printQRcode(
            preferences.getString(qrToken).toString(), 200, 200, 1);
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom(
            "Check-In    ${preferences.get(checkIn).toString()}", 0, 1);
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printLeftRight("S.N", getRandomString(8), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Rate", "Rs ${preferences.get(rate).toString()}/hr", 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "V.N", preferences.getString(fullVehicleId).toString(), 0,
            charset: "windows-1250");
        bluetooth.printCustom(dottedLine, 1, 1);
        preferences.getBool(isPowered) == true
            ? bluetooth.printCustom(
                preferences.getString(copyrightText).toString(), 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }

  printCheckOut() async {
    final preferences = await SharedPreferences.getInstance();

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            preferences.getString(headerTitle).toString(), 0, 1);
        bluetooth.printCustom(
            preferences.getString(singleLineAddress).toString(), 0, 1);
        preferences.getBool(isPan) == true
            ? bluetooth.printCustom(
                "Pan Number : ${preferences.getString(panNumber)}", 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom(
            "Check-In    ${preferences.get(checkIn).toString()}", 0, 1);
        bluetooth.printCustom(
            "Check-Out    ${preferences.get(checkOut).toString()}", 0, 1);
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printLeftRight(
            "Rec.No", preferences.get(receiptNum).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Rate", "Rs ${preferences.get(rate).toString()}/hr", 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "V.N", preferences.getString(fullVehicleId).toString(), 0,
            charset: "windows-1250");
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom(
            "Amount: Rs ${preferences.get(amount).toString()}", 0, 1);
        bluetooth.printCustom(dottedLine, 1, 1);
        preferences.getBool(isPowered) == true
            ? bluetooth.printCustom(
                preferences.getString(copyrightText).toString(), 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }

  printCheckOutByVehicle() async {
    final preferences = await SharedPreferences.getInstance();

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            preferences.getString(headerTitle).toString(), 0, 1);
        bluetooth.printCustom(
            preferences.getString(singleLineAddress).toString(), 0, 1);
        preferences.getBool(isPan) == true
            ? bluetooth.printCustom(
                "Pan Number : ${preferences.getString(panNumber)}", 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom(
            "Check-In    ${preferences.get(checkIn).toString()}", 0, 1);
        bluetooth.printCustom(
            "Check-Out    ${preferences.get(checkOutByVehicle).toString()}",
            0,
            1);
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printLeftRight(
            "Rec.No", preferences.get(receiptNum).toString(), 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "Rate", "Rs ${preferences.get(rate).toString()}/hr", 0,
            charset: "windows-1250");
        bluetooth.printLeftRight(
            "V.N", preferences.getString(fullVehicleId).toString(), 0,
            charset: "windows-1250");
        bluetooth.printCustom(dottedLine, 1, 1);
        bluetooth.printCustom(
            "Amount: Rs ${preferences.get(amount).toString()}", 0, 1);
        bluetooth.printCustom(dottedLine, 1, 1);
        preferences.getBool(isPowered) == true
            ? bluetooth.printCustom(
                preferences.getString(copyrightText).toString(), 0, 1)
            : bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }
}
