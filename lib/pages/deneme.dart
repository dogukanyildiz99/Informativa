// // ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import '../api.dart';
// import '../models/machine.dart';
// import '../models/machine_rule.dart';
// import 'main_page.dart';
// import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';

// import 'old_records.dart';

// class Deneme extends StatefulWidget {
//   Deneme({super.key});

//   @override
//   State<Deneme> createState() => _DenemeState();
// }

// class _DenemeState extends State<Deneme> {
//   int rulesId = 0;
//   bool checked = false;
//   String addName = "";
//   String addInfo = "";
//   String addRegNum = "";
//   List<MachineRule> errors = [];
//   int selectedId = 26;
//   int selectedMachineID = 1;
//   getRules() {
//     Api.getAllMachineRules(
//       selectedId,
//       selectedMachineID,
//     ).then(
//       (response) {
//         setState(
//           () {
//             Iterable list = json.decode(response.body);
//             errors = list.map((model) => MachineRule.fromJson(model)).toList();
//           },
//         );
//       },
//     );
//   }

//   changeSituation() {
//     Api.changeSituation(rulesId, checked, selectedMachineID).then((response) {
//       if (response.body == "success") {
//         setState(() {});
//       } else {}
//     });
//   }

//   var userName = TextEditingController();
//   var infoName = TextEditingController();
//   var regNum = TextEditingController();

//   addLog() {
//     Api.logData(
//       addInfo,
//       addName,
//       addRegNum,
//       selectedId,
//       selectedMachineID,
//       rulesId,
//       checked,
//     ).then((response) {
//       if (response.body == "success") {
//         setState(() {});
//       } else {}
//     });
//   }

//   @override
//   void initState() {
//     getRules();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     EasyLoading.init();

//     Color getColor(Set<MaterialState> states) {
//       const Set<MaterialState> interactiveStates = <MaterialState>{
//         MaterialState.pressed,
//         MaterialState.hovered,
//         MaterialState.focused,
//       };
//       if (states.any(interactiveStates.contains)) {
//         return Color.fromRGBO(24, 29, 61, 1);
//       }
//       return Color.fromRGBO(24, 29, 61, 1);
//     }

//     var machineName = TextEditingController();
//     return Scaffold(
//         backgroundColor: Theme.of(context).canvasColor,
//         //
//         // Set [extendBody] to true for bottom app bar overlap body content
//         extendBody: true,
//         appBar: AppBar(
//           title: Text("Panel Showcase"),
//           backgroundColor: Theme.of(context).bottomAppBarColor,
//         ),
//         //
//         // Lets use docked FAB for handling state of sheet
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: GestureDetector(
//           //
//           // Set onVerticalDrag event to drag handlers of controller for swipe effect
//           onVerticalDragUpdate: DefaultBottomBarController.of(context).onDrag,
//           onVerticalDragEnd: DefaultBottomBarController.of(context).onDragEnd,
//           child: FloatingActionButton.extended(
//             label: AnimatedBuilder(
//               animation: DefaultBottomBarController.of(context).state,
//               builder: (context, child) => Row(
//                 children: [
//                   Text(
//                     DefaultBottomBarController.of(context).isOpen
//                         ? "Kayıt"
//                         : "Kayıt",
//                   ),
//                   const SizedBox(width: 4.0),
//                   AnimatedBuilder(
//                     animation: DefaultBottomBarController.of(context).state,
//                     builder: (context, child) => Transform(
//                       alignment: Alignment.center,
//                       transform: Matrix4.diagonal3Values(
//                         1,
//                         DefaultBottomBarController.of(context).state.value * 2 -
//                             1,
//                         1,
//                       ),
//                       child: child,
//                     ),
//                     child: RotatedBox(
//                       quarterTurns: 1,
//                       child: Icon(
//                         Icons.chevron_right,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             elevation: 2,
//             backgroundColor: Colors.deepOrange,
//             foregroundColor: Colors.white,
//             //
//             //Set onPressed event to swap state of bottom bar
//             onPressed: () => DefaultBottomBarController.of(context).swap(),
//           ),
//         ),
//         //
//         // Actual expandable bottom bar
//         bottomNavigationBar: BottomExpandableAppBar(
//             appBarHeight: 40,
//             expandedHeight: 300,
//             horizontalMargin: 2,
//             shape: AutomaticNotchedShape(
//                 RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
//             expandedBackColor: Colors.blue,
//             expandedBody: Expanded(
//                 flex: 40,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(15),
//                           topRight: Radius.circular(15))),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                             flex: 40,
//                             child: TextFormField(
//                               controller: userName,
//                               decoration: InputDecoration(
//                                 labelText: "Adınızı Girin",
//                                 suffixIcon: IconButton(
//                                   onPressed: () {
//                                     userName.clear();
//                                   },
//                                   icon: Icon(
//                                     Icons.clear_rounded,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                         Expanded(
//                             flex: 40,
//                             child: TextFormField(
//                               controller: regNum,
//                               decoration: InputDecoration(
//                                 labelText: "RegNum Girin",
//                                 suffixIcon: IconButton(
//                                   onPressed: () {
//                                     regNum.clear();
//                                   },
//                                   icon: Icon(
//                                     Icons.clear_rounded,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                         Expanded(
//                             flex: 5,
//                             child: Container(
//                               color: Colors.transparent,
//                             )),
//                         Expanded(
//                             flex: 60,
//                             child: TextFormField(
//                               controller: infoName,
//                               decoration: InputDecoration(
//                                 labelText: "Hatâyı Girin",
//                                 suffixIcon: IconButton(
//                                   onPressed: () {
//                                     infoName.clear();
//                                   },
//                                   icon: Icon(
//                                     Icons.clear_rounded,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 5, right: 5),
//                               child: ElevatedButton(
//                                   onPressed: () {
//                                     if (userName.text.isEmpty ||
//                                         infoName.text.isEmpty ||
//                                         regNum.text.isEmpty) {
//                                       EasyLoading.showError(
//                                         'Boş Bıraktınız',
//                                         duration: Duration(seconds: 1),
//                                         dismissOnTap: true,
//                                       );
//                                     } else {
//                                       setState(() {
//                                         addName = userName.text;
//                                         addInfo = infoName.text;
//                                         addRegNum = regNum.text;
//                                         addLog();
//                                       });
//                                       userName.clear();
//                                       infoName.clear();
//                                       regNum.clear();

//                                       checked = false;
//                                     }
//                                   },
//                                   child: Text("Kaydet")),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 5, right: 5),
//                               child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => OldRecords(
//                                               selectedMachineID, selectedId)),
//                                     );
//                                   },
//                                   child: Text("Eski Kayıtlar")),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ))),
//         body: Padding(
//           padding: const EdgeInsets.only(bottom: 50),
//           child: Container(
//             child: Expanded(
//               flex: 60,
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.only(topRight: Radius.circular(50))),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         padding: EdgeInsets.only(left: 10, right: 10, top: 20),
//                         physics: const BouncingScrollPhysics(),
//                         shrinkWrap: true,
//                         scrollDirection: Axis.vertical,
//                         itemCount: errors.length,
//                         itemBuilder: (context, index) {
//                           return Row(
//                             children: [
//                               Expanded(
//                                 flex: 4,
//                                 child: Container(
//                                   color: Colors.white,
//                                   child: Text(
//                                     errors[index].controlName,
//                                     style: TextStyle(
//                                         color: Color.fromRGBO(24, 29, 61, 1)),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: Checkbox(
//                                   checkColor: Colors.white,
//                                   fillColor: MaterialStateProperty.resolveWith(
//                                       getColor),
//                                   value: errors[index].checked,
//                                   onChanged: (bool? newValue) {
//                                     setState(
//                                       () {
//                                         errors[index].checked = newValue!;
//                                         rulesId = errors[index].ruleId;
//                                         checked = newValue;
//                                         changeSituation();
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }
