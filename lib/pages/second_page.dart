// ignore_for_file: must_be_immutable, prefer_const_constructors, sort_child_properties_last, unused_local_variable, curly_braces_in_flow_control_structures, use_build_context_synchronously
import 'dart:convert';
import 'package:informativa/models/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:informativa/pages/add_record.dart';
import 'package:informativa/pages/old_records.dart';
import '../api.dart';
import '../models/machine_rule.dart';

class SecondPage extends StatefulWidget {
  SecondPage(this.selectedMachineID, this.selectedName, {super.key});
  int selectedMachineID;
  String selectedName;
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int rulesId = 0;
  bool checked = false;
  String addName = "";
  String addInfo = "";
  String addRegNum = "";
  String addCheckDuration = "";

  List<MachineRule> errors = [];
  bool firstRun = true;
  int count = 0;
  getRules() {
    Api.getAllMachineRules(
      categoryId,
      widget.selectedMachineID,
    ).then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            errors = list.map((model) => MachineRule.fromJson(model)).toList();
            if (errors.where((element) => element.checked == true).isNotEmpty &&
                firstRun == true) {
              firstRun = false;
              firstCheck();
            }
          },
        );
      },
    );
  }

  changeSituation() {
    Api.changeSituation(rulesId, checked, widget.selectedMachineID)
        .then((response) {
      if (response.body == "success") {
        setState(() {});
      } else {}
    });
  }

  resetCheck() {
    Api.resetCheckList(widget.selectedMachineID, categoryId).then((response) {
      if (response.body == "success") {
        getRules();
      } else {}
    });
  }

  var userName = TextEditingController();
  var infoName = TextEditingController();
  var regNum = TextEditingController();
  var checkDuration = TextEditingController();

  addLog() {
    Api.logData(addInfo, addName, addRegNum, categoryId,
            widget.selectedMachineID, rulesId, checked, addCheckDuration)
        .then((response) {
      if (response.body == "success") {
        setState(() {
          resetCheck();
        });
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OldRecords(widget.selectedMachineID, categoryId)),
      );
    });
  }

  firstCheck() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              'Eskiden kalan kayıt bulundu. Kayıt silinsin mi devam mı edilsin?'),
          content: SingleChildScrollView(),
          actions: <Widget>[
            TextButton(
              child: const Text('Sil'),
              onPressed: () {
                resetCheck();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Devam et'),
              onPressed: () {
                getRules();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getRules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.init();
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromRGBO(24, 29, 61, 1);
      }
      return Color.fromRGBO(24, 29, 61, 1);
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(84, 114, 251, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
        title: Column(children: [
          BreadCrumb(
            items: <BreadCrumbItem>[
              BreadCrumbItem(
                content: Text(
                  widget.selectedName,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
            divider: const Icon(Icons.chevron_right),
            overflow: ScrollableOverflow(
              reverse: false,
              direction: Axis.horizontal,
              keepLastDivider: false,
            ),
          ),
        ]),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 1),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: errors.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    color: Colors.white,
                                    child: Text(
                                      errors[index].controlName,
                                      style: TextStyle(
                                          color: Color.fromRGBO(24, 29, 61, 1)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: errors[index].checked,
                                    onChanged: (bool? newValue) {
                                      setState(
                                        () {
                                          errors[index].checked = newValue!;
                                          rulesId = errors[index].ruleId;
                                          checked = newValue;
                                          changeSituation();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(
                        child: Text('Kayıt Oluştur'),
                        onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return AddRecordBottomSheet(
                                widget.selectedMachineID, categoryId);
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 20, bottom: 10, top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OldRecords(
                                      widget.selectedMachineID, categoryId)),
                            );
                          },
                          child: Text("Eski Kayıtlar")),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
