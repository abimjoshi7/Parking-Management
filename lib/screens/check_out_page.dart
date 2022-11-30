import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../networking.dart';
import '../widgets/print_receipt.dart';

String? _scanBarcode;

class CheckOut extends StatefulWidget {
  static const name = "check-out";
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  late TextEditingController _textEditingController;
  bool isVisitor = false;
  String? lotNumber;
  String? vehicleNumber;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  Map<String, dynamic> selectedVehicleId = {};
  Map<String, dynamic> selectedProvinceId = {};
  Map<String, dynamic> selectedZoneId = {};
  String radioLabel = "zone";
  late NetworkHelper _networkHelper;
  PrintReceipt? printReceipt;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      // _scanBarcode = barcodeScanRes.substring(0, barcodeScanRes.length - 1);
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    // print("INSIDE CODE:" + barcodeScanRes);
//barcode scanner flutter ant
    setState(() {
      // _scanBarcode = barcodeScanRes.substring(0, barcodeScanRes.length - 1);
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  void initState() {
    super.initState();
    _networkHelper = NetworkHelper();
    printReceipt = PrintReceipt();
    _textEditingController =
        TextEditingController.fromValue(TextEditingValue.empty);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // backgroundColor: Colors.cyan,
          title: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: 'BY TICKET ID',
              ),
              Tab(
                text: 'VEHICLE NUMBER',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: height * 0.09,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Form(
                key: _formKey1,
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _textEditingController,
                        onFieldSubmitted: (v) {
                          if (_textEditingController.text.isNotEmpty) {
                            final request = jsonEncode({
                              "app_id": "P105",
                              "is_visitor": isVisitor,
                              "qr_token": _textEditingController.text,
                              "user_id": "1"
                            });
                            _networkHelper
                                .postCheckOut(request)
                                .then((value) => printReceipt?.printCheckOut());
                          }
                        },
                        validator: (v) {
                          if (v!.isEmpty) return "Field cannot be empty";
                          return null;
                        },
                        onSaved: (v) {
                          _scanBarcode = v;
                        },
                        decoration: const InputDecoration(
                            labelText: "Scanned Ticket Id"),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    StatefulBuilder(
                        builder: (_, setState) => Column(
                              children: [
                                const Text("Visitor?"),
                                Checkbox(
                                    value: isVisitor,
                                    onChanged: (v) {
                                      setState(() {
                                        isVisitor = v!;
                                      });
                                    }),
                              ],
                            ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey1.currentState!.validate()) {
                      _formKey1.currentState!.save();
                      if (_scanBarcode!.isNotEmpty && _scanBarcode == null) {
                        final request = jsonEncode({
                          "app_id": "P105",
                          "is_visitor": false,
                          "qr_token": _scanBarcode,
                          "user_id": "1"
                        });
                        _networkHelper.postCheckOut(request);
                      }
                    }
                  },
                  child: const Text("SEARCH"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _textEditingController.clear();
                    });
                  },
                  child: const Text("NEXT"),
                ),
              ],
            ),
          ]),
          FutureBuilder<Map<String, dynamic>>(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.08),
                              child: DropdownButtonFormField<String>(
                                  value: response.data!["vehical_type"][0]
                                      .toString(),
                                  items: List.generate(
                                    response.data!["vehical_type"].length,
                                    (index) => DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          Text(response.data!["vehical_type"]
                                              [index]["label"]),
                                          const Text(": Rs."),
                                          Text(response.data!["vehical_type"]
                                              [index]["rate"]),
                                        ],
                                      ),
                                      value: response.data!["vehical_type"]
                                              [index]
                                          .toString(),
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
                                            value: response.data!["province"]
                                                    [index]
                                                .toString(),
                                          ),
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            var x =
                                                v!.replaceAll("Province", "");

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
                                            var x =
                                                v!.replaceAll("Province", "");

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
                                        value: response.data!["zone"][9]
                                            .toString(),
                                        items: List.generate(
                                          response.data!["zone"].length,
                                          (index) => DropdownMenuItem(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(response.data!["zone"]
                                                    [index]["label"]),
                                              ],
                                            ),
                                            value: response.data!["zone"][index]
                                                .toString(),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.08),
                              child: TextFormField(
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Field cannot be empty";
                                  }
                                  return null;
                                },
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.08),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Field cannot be empty";
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  label: Text("Vehicle Number"),
                                ),
                                onSaved: (v) {
                                  setState(() {
                                    vehicleNumber = v!;
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                String numberPlate =
                                    await selectedProvinceId["code"] ??
                                        selectedZoneId["code"] +
                                            " " +
                                            lotNumber +
                                            " " +
                                            selectedVehicleId["code"] +
                                            " " +
                                            vehicleNumber;

                                await showDialog(
                                    context: context,
                                    builder: (_) => StatefulBuilder(
                                          builder: (_, setState) => AlertDialog(
                                            content:
                                                const Text("Official Stamp?"),
                                            actions: [
                                              Checkbox(
                                                  value: isVisitor,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isVisitor = value!;
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ));

                                final request = jsonEncode({
                                  "app_id": "P105",
                                  "is_visitor": isVisitor,
                                  "lot_no": lotNumber.toString(),
                                  "province_or_zone": radioLabel.toString(),
                                  "province_or_zone_id":
                                      selectedProvinceId["id"] ??
                                          selectedZoneId["id"],
                                  "province_or_zone_value":
                                      selectedProvinceId["code"] ??
                                          selectedZoneId["code"],
                                  "rate": selectedVehicleId["rate"],
                                  "user_id": "1",
                                  "vehicle_number": numberPlate,
                                  "vehicle_type": selectedVehicleId["code"]
                                });

                                // print("REQUEST:" + request);

                                _networkHelper
                                    .postCheckOutByVehicle(request)
                                    .then((value) =>
                                        printReceipt?.printCheckOut());
                              }
                            },
                            child: const Text('CHECK-OUT'),
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
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (_) => StatefulBuilder(
                      builder: (_, setState) => AlertDialog(
                        content: const Text("Official Stamp?"),
                        actions: [
                          Checkbox(
                              value: isVisitor,
                              onChanged: (bool? value) {
                                setState(() {
                                  isVisitor = value!;
                                });
                              }),
                        ],
                      ),
                    ));

            await scanQR()
                // ignore: avoid_print
                .then((value) => print("Scanned Code: " + _scanBarcode!));
            if (_scanBarcode!.isNotEmpty) {
              final request = jsonEncode({
                "app_id": "P105",
                "is_visitor": isVisitor,
                "qr_token": _scanBarcode,
                "user_id": "1"
              });
              _networkHelper.postCheckOut(request);
              // .then((value) => printReceipt?.printCheckOut());
            }
          },
          label: Row(
            children: const [
              Icon(Icons.adf_scanner),
              SizedBox(
                width: 5,
              ),
              Text("SCAN"),
            ],
          ),
        ),
      ),
    );
  }
}
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const TabBarDemo());
// }
//
// class TabBarDemo extends StatelessWidget {
//   const TabBarDemo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             bottom: const TabBar(
//               tabs: [
//                 Tab(icon: Icon(Icons.directions_car)),
//                 Tab(icon: Icon(Icons.directions_transit)),
//                 Tab(icon: Icon(Icons.directions_bike)),
//               ],
//             ),
//             title: const Text('Tabs Demo'),
//           ),
//           body: const TabBarView(
//             children: [
//               Icon(Icons.directions_car),
//               Icon(Icons.directions_transit),
//               Icon(Icons.directions_bike),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
