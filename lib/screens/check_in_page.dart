import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartparking/constants/app_indentifier.dart';
import 'package:smartparking/networking.dart';

import '../widgets/print_receipt.dart';

class CheckIn extends StatefulWidget {
  static const name = "check-in";
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  String? lotNumber;
  String? vehicleNumber;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> selectedVehicleId = {};
  Map<String, dynamic> selectedProvinceId = {};
  Map<String, dynamic> selectedZoneId = {};
  String radioLabel = "zone";
  late NetworkHelper _networkHelper;
  PrintReceipt? printReceipt;

  @override
  void initState() {
    super.initState();
    _networkHelper = NetworkHelper();
    printReceipt = PrintReceipt();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'PROVIDE VEHICLE DETAILS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _networkHelper.getDataV2() ?? _networkHelper.getData(),
        builder: (_, response) {
          if (response.hasData) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Province'),
                          Radio(
                              value: "province",
                              groupValue: radioLabel,
                              onChanged: (value) {
                                setState(() {
                                  radioLabel = value.toString();
                                  // print(radioLabel);
                                });
                              }),
                          const SizedBox(
                            width: 25,
                          ),
                          const Text('Zone'),
                          Radio(
                              value: "zone",
                              groupValue: radioLabel,
                              onChanged: (value) {
                                setState(() {
                                  radioLabel = value.toString();
                                  // print(radioLabel);
                                });
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(runSpacing: 10, children: [
                        //vehicle dropdown
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.08),
                          child: DropdownButtonFormField<String>(
                              value:
                                  response.data!["vehical_type"][0].toString(),
                              items: List.generate(
                                response.data!["vehical_type"].length,
                                (index) => DropdownMenuItem(
                                  value: response.data!["vehical_type"][index]
                                      .toString(),
                                  child: Row(
                                    children: [
                                      Text(response.data!["vehical_type"][index]
                                          ["label"]),
                                      const Text(": Rs."),
                                      Text(response.data!["vehical_type"][index]
                                          ["rate"]),
                                    ],
                                  ),
                                ),
                              ),
                              onChanged: (v) {
                                setState(() {
                                  var x = v!.replaceAll(", Jeep, Van ", "");
                                  x = x.replaceAll("/Scooter", "");
                                  x = x.replaceAll(" Van", "");
                                  selectedVehicleId = jsonDecode(
                                    x.replaceAllMapped(
                                      RegExp(r'\b\w+\b'),
                                      (match) {
                                        return '"${match.group(0)}"';
                                      },
                                    ),
                                  );
                                });
                                // print("SelectedIndex is: " + selectedVehicleId);
                              },
                              onSaved: (v) {
                                setState(() {
                                  var x = v!.replaceAll(", Jeep, Van ", "");
                                  x = x.replaceAll("/Scooter", "");
                                  x = x.replaceAll(" Van", "");
                                  selectedVehicleId = jsonDecode(
                                    x.replaceAllMapped(
                                      RegExp(r'\b\w+\b'),
                                      (match) {
                                        return '"${match.group(0)}"';
                                      },
                                    ),
                                  );
                                });
                                // print("SelectedIndex is: " + selectedVehicleId);
                              }),
                        ),
                        radioLabel == "province"
                            ?
                            //province dropdown
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: DropdownButtonFormField<String>(
                                    value: response.data!["province"][2]
                                        .toString(),
                                    items: List.generate(
                                      response.data!["province"].length,
                                      // response.data!["vehical_type"].length,
                                      (index) => DropdownMenuItem(
                                        value: response.data!["province"][index]
                                            .toString(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(response.data!["province"]
                                                [index]["label"]),
                                            // Text(":"),
                                            // Text(response.data!["province"][index]
                                            //     ["code"]),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        var x = v!.replaceAll("Province", "");

                                        selectedProvinceId = jsonDecode(
                                          x.replaceAllMapped(
                                            RegExp(r'\b\w+\b'),
                                            (match) {
                                              return '"${match.group(0)}"';
                                            },
                                          ),
                                        );
                                      });
                                      // print("SelectedIndex is: , +
                                      //     selectedProvinceId);
                                    },
                                    onSaved: (v) {
                                      setState(() {
                                        var x = v!.replaceAll("Province", "");

                                        selectedProvinceId = jsonDecode(
                                          x.replaceAllMapped(
                                            RegExp(r'\b\w+\b'),
                                            (match) {
                                              return '"${match.group(0)}"';
                                            },
                                          ),
                                        );
                                      });
                                      // print("SelectedIndex is: " +
                                      //     selectedProvinceId);
                                    }),
                              )
                            :
                            //zone dropdown
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: DropdownButtonFormField<String>(
                                    value: response.data!["zone"][9].toString(),
                                    items: List.generate(
                                      response.data!["zone"].length,
                                      // response.data!["vehical_type"].length,
                                      (index) => DropdownMenuItem(
                                        value: response.data!["zone"][index]
                                            .toString(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(response.data!["zone"][index]
                                                ["label"]),
                                            // Text(":"),
                                            // Text(response.data!["zone"][index]
                                            //     ["code"]),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        selectedZoneId = jsonDecode(
                                          v!.replaceAllMapped(
                                            RegExp(r'\b\w+\b'),
                                            (match) {
                                              return '"${match.group(0)}"';
                                            },
                                          ),
                                        );
                                      });
                                      // print("SelectedIndex is: " +
                                      //     selectedZoneId);
                                    },
                                    onSaved: (v) {
                                      setState(() {
                                        selectedZoneId = jsonDecode(
                                          v!.replaceAllMapped(
                                            RegExp(r'\b\w+\b'),
                                            (match) {
                                              return '"${match.group(0)}"';
                                            },
                                          ),
                                        );
                                      });
                                      // print("SelectedIndex is: " +
                                      //     selectedZoneId);
                                    }),
                              ),
                        //lot number textfield
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.08),
                          child: TextFormField(
                            // validator: (v) {
                            //   if (v!.isEmpty) return "Field cannot be empty";
                            //   return null;
                            // },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text("Lot Number"),
                            ),
                            onSaved: (v) {
                              setState(() {
                                lotNumber = v!;
                              });
                            },
                          ),
                        ),
                        //vehicle number textfield
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.08),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            // validator: (v) {
                            //   if (v!.isEmpty) return "Field cannot be empty";
                            //   return null;
                            // },
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              label: Text("Vehicle Number"),
                            ),
                            onSaved: (v) async {
                              final preferences =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                vehicleNumber = v!;
                                preferences.setString(vehicleNum, v);

                                // print('Vehicle Number is: ' + vehicleNumber!);
                              });
                            },
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final preferences =
                              await SharedPreferences.getInstance();

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            String? numberPlate =
                                await selectedProvinceId["code"] ??
                                    selectedZoneId["code"] +
                                        " " +
                                        lotNumber +
                                        " " +
                                        selectedVehicleId["code"] +
                                        " " +
                                        vehicleNumber;

                            preferences.setString(
                                fullVehicleId, numberPlate ?? "Ba xxx Pa xxxx");

                            final request = jsonEncode({
                              "app_id": preferences.getString(appId),
                              "lot_no": lotNumber.toString(),
                              "province_or_zone": radioLabel.toString(),
                              "province_or_zone_id": selectedProvinceId["id"] ??
                                  selectedZoneId["id"],
                              "province_or_zone_value":
                                  selectedProvinceId["code"] ??
                                      selectedZoneId["code"],
                              "rate": selectedVehicleId["rate"],
                              "user_id": "1",
                              "vehicle_number": numberPlate,
                              "vehicle_type": selectedVehicleId["code"]
                            });
                            // print("v-id: " + numberPlate!);

                            _networkHelper
                                .postCheckIn(request)
                                .then((value) => printReceipt?.printCheckIn());
                            // PrintReceipt().checkOut();
                          }
                        },
                        child: const Text('CHECK-IN'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
