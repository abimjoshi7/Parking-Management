class Vehicle {
  late String id;
  late String label;
  late String rate;
  late String code;

  Vehicle(this.id, this.label, this.rate, this.code);

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    rate = json["rate"];
    code = json["code"];
  }
}
