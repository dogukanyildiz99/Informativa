// To parse this JSON data, do
//
//     final machineRule = machineRuleFromJson(jsonString);

import 'dart:convert';

MachineRule machineRuleFromJson(String str) =>
    MachineRule.fromJson(json.decode(str));

String machineRuleToJson(MachineRule data) => json.encode(data.toJson());

class MachineRule {
  MachineRule({
    required this.machineId,
    required this.ruleId,
    required this.checked,
    required this.machineName,
    required this.controlName,
    required this.categoryId,
  });

  int machineId;
  int ruleId;
  bool checked;
  String machineName;
  String controlName;
  int categoryId;

  factory MachineRule.fromJson(Map<String, dynamic> json) => MachineRule(
        machineId: json["machineId"],
        ruleId: json["ruleId"],
        checked: json["checked"],
        machineName: json["machineName"],
        controlName: json["controlName"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "machineId": machineId,
        "ruleId": ruleId,
        "checked": checked,
        "machineName": machineName,
        "controlName": controlName,
        "categoryId": categoryId,
      };
}
