// ignore_for_file: must_be_immutable, prefer_const_constructors, sort_child_properties_last, unused_local_variable, curly_braces_in_flow_control_structures
import 'dart:convert';
import 'package:informativa/models/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:informativa/pages/old_records.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  List<MachineRule> errors = [];
  bool firstRun = true;
  int count = 0;

  var userName = TextEditingController();
  var infoName = TextEditingController();
  var regNum = TextEditingController();

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

  addLog() {
    Api.logData(
      addInfo,
      addName,
      addRegNum,
      categoryId,
      widget.selectedMachineID,
      rulesId,
      checked,
    ).then((response) {
      if (response.body == "success") {
        setState(() {});
      } else {}
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
        title: Column(
          children: [
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
          ],
        ),
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
                        onPressed: () => showBarModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.6,
                            maxChildSize: 0.95,
                            minChildSize: 0.4,
                            expand: false,
                            snap: false,
                            builder: (context, scrollController) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ListView(
                                  controller: scrollController,
                                  children: [
                                    Expanded(
                                      flex: 40,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          controller: userName,
                                          decoration: InputDecoration(
                                            labelText: "Adınızı Girin",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                userName.clear();
                                              },
                                              icon: Icon(
                                                Icons.clear_rounded,
                                                color: Color.fromRGBO(
                                                    84, 114, 251, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 40,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          controller: regNum,
                                          decoration: InputDecoration(
                                            labelText: "Sicil Numarası Girin",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                regNum.clear();
                                              },
                                              icon: Icon(
                                                Icons.clear_rounded,
                                                color: Color.fromRGBO(
                                                    84, 114, 251, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 60,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          maxLines: 5,
                                          minLines: 2,
                                          expands: false,
                                          controller: infoName,
                                          decoration: InputDecoration(
                                            labelText: "Açıklamayı Girin",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                infoName.clear();
                                              },
                                              icon: Icon(
                                                Icons.clear_rounded,
                                                color: Color.fromRGBO(
                                                    84, 114, 251, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 60,
                                                right: 60,
                                                bottom: 10,
                                                top: 20),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (userName.text.isEmpty ||
                                                      infoName.text.isEmpty ||
                                                      regNum.text.isEmpty) {
                                                    EasyLoading.showError(
                                                      'Boş Bıraktınız',
                                                      duration:
                                                          Duration(seconds: 1),
                                                      dismissOnTap: true,
                                                    );
                                                  } else {
                                                    setState(() {
                                                      addName = userName.text;
                                                      addInfo = infoName.text;
                                                      addRegNum = regNum.text;
                                                      addLog();

                                                      resetCheck();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              OldRecords(
                                                                  widget
                                                                      .selectedMachineID,
                                                                  categoryId),
                                                        ),
                                                      );
                                                    });
                                                    userName.clear();
                                                    infoName.clear();
                                                    regNum.clear();

                                                    checked = false;
                                                  }
                                                },
                                                child: Text("Kaydet")),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
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
