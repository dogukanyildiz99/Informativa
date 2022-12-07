// To parse this JSON data, do
//
//     final checkMaster = checkMasterFromJson(jsonString);

import 'dart:convert';

CheckMaster checkMasterFromJson(String str) =>
    CheckMaster.fromJson(json.decode(str));

String checkMasterToJson(CheckMaster data) => json.encode(data.toJson());

class CheckMaster {
  CheckMaster({
    required this.checkListMasterId,
    required this.checkerName,
    required this.description,
    required this.checkerRegNum,
    required this.machineId,
    required this.categoryId,
    required this.date,
  });

  int checkListMasterId;
  String checkerName;
  String description;
  String checkerRegNum;
  int machineId;
  int categoryId;
  DateTime date;

  factory CheckMaster.fromJson(Map<String, dynamic> json) => CheckMaster(
        checkListMasterId: json["checkListMasterId"],
        checkerName: json["checkerName"],
        description: json["description"],
        checkerRegNum: json["checkerRegNum"],
        machineId: json["machineId"],
        categoryId: json["categoryId"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "checkListMasterId": checkListMasterId,
        "checkerName": checkerName,
        "description": description,
        "checkerRegNum": checkerRegNum,
        "machineId": machineId,
        "categoryId": categoryId,
        "date": date.toIso8601String(),
      };
}
