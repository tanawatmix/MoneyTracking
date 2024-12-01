// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_element, sort_child_properties_last, prefer_is_empty, use_build_context_synchronously, must_be_immutable, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_single_cascade_in_expression_statements

import 'package:explo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:explo/models/money.dart';
import 'package:explo/utils/env.dart';
import 'package:explo/views/home_ui.dart';
import 'package:explo/views/welcome_ui.dart';

import '../../services/call_api.dart';

class OutcomeViewUI extends StatefulWidget {
  User? user;

  OutcomeViewUI({super.key, this.user});

  @override
  State<OutcomeViewUI> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<OutcomeViewUI> {
  List<Money>? moneyData;
  double totalBalance = 0.0;
  TextEditingController moneyDetailCtrl = TextEditingController(text: '');
  TextEditingController moneyInOutCtrl = TextEditingController(text: '');
  TextEditingController moneyDateCtrl = TextEditingController(text: '');

  String? _DateSelected;
  Future<void> _openCalendar() async {
    final DateTime? _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (_picker != null) {
      setState(() {
        moneyDateCtrl.text = convertToThaiDate(_picker);
        _DateSelected = _picker.toString().substring(0, 10);
      });
    }
  }

  convertToThaiDate(date) {
    String day = date.toString().substring(8, 10);
    String year = (int.parse(date.toString().substring(0, 4)) + 543).toString();
    String month = '';
    int monthTemp = int.parse(date.toString().substring(5, 7));
    switch (monthTemp) {
      case 1:
        month = 'มกราคม';
        break;
      case 2:
        month = 'กุมภาพันธ์';
        break;
      case 3:
        month = 'มีนาคม';
        break;
      case 4:
        month = 'เมษายน';
        break;
      case 5:
        month = 'พฤษภาคม';
        break;
      case 6:
        month = 'มิถุนายน';
        break;
      case 7:
        month = 'กรกฎาคม';
        break;
      case 8:
        month = 'สิงหาคม';
        break;
      case 9:
        month = 'กันยายน';
        break;
      case 10:
        month = 'ตุลาคม';
        break;
      case 11:
        month = 'พฤศจิกายน';
        break;
      default:
        month = 'ธันวาคม';
    }

    return day + ' ' + month + ' พ.ศ. ' + year;
  }

  showWaringDialog(context, msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'คำเตือน',
            
          ),
        ),
        content: Text(
          msg,
          
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E7C78),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',style: TextStyle(
              color: Colors.white,
            ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future showCompleteDialog(context, msg) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'ผลการทำงาน',
          ),
        ),
        content: Text(
          msg,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3E7C78),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> callGetAllStatementByUserId(Money money) async {
    final data = await CallAPI.callGetAllStatementByUserId(money);
    setState(() {
      moneyData = data;
      final totalIncome = data.where((item) => item.moneyType == '1').fold(
          0.0, (sum, item) => sum + (double.tryParse(item.moneyInOut!) ?? 0.0));
      final totalExpense = data.where((item) => item.moneyType == '2').fold(
          0.0, (sum, item) => sum + (double.tryParse(item.moneyInOut!) ?? 0.0));
      totalBalance = totalIncome - totalExpense;
    });
  }

  @override
  void initState() {
    super.initState();
    Money money = Money(userId: widget.user!.userId);
    callGetAllStatementByUserId(money);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                    color: const Color(0xFF3E7C78), // Main Color
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 100.0),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 60,
                  bottom: 0,
                  right: 20,
                  left: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        '${widget.user!.userFullName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.15 / 2),
                      child: InkWell(
                        onDoubleTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomeUI()));
                        },
                        child: Image.network(
                          '${Env.hostName}/moneytrackingAPI/picupload/user/${widget.user!.userImage}',
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 150,
                  left: 25,
                  right: 25,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                      color: Color(0xFF107C78),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF1B5C58),
                          spreadRadius: 0.01,
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        27,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 150,
                  left: 25,
                  right: 25,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: Color(0xFF107C78),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'ยอดเงินคงเหลือ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: moneyData == null || totalBalance == 0
                            ? Text(
                                '0.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              )
                            : Text(
                                NumberFormat('#,###.00').format(totalBalance),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage('assets/icons/income2.png'),
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.height *
                                      0.029,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'ยอดเงินเข้ารวม',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 75),
                            child: Text(
                              'ยอดเงินออกรวม',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: ImageIcon(
                              AssetImage('assets/icons/outcome2.png'),
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height * 0.029,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            moneyData == null
                                ? CircularProgressIndicator()
                                : moneyData == null ||
                                        moneyData!
                                                .where((item) =>
                                                    item.moneyType == '1')
                                                .fold(
                                                    0.0,
                                                    (sum, item) =>
                                                        sum +
                                                        double.parse(item
                                                            .moneyInOut!)) ==
                                            0
                                    ? Text(
                                        '0.00',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                    : Text(
                                        NumberFormat('#,###.00').format(
                                          moneyData!
                                              .where((item) =>
                                                  item.moneyType == '1')
                                              .fold(
                                                  0.0,
                                                  (sum, item) =>
                                                      sum +
                                                      double.parse(
                                                          item.moneyInOut!)),
                                        ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 120,
                              ),
                            ),
                            moneyData == null ||
                                    moneyData!
                                            .where(
                                                (item) => item.moneyType == '2')
                                            .fold(
                                                0.0,
                                                (sum, item) =>
                                                    sum +
                                                    double.parse(
                                                        item.moneyInOut!)) ==
                                        0
                                ? Text(
                                    '0.00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                : Text(
                                    NumberFormat('#,###.00').format(
                                      moneyData!
                                          .where(
                                              (item) => item.moneyType == '2')
                                          .fold(
                                              0.0,
                                              (sum, item) =>
                                                  sum +
                                                  double.parse(
                                                      item.moneyInOut!)),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 370,
                      bottom: 50,
                    ),
                    child: Center(
                      child: Text(
                        'เงินออก',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      top: MediaQuery.of(context).size.height * 0.525,
                    ),
                    child: TextField(
                      controller: moneyDetailCtrl,
                      decoration: InputDecoration(
                        labelText: 'รายการเงินออก',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: ' DETAIL',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3E7C78)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3E7C78)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      top: MediaQuery.of(context).size.height * 0.62,
                    ),
                    child: TextField(
                      controller: moneyInOutCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'จำนวนเงินออก',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: ' 0.00',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3E7C78)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3E7C78)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      top: MediaQuery.of(context).size.height * 0.715,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: moneyDateCtrl,
                            readOnly: true,
                            enabled: true,
                            decoration: InputDecoration(
                              labelText: 'วัน เดือน ปีที่เงินออก',
                              labelStyle: TextStyle(
                                color: Color(0xFF3E7C78),
                              ),
                              hintText: 'DATE INCOME',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF3E7C78)),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _openCalendar();
                                },
                                icon: ImageIcon(
                                    AssetImage(
                                      'assets/icons/calendar.png',
                                    ),
                                    size: MediaQuery.of(context).size.height *
                                        0.029),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      top: MediaQuery.of(context).size.height * 0.815,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (moneyDetailCtrl.text.trim().length == 0) {
                          showWaringDialog(context, 'ป้อนรายการเงินออกด้วย');
                        } else if (moneyInOutCtrl.text.trim().length == 0) {
                          showWaringDialog(context, 'ป้อนจำนวนเงินออกด้วย');
                        } else if (_DateSelected == '' ||
                            _DateSelected == null) {
                          showWaringDialog(
                              context, 'เลือกวัน เดือน ปีที่เงินออกด้วย');
                        } else {
                          Money money = Money(
                            moneyDetail: moneyDetailCtrl.text,
                            moneyInOut: moneyInOutCtrl.text,
                            moneyDate: moneyDateCtrl.text,
                            moneyType: '2',
                            userId: widget.user!.userId,
                          );
                          CallAPI.callInsertStatementAPI(money).then((value) {
                            if (value.message == '1') {
                              showCompleteDialog(
                                      context, 'บันทึกเงินออกสําเร็จ')
                                  .then((value) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HomeUI(user: widget.user),
                                        ),
                                      ));
                            } else {
                              showCompleteDialog(
                                  context, 'บันทึกเงินออกไม่สําเร็จ');
                            }
                          });
                        }
                      },
                      child: Text(
                        'บันทึกเงินออก',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        shadowColor: Color(0xFF1B5C58),
                        backgroundColor: Color(0xFF3E7C78),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.07,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}