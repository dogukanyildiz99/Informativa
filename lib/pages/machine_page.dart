// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:informativa/pages/date_selector.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:informativa/pages/main_page.dart';
import 'package:informativa/models/globals.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

  @override
  void initState() {
    getMachines();
    categoryId = 0;
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
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(84, 114, 251, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
        title: Center(
          child: Image.asset(
            "informativa-logo-large.png",
            width: screenWidth * 0.4,
            height: screenHeight * 0.04,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 8, bottom: 8),
                child: TextField(
                  controller: machineName,
                  cursorColor: Color.fromRGBO(24, 29, 61, 1),
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.build_circle_outlined,
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
                    labelText: "Makine İsmi Girin",
                    labelStyle:
                        const TextStyle(color: Color.fromRGBO(25, 25, 25, 1)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        machineName.clear();
                        setState(() {
                          _foundMachines = machines;
                        });
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: Color.fromRGBO(217, 20, 55, 0.8),
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
                        //key: ValueKey(_foundMachines),
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
        backgroundColor: Color.fromRGBO(16, 114, 60, 1),
        child: Image.asset(
          "excel_white.png",
          height: 25,
          width: 25,
        ),
        onPressed: () {
          setState(() {
            showBarModalBottomSheet(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              context: context,
              builder: (context) {
                return DatePicker();
              },
            );
          });
        },
      ),
    );
  }
}
