// To parse this JSON data, do
//
//     final excelMaster = excelMasterFromJson(jsonString);

import 'dart:convert';

ExcelMaster excelMasterFromJson(String str) =>
    ExcelMaster.fromJson(json.decode(str));

String excelMasterToJson(ExcelMaster data) => json.encode(data.toJson());

class ExcelMaster {
  ExcelMaster({
    required this.checkListMasterId,
    required this.checkerName,
    required this.description,
    required this.machineId,
    required this.date,
    required this.machineName,
  });

  int checkListMasterId;
  String checkerName;
  String description;
  int machineId;
  DateTime date;
  String machineName;

  factory ExcelMaster.fromJson(Map<String, dynamic> json) => ExcelMaster(
        checkListMasterId: json["checkListMasterId"],
        checkerName: json["checkerName"],
        description: json["description"],
        machineId: json["machineId"],
        date: DateTime.parse(json["date"]),
        machineName: json["machineName"],
      );

  Map<String, dynamic> toJson() => {
        "checkListMasterId": checkListMasterId,
        "checkerName": checkerName,
        "description": description,
        "machineId": machineId,
        "date": date.toIso8601String(),
        "machineName": machineName,
      };
}
