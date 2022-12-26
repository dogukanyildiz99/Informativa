// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:informativa/models/excel_master.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../api.dart';
import '../models/excel_detail.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime endDate = DateTime.now().add(Duration(days: 1));

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = DateTime.parse(
            '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}T${DateFormat('HH:mm:ss.SSS').format(args.value.startDate)}');

        endDate = DateTime.parse(
            '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}T${DateFormat('23:59:59.999').format(args.value.endDate)}');
      }
    });
  }

  List<ExcelDetail> excelDetail = [];
  getExcelDetail() {
    Api.getExcelDetail(startDate, endDate).then(
      (response) {
        setState(
          () {
            excelDetail = [];
            Iterable list = json.decode(response.body);
            excelDetail =
                list.map((model) => ExcelDetail.fromJson(model)).toList();
          },
        );
        exportToExcel();
      },
    );
  }

  List<ExcelMaster> excelMaster = [];
  getExcelMaster() {
    Api.getExcelMaster(startDate, endDate).then(
      (response) {
        setState(
          () {
            excelMaster = [];
            if (response.body == "") {
              EasyLoading.showInfo(
                'Kayıt Bulunamadı',
                duration: const Duration(seconds: 2),
                dismissOnTap: false,
              );
            } else {
              Iterable list = json.decode(response.body);
              excelMaster =
                  list.map((model) => ExcelMaster.fromJson(model)).toList();
              getExcelDetail();
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: ((context, scrollController) => Column(
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Rapor için başlangıç ve bitiş tarihini seçin",
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.3, color: Colors.blue),
                    ),
                  )),
              Expanded(
                flex: 75,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: SfDateRangePicker(
                    headerHeight: 50,
                    showTodayButton: false,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                        weekendTextStyle: TextStyle(color: Colors.lightBlue)),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1, weekendDays: const <int>[6, 7]),
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 1)),
                        DateTime.now().add(const Duration(days: 1))),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          getExcelMaster();
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "excel_white.png",
                                height: 20,
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "EXCEL OLUŞTUR",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> exportToExcel() async {
    ByteData data = await rootBundle.load("informativa_report.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    List<Sheet> excelSheets =
        excel.sheets.entries.map((entry) => (entry.value)).toList();

    for (int i = 0; i < excelSheets.length; i++) {
      if (i == 0) {
        for (var column = 0; column < excelDetail.length; column++) {
          var cellA =
              excelSheets[i].cell(CellIndex.indexByString("A${column + 2}"));
          cellA.value = excelDetail[column].machineName;
          var cellB =
              excelSheets[i].cell(CellIndex.indexByString("B${column + 2}"));
          cellB.value = excelDetail[column].checkerName;
          var cellC =
              excelSheets[i].cell(CellIndex.indexByString("C${column + 2}"));
          cellC.value = excelDetail[column].description;
          var cellD =
              excelSheets[i].cell(CellIndex.indexByString("D${column + 2}"));
          cellD.value =
              DateFormat("dd-MM-yyyy | HH:mm").format(excelDetail[column].date);
          var cellE =
              excelSheets[i].cell(CellIndex.indexByString("E${column + 2}"));
          cellE.value = excelDetail[column].checkDuration;
          var cellF =
              excelSheets[i].cell(CellIndex.indexByString("F${column + 2}"));
          cellF.value = excelDetail[column].controlName;
          var cellG =
              excelSheets[i].cell(CellIndex.indexByString("G${column + 2}"));
          if (cellG.value = excelDetail[column].checked == true) {
            cellG.value = "✓";
            CellStyle cellStyle = CellStyle(
                fontColorHex: "#1a731d",
                fontSize: 15,
                horizontalAlign: HorizontalAlign.Center);
            cellG.cellStyle = cellStyle;
          } else {
            CellStyle cellStyle = CellStyle(
                fontColorHex: "#FF0000",
                fontSize: 18,
                horizontalAlign: HorizontalAlign.Center,
                verticalAlign: VerticalAlign.Center);
            cellG.cellStyle = cellStyle;
            cellG.value = "×";
          }
        }
      } else {
        for (var column = 0; column < excelMaster.length; column++) {
          var cellA =
              excelSheets[i].cell(CellIndex.indexByString("A${column + 2}"));
          cellA.value = excelMaster[column].machineName;
          var cellB =
              excelSheets[i].cell(CellIndex.indexByString("B${column + 2}"));
          cellB.value = excelMaster[column].checkerName;
          var cellC =
              excelSheets[i].cell(CellIndex.indexByString("C${column + 2}"));
          cellC.value = excelMaster[column].checkerRegNum;
          var cellD =
              excelSheets[i].cell(CellIndex.indexByString("D${column + 2}"));
          cellD.value = excelMaster[column].description;
          var cellE =
              excelSheets[i].cell(CellIndex.indexByString("E${column + 2}"));
          cellE.value = excelMaster[column].checkDuration;
          var cellF =
              excelSheets[i].cell(CellIndex.indexByString("F${column + 2}"));
          cellF.value =
              DateFormat("dd-MM-yyyy | HH:mm").format(excelMaster[column].date);
          var cellG =
              excelSheets[i].cell(CellIndex.indexByString("G${column + 2}"));
          cellG.value = excelMaster[column].categoryName;
        }
      }
    }

    excel.save(
        fileName:
            "Informativa_Report_${DateFormat('dd-MM-yyyy').format(DateTime.now())}.xlsx");
  }
}
