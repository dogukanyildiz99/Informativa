// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:informativa/models/globals.dart';
import '../api.dart';
import '../models/check_detail.dart';

class Scroll extends StatefulWidget {
  const Scroll({super.key});
  @override
  State<Scroll> createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
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

  List<CheckDetail> detail = [];
  getDetail() {
    Api.getAllDetail(masterId).then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            detail = list.map((model) => CheckDetail.fromJson(model)).toList();
          },
        );
      },
    );
  }

  @override
  void initState() {
    getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8999999999,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: ((context, scrollController) => ListView.builder(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: detail.length,
            itemBuilder: ((context, index) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      child: Text(detail[index].controlName),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: detail[index].checked,
                        onChanged: (bool? value) {},
                      ))
                ],
              );
            }),
          )),
    );
  }
}