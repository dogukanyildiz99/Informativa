// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:informativa/models/excel_detail.dart';
import 'package:informativa/models/excel_master.dart';
import 'package:informativa/pages/main_page.dart';
import 'package:informativa/models/globals.dart';
import '../api.dart';
import '../models/machine.dart';

class MachinePage extends StatefulWidget {
  const MachinePage({super.key});

  @override
  State<MachinePage> createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  var selectedMachineId = 0;
  List<Machine> machines = [];
  int rows = 10;
  Duration? executionTime;
  getMachines() {
    Api.getAllMachines().then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            machines = list.map((model) => Machine.fromJson(model)).toList();
            _foundMachines = machines;
          },
        );
      },
    );
  }

  List<ExcelDetail> excelDetail = [];
  getExcelDetail() {
    Api.getExcelDetail().then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            excelDetail =
                list.map((model) => ExcelDetail.fromJson(model)).toList();
          },
        );
      },
    );
  }

  List<ExcelMaster> excelMaster = [];
  getExcelMaster() {
    Api.getExcelMaster().then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            excelMaster =
                list.map((model) => ExcelMaster.fromJson(model)).toList();
          },
        );
      },
    );
  }

  Future<void> exportToExcel() async {
    ByteData data = await rootBundle.load("Informativa_Report.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    Sheet sheetObject = excel["Sheet1"];

    for (var column = 0; column < excelDetail.length; column++) {
      var cellA = sheetObject.cell(CellIndex.indexByString("A${column + 2}"));
      cellA.value = excelDetail[column].machineName;
      var cellB = sheetObject.cell(CellIndex.indexByString("B${column + 2}"));
      cellB.value = excelDetail[column].checkerName;
      var cellC = sheetObject.cell(CellIndex.indexByString("C${column + 2}"));
      cellC.value = excelDetail[column].description;
      var cellD = sheetObject.cell(CellIndex.indexByString("D${column + 2}"));
      cellD.value = DateFormat("dd-MM-yyyy").format(excelDetail[column].date);
      var cellE = sheetObject.cell(CellIndex.indexByString("E${column + 2}"));
      cellE.value = excelDetail[column].controlName;
      var cellF = sheetObject.cell(CellIndex.indexByString("F${column + 2}"));
      cellF.value = excelDetail[column].checked;

      cellF.value ? cellF.value = "İşaretlendi" : cellF.value = "İşaretlenmedi";
    }

    excel.save(fileName: "Informativa_Report-${DateTime.now()}.xlsx");
  }

  @override
  void initState() {
    getMachines();
    getExcelDetail();
    getExcelMaster();
    super.initState();
  }

  List<Machine> _foundMachines = [];

  void _runFilter(String enteredKeyboard) {
    List<Machine> results = [];
    if (enteredKeyboard.isEmpty) {
      results = machines;
    } else {
      results = machines
          .where((a) => a.machineName
              .toLowerCase()
              .contains(enteredKeyboard.toLowerCase()))
          .toList();
    }

    setState(
      () {
        _foundMachines = results;
      },
    );
  }

  int selectedId = 0;
  var machineName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(84, 114, 251, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
        title: Center(
          child: Image.asset(
            "assets/image/informativa-logo-large.png",
            width: screenWidth * 0.4,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 10,
                child: TextField(
                  controller: machineName,
                  cursorColor: Color.fromRGBO(24, 29, 61, 1),
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    labelText: "Makine İsmi Girin",
                    suffixIcon: IconButton(
                      onPressed: () {
                        machineName.clear();
                        setState(() {
                          _foundMachines = machines;
                        });
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Expanded(
                flex: 90,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _foundMachines.length,
                  itemBuilder: ((context, index) => Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: ListTile(
                            onTap: () {
                              setState(
                                () {
                                  machineId = _foundMachines[index].machineId;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MainPage(machineId, selectedId)),
                                  );
                                },
                              );
                            },
                            title: Text(
                              _foundMachines[index].machineName,
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 29, 61, 1)),
                            ),
                            trailing: Wrap(
                              spacing: 12,
                              children: <Widget>[
                                Icon(Icons.arrow_circle_right_outlined,
                                    size: 30,
                                    color: Color.fromRGBO(24, 29, 61, 1)),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.file_download_outlined,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            getMachines();
            getExcelDetail();
            getExcelMaster();
          });
          exportToExcel();
        },
      ),
    );
  }
}
