// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:informativa/models/category.dart';
import 'package:informativa/models/globals.dart';
import 'package:informativa/pages/second_page.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import '../api.dart';

class MainPage extends StatefulWidget {
  MainPage(this.selectedMachineId, this.selectedId, {super.key});
  int selectedMachineId;
  int selectedId;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedMachineID;
  var selectedId = 0;
  List<int> back = [];
  List<String> nameList = [];
  String selectedParentName = '';

  List<Category> items = [];
  getCategories() {
    Api.getAllCategories(categoryId).then(
      (response) {
        setState(
          () {
            if (response.body == "") {
              back.remove(back.last);
              nameList.remove(nameList.last);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SecondPage(selectedMachineID, selectedParentName)),
              );
            } else {
              Iterable list = json.decode(response.body);
              items = list.map((model) => Category.fromJson(model)).toList();
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    nameList.add("Informativa");
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
      appBar: AppBar(
        leadingWidth: 50,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
        title: Column(children: [
          BreadCrumb(
            items: <BreadCrumbItem>[
              for (int i = 0; i < nameList.length; i++)
                BreadCrumbItem(
                  content: TextButton(
                    onPressed: () {
                      setState(
                        () {
                          categoryId = back[i];
                          getCategories();
                          back.removeRange(i, back.length);
                          nameList.removeRange(i + 1, nameList.length);
                        },
                      );
                    },
                    child: Text(
                      nameList[i],
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
            divider: const Icon(Icons.chevron_right),
            overflow: ScrollableOverflow(
              reverse: true,
              direction: Axis.horizontal,
              keepLastDivider: false,
            ),
          ),
        ]),
        leading: categoryId == 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(
                    () {
                      categoryId = back.last;
                      back.remove(back.last);
                      nameList.remove(nameList.last);
                      getCategories();
                    },
                  );
                },
              ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    color: const Color.fromRGBO(84, 114, 251, 1)),
              ),
            ),
          ),
          Expanded(
            flex: 70,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50)),
                  color: Colors.white),
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(top: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(
                        Icons.analytics,
                        size: 30,
                        color: Color.fromRGBO(24, 29, 61, 1),
                      ),
                      title: Text(
                        items[index].categoryName,
                        style: TextStyle(color: Color.fromRGBO(24, 29, 61, 1)),
                      ),
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          Icon(Icons.arrow_circle_right_outlined,
                              size: 30, color: Color.fromRGBO(24, 29, 61, 1)),
                        ],
                      ),
                      onTap: () {
                        setState(
                          () {
                            selectedMachineID = widget.selectedMachineId;
                            categoryId = items[index].categoryId;
                            back.add(items[index].parentCategoryId);
                            selectedParentName = items[index].categoryName;
                            nameList.add(items[index].categoryName);
                            getCategories();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
