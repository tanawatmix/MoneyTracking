// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:explo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:explo/models/money.dart';
import 'package:explo/services/call_api.dart';
import 'package:explo/utils/env.dart';
import 'package:explo/views/welcome_ui.dart';

class MainViewUI extends StatefulWidget {
  User? user;
  MainViewUI({super.key, this.user});

  @override
  State<MainViewUI> createState() => _MainViewUIState();
}

class _MainViewUIState extends State<MainViewUI> {
  List<Money>? moneyData;
  double totalBalance = 0.0;

  // Fetch data from the API
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
    var money = Money(userId: widget.user!.userId);
    callGetAllStatementByUserId(money);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: Color(0xFF3E7C78),
              borderRadius: BorderRadius.vertical(
                bottom:
                    Radius.elliptical(MediaQuery.of(context).size.width, 100.0),
              ),
            ),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => WelcomeUI()));
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
              width: MediaQuery.of(context).size.width,
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
                              AssetImage('assets/icons/income.png'),
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height * 0.029,
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
                          AssetImage('assets/icons/outcome.png'),
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
                                            .where(
                                                (item) => item.moneyType == '1')
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
                                              (item) => item.moneyType == '1')
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
                                        .where((item) => item.moneyType == '2')
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
                                      .where((item) => item.moneyType == '2')
                                      .fold(
                                          0.0,
                                          (sum, item) =>
                                              sum +
                                              double.parse(item.moneyInOut!)),
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
          Padding(
              padding: EdgeInsets.only(top: 360),
              child: moneyData == null || moneyData!.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          'ไม่มีรายการเงินเข้า/เงินออก',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        Positioned.fill(
                          top: MediaQuery.of(context).size.height * 0.025,
                          child: ListView.builder(
                            itemCount: moneyData!.length,
                            itemBuilder: (context, index) {
                              final transaction = moneyData![index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: transaction.moneyType == '1'
                                        ? Image.asset(
                                            'assets/icons/come.png',
                                            width: 30,
                                          )
                                        : Image.asset(
                                            'assets/icons/out.png',
                                            width: 30,
                                          ),
                                    title: Text(
                                        transaction.moneyDetail ?? 'No Detail'),
                                    subtitle: Text(transaction.moneyDate ??
                                        'Unknown Date'),
                                    trailing: Text(
                                      transaction.moneyInOut == null ||
                                              double.parse(transaction
                                                      .moneyInOut!) ==
                                                  0
                                          ? '0.00'
                                          : NumberFormat('#,###.00').format(
                                              double.parse(
                                                  transaction.moneyInOut!)),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: transaction.moneyType == '1'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color:
                                        Colors.grey, // Adjust the divider color
                                    thickness:
                                        1, // Adjust the divider thickness
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  padding: EdgeInsets.only(),
                                  child: Text(
                                    'เงินเข้า/เงินออก',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
        ],
      ),
    );
  }
}