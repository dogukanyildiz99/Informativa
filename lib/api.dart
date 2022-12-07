import 'dart:convert';

import 'package:http/http.dart' as http;

const baseurl = "http://10.141.24.80:5011/api/InformativaAPI/";

class Api {
  static Future<http.Response> getAllCategories(int selectedId) async {
    var selectedID = selectedId;
    var url = "${baseurl}getCategory?selectedCategoryId=$selectedID";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }

  static Future<http.Response> getAllMachineRules(
      int selectedId, int selectedMachineId) async {
    var url =
        "${baseurl}getMachineRule?machineId=$selectedMachineId&categoryId=$selectedId";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }

  static Future<http.Response> changeSituation(
      int rulesId, bool checked, int selectedMachineID) {
    var url = "${baseurl}Change";
    String body = json.encode({
      'RuleId': rulesId,
      'Checked': checked,
      'MachineId': selectedMachineID,
    });

    return http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future<http.Response> resetCheckList(
      int selectedMachineID, int selectedId) {
    var url = "${baseurl}resetChecks";
    String body =
        json.encode({'MachineId': selectedMachineID, 'CategoryId': selectedId});

    return http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future<http.Response> logData(
      String addInfo,
      String addName,
      String addRegName,
      int selectedMachineID,
      int selectedId,
      int rulesId,
      bool checked) {
    var url = "${baseurl}logData";
    String body = json.encode({
      'CheckerName': addName,
      'Description': addInfo,
      'CheckerRegNum': addRegName,
      'MachineId': selectedId,
      'CategoryId': selectedMachineID,
      'RuleId': rulesId,
      'Checked': checked,
    });

    return http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future<http.Response> getAllMachines() async {
    var url = "${baseurl}getMachine";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }

  static Future<http.Response> getAllChecks(
      int selectedMachineID, int selectedId) async {
    var url =
        "${baseurl}getCheckMaster?machineId=$selectedMachineID&categoryId=$selectedId";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }

  static Future<http.Response> getAllDetail(int a) async {
    var url = "${baseurl}getCheckDetail?checkMasterId=$a";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }

  static Future<http.Response> getExcelDetail() async {
    var url = "${baseurl}getExcelDetail";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }

  static Future<http.Response> getExcelMaster() async {
    var url = "${baseurl}getExcelMaster";
    return await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
  }
}
