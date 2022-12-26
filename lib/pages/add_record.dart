// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:informativa/api.dart';
import 'package:informativa/models/globals.dart';
import 'package:informativa/models/machine_rule.dart';
import 'package:informativa/pages/old_records.dart';
import 'machine_page.dart';

class AddRecordBottomSheet extends StatefulWidget {
  AddRecordBottomSheet(this.selectedMachineID, this.categoryId, {super.key});
  int selectedMachineID;
  int categoryId;
  @override
  State<AddRecordBottomSheet> createState() => _AddRecordBottomSheetState();
}

class _AddRecordBottomSheetState extends State<AddRecordBottomSheet> {
  var userName = TextEditingController();
  var infoName = TextEditingController();
  var regNum = TextEditingController();
  var checkDuration = TextEditingController();
  String addName = "";
  String addInfo = "";
  String addRegNum = "";
  String addCheckDuration = "";

  int rulesId = 0;
  bool checked = false;
  List<MachineRule> errors = [];
  bool firstRun = true;
  addLog() {
    Api.logData(
      addInfo,
      addName,
      addRegNum,
      categoryId,
      widget.selectedMachineID,
      rulesId,
      checked,
      addCheckDuration,
    ).then((response) {
      if (response.body == "success") {
        setState(() {
          resetCheck();
        });
      }

      Timer(const Duration(seconds: 1), () {
        categoryId = widget.categoryId;
        if (categoryId == 32) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MachinePage()),
              (route) => false);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OldRecords(widget.selectedMachineID, categoryId)),
          );
        }
      });
    });
  }

  firstCheck() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              'Eskiden kalan kayıt bulundu. Kayıt silinsin mi devam mı edilsin?'),
          content: const SingleChildScrollView(),
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

  resetCheck() {
    Api.resetCheckList(widget.selectedMachineID, categoryId).then((response) {
      if (response.body == "success") {
        getRules();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
          child: Column(
            children: [
              const Expanded(
                  flex: 10,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Kontrol Kayıt Bilgileri",
                      style: TextStyle(fontSize: 22),
                    ),
                  )),
              Expanded(
                flex: 20,
                child: TextFormField(
                  controller: userName,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_pin_circle_outlined,
                      color: Color.fromRGBO(25, 25, 25, 1),
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    labelText: "Adınızı Girin",
                    labelStyle:
                        const TextStyle(color: Color.fromRGBO(25, 25, 25, 1)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        userName.clear();
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Color.fromRGBO(217, 20, 55, 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: TextFormField(
                  controller: regNum,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.numbers_outlined,
                      color: Color.fromRGBO(25, 25, 25, 1),
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    labelText: "Sicil Numarası Girin",
                    labelStyle:
                        const TextStyle(color: Color.fromRGBO(25, 25, 25, 1)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        regNum.clear();
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Color.fromRGBO(217, 20, 55, 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 25,
                child: TextFormField(
                  maxLines: 3,
                  minLines: 2,
                  expands: false,
                  controller: infoName,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                      color: Color.fromRGBO(25, 25, 25, 1),
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    labelText: "Açıklamayı Girin",
                    labelStyle:
                        const TextStyle(color: Color.fromRGBO(25, 25, 25, 1)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        infoName.clear();
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Color.fromRGBO(217, 20, 55, 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: TextFormField(
                  controller: checkDuration,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.access_time,
                      color: Color.fromRGBO(25, 25, 25, 1),
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(25, 25, 25, 0.4))),
                    labelText: "İşlem Süresini Girin",
                    labelStyle:
                        const TextStyle(color: Color.fromRGBO(25, 25, 25, 1)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        checkDuration.clear();
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Color.fromRGBO(217, 20, 55, 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        if (userName.text.isEmpty ||
                            infoName.text.isEmpty ||
                            regNum.text.isEmpty) {
                          EasyLoading.showError(
                            'Boş Bıraktınız',
                            duration: const Duration(seconds: 1),
                            dismissOnTap: true,
                          );
                        } else {
                          setState(() {
                            addName = userName.text;
                            addInfo = infoName.text;
                            addRegNum = regNum.text;
                            addCheckDuration = checkDuration.text;
                            addLog();
                            EasyLoading.showSuccess(
                              'Kayıt Yapıldı',
                              duration: const Duration(seconds: 1),
                              dismissOnTap: false,
                            );
                          });
                          userName.clear();
                          infoName.clear();
                          regNum.clear();

                          checked = false;
                        }
                      },
                      child: const Text(
                        "KAYDET",
                        style: TextStyle(fontSize: 17),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
