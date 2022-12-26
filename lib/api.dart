import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const baseurl = "[YOUR DOMAIN HERE]/api/InformativaAPI/";

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
      String addRegNum,
      int selectedMachineID,
      int selectedId,
      int rulesId,
      bool checked,
      String addCheckDuration) {
    var url = "${baseurl}logData";
    String body = json.encode({
      'CheckerName': addName,
      'Description': addInfo,
      'CheckerRegNum': addRegNum,
      'MachineId': selectedId,
      'CategoryId': selectedMachineID,
      'RuleId': rulesId,
      'Checked': checked,
      'CheckDuration': addCheckDuration,
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

  static Future<http.Response> getExcelDetail(
      DateTime startDate, DateTime endDate) async {
    String a = DateFormat("yyyy-MM-ddT00:00:00").format(startDate);
    String b = DateFormat("yyyy-MM-ddT23:59:59").format(endDate);
    var url = "${baseurl}getExcelDetail";
    String body = json.encode({'StartDate': a, 'EndDate': b});

    return http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
  }

  static Future<http.Response> getExcelMaster(
      DateTime startDate, DateTime endDate) async {
    String a = DateFormat("yyyy-MM-ddT00:00:00").format(startDate);
    String b = DateFormat("yyyy-MM-ddT23:59:59").format(endDate);
    var url = "${baseurl}getExcelMaster";
    String body = json.encode({'StartDate': a, 'EndDate': b});

    return http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
  }
}
