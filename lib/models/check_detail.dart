// To parse this JSON data, do
//
//     final checkDetail = checkDetailFromJson(jsonString);

import 'dart:convert';

CheckDetail checkDetailFromJson(String str) =>
    CheckDetail.fromJson(json.decode(str));

String checkDetailToJson(CheckDetail data) => json.encode(data.toJson());

class CheckDetail {
  CheckDetail({
    required this.ruleId,
    required this.checked,
    required this.checkListMasterId,
    required this.controlId,
    required this.controlName,
  });

  int ruleId;
  bool checked;
  int checkListMasterId;
  int controlId;
  String controlName;

  factory CheckDetail.fromJson(Map<String, dynamic> json) => CheckDetail(
        ruleId: json["ruleId"],
        checked: json["checked"],
        checkListMasterId: json["checkListMasterId"],
        controlId: json["controlId"],
        controlName: json["controlName"],
      );

  Map<String, dynamic> toJson() => {
        "ruleId": ruleId,
        "checked": checked,
        "checkListMasterId": checkListMasterId,
        "controlId": controlId,
        "controlName": controlName,
      };
}
