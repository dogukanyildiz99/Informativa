// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unused_element
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:informativa/models/check_master.dart';
import 'package:informativa/models/globals.dart';
import 'package:informativa/pages/machine_page.dart';
import 'package:informativa/pages/scroll.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../api.dart';

class OldRecords extends StatefulWidget {
  OldRecords(this.selectedMachineID, this.selectedId, {super.key});
  int selectedMachineID;
  int selectedId;
  @override
  State<OldRecords> createState() => _OldRecordsState();
}

class _OldRecordsState extends State<OldRecords> {
  int a = 0;
  List<CheckMaster> master = [];

  getChecks() {
    Api.getAllChecks(widget.selectedMachineID, widget.selectedId).then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            master = list.map((model) => CheckMaster.fromJson(model)).toList();
          },
        );
      },
    );
  }

  @override
  void initState() {
    getChecks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
        title: widget.selectedId == 32
            ? Text("Diğer Hata Kayıtları")
            : Text("Hata Kayıtları"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() async {
              categoryId = 0;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MachinePage()),
                  (route) => false);
            });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: master.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(master[index].description),
              subtitle: Row(
                children: [
                  Text(master[index].checkerName),
                  SizedBox(
                    width: 1,
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    size: 20,
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(master[index].checkerRegNum),
                  SizedBox(
                    width: 3,
                  ),
                  Icon(
                    Icons.arrow_right_rounded,
                    size: 20,
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(DateFormat("dd-MM-yyyy").format(master[index].date))
                ],
              ),
              onTap: () {
                setState(() {
                  masterId = master[index].checkListMasterId;
                });
                if (widget.selectedId != 32) {
                  showBarModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return Scroll();
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
