// To parse this JSON data, do
//
//     final excelMaster = excelMasterFromJson(jsonString);

import 'dart:convert';

ExcelMaster excelMasterFromJson(String str) =>
    ExcelMaster.fromJson(json.decode(str));

String excelMasterToJson(ExcelMaster data) => json.encode(data.toJson());

class ExcelMaster {
  ExcelMaster({
    required this.machineName,
    required this.checkListMasterId,
    required this.checkerName,
    required this.description,
    required this.date,
    required this.machineId,
    required this.checkerRegNum,
    required this.categoryName,
    required this.categoryId,
    required this.checkDuration,
  });

  String machineName;
  int checkListMasterId;
  String checkerName;
  String description;
  DateTime date;
  int machineId;
  String checkerRegNum;
  String categoryName;
  int categoryId;
  dynamic checkDuration;

  factory ExcelMaster.fromJson(Map<String, dynamic> json) => ExcelMaster(
        machineName: json["machineName"],
        checkListMasterId: json["checkListMasterId"],
        checkerName: json["checkerName"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        machineId: json["machineId"],
        checkerRegNum: json["checkerRegNum"],
        categoryName: json["categoryName"],
        categoryId: json["categoryId"],
        checkDuration: json["checkDuration"],
      );

  Map<String, dynamic> toJson() => {
        "machineName": machineName,
        "checkListMasterId": checkListMasterId,
        "checkerName": checkerName,
        "description": description,
        "date": date.toIso8601String(),
        "machineId": machineId,
        "checkerRegNum": checkerRegNum,
        "categoryName": categoryName,
        "categoryId": categoryId,
        "checkDuration": checkDuration,
      };
}
