// To parse this JSON data, do
//
//     final excelDetail = excelDetailFromJson(jsonString);

import 'dart:convert';

ExcelDetail excelDetailFromJson(String str) =>
    ExcelDetail.fromJson(json.decode(str));

String excelDetailToJson(ExcelDetail data) => json.encode(data.toJson());

class ExcelDetail {
  ExcelDetail({
    required this.ruleId,
    required this.checked,
    required this.checkListMasterId,
    required this.controlId,
    required this.controlName,
    required this.categoryId,
    required this.checkerName,
    required this.date,
    required this.machineId,
    required this.machineName,
    required this.categoryName,
    required this.description,
  });

  int ruleId;
  bool checked;
  int checkListMasterId;
  int controlId;
  String controlName;
  int categoryId;
  String checkerName;
  DateTime date;
  int machineId;
  String machineName;
  String categoryName;
  String description;

  factory ExcelDetail.fromJson(Map<String, dynamic> json) => ExcelDetail(
        ruleId: json["ruleId"],
        checked: json["checked"],
        checkListMasterId: json["checkListMasterId"],
        controlId: json["controlId"],
        controlName: json["controlName"],
        categoryId: json["categoryId"],
        checkerName: json["checkerName"],
        date: DateTime.parse(json["date"]),
        machineId: json["machineId"],
        machineName: json["machineName"],
        categoryName: json["categoryName"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "ruleId": ruleId,
        "checked": checked,
        "checkListMasterId": checkListMasterId,
        "controlId": controlId,
        "controlName": controlName,
        "categoryId": categoryId,
        "checkerName": checkerName,
        "date": date.toIso8601String(),
        "machineId": machineId,
        "machineName": machineName,
        "categoryName": categoryName,
        "description": description,
      };
}
