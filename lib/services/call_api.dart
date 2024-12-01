
import 'dart:convert';

import 'package:explo/models/money.dart';
import 'package:explo/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:explo/utils/env.dart';

class CallAPI {
  static Future<User> callCheckLoginAPI(User user) async {
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/moneytrackingAPI/apis/check_login_api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (responseData.statusCode == 200) {
      print(responseData.body);
      return User.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }

  static Future<User> callRegisterAPI(User user) async {
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/moneytrackingAPI/apis/register_api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (responseData.statusCode == 200) {
      return User.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }

  static Future<List<Money>> callGetAllStatementByUserId(Money trip) async {
    final responseData = await http.post(
      Uri.parse(Env.hostName +
          '/moneytrackingAPI/apis/get_all_statement_by_user_id_api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(trip.toJson()),
    );

    if (responseData.statusCode == 200) {
      final responseBody = jsonDecode(responseData.body);

      // ตรวจสอบว่าข้อมูลที่ได้รับคือ List หรือไม่
      if (responseBody is List) {
        final dataList = responseBody.map<Money>((json) {
          return Money.fromJson(json);
        }).toList();
        return dataList;
      } else {
        return []; // หากไม่มีข้อมูล หรือข้อมูลไม่ใช่ List ให้คืนค่าลิสต์ว่าง
      }
    } else {
      throw Exception('Failed to call API');
    }
  }

  static Future<Money> callInsertStatementAPI(Money trip) async {
    final responseData = await http.post(
      Uri.parse(
          Env.hostName + '/moneytrackingAPI/apis/insert_statement_api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(trip.toJson()),
    );
    if (responseData.statusCode == 200) {
      return Money.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }

  static checkPassAPI(User user) {}
}