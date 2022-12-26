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
    required this.controlName,
    required this.categoryId,
    required this.controlId,
    required this.checkListMasterId,
    required this.checkListDetailId,
    required this.checkerName,
    required this.machineId,
    required this.date,
    required this.description,
    required this.machineName,
    required this.categoryName,
    required this.checkDuration,
  });

  int ruleId;
  bool checked;
  String controlName;
  int categoryId;
  int controlId;
  int checkListMasterId;
  int checkListDetailId;
  String checkerName;
  int machineId;
  DateTime date;
  String description;
  String machineName;
  String categoryName;
  String checkDuration;

  factory ExcelDetail.fromJson(Map<String, dynamic> json) => ExcelDetail(
        ruleId: json["ruleId"],
        checked: json["checked"],
        controlName: json["controlName"],
        categoryId: json["categoryId"],
        controlId: json["controlId"],
        checkListMasterId: json["checkListMasterId"],
        checkListDetailId: json["checkListDetailId"],
        checkerName: json["checkerName"],
        machineId: json["machineId"],
        date: DateTime.parse(json["date"]),
        description: json["description"],
        machineName: json["machineName"],
        categoryName: json["categoryName"],
        checkDuration: json["checkDuration"],
      );

  Map<String, dynamic> toJson() => {
        "ruleId": ruleId,
        "checked": checked,
        "controlName": controlName,
        "categoryId": categoryId,
        "controlId": controlId,
        "checkListMasterId": checkListMasterId,
        "checkListDetailId": checkListDetailId,
        "checkerName": checkerName,
        "machineId": machineId,
        "date": date.toIso8601String(),
        "description": description,
        "machineName": machineName,
        "categoryName": categoryName,
        "checkDuration": checkDuration,
      };
}
