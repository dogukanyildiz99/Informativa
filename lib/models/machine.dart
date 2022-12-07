// To parse this JSON data, do
//
//     final machine = machineFromJson(jsonString);

import 'dart:convert';

Machine machineFromJson(String str) => Machine.fromJson(json.decode(str));

String machineToJson(Machine data) => json.encode(data.toJson());

class Machine {
  Machine({
    required this.machineId,
    required this.machineName,
  });

  int machineId;
  String machineName;

  factory Machine.fromJson(Map<String, dynamic> json) => Machine(
        machineId: json["machineId"],
        machineName: json["machineName"],
      );

  Map<String, dynamic> toJson() => {
        "machineId": machineId,
        "machineName": machineName,
      };
}
