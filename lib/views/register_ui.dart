// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_is_empty

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:explo/models/user.dart';
import 'package:explo/services/call_api.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  bool _obscurePssword = true;

  TextEditingController userFullNameCtrl = TextEditingController(text: '');
  TextEditingController userBirthDateCtrl = TextEditingController(text: '');
  TextEditingController userNameCtrl = TextEditingController(text: '');
  TextEditingController userPasswordCtrl = TextEditingController(text: '');

  // สร้างตัวแปร image ให้เก็บไฟล์ภาพที่ถ่ายจากกล้อง/เลือกจากแกลลอรี่
  File? _imageSelected;

  String? _image64Selected, _BirthDateSelected;

  //method เปิดกล้องถ่ายรูป
  Future<void> _openCamera() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _image64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

  //method เปิดแกลลอรี่เลือกรูป
  Future<void> _openGallery() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _image64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
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

  //เปิดปฏิทินเลือกวันที่
  Future<void> _showCalendar() async {
    final DateTime? _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(2100),
    );
    //นำค่าวันที่ที่เลือกมาแสดงใน TextField
    if (_picker != null) {
      setState(() {
        _BirthDateSelected = _picker.toString().substring(0, 10); //2024-01-31
        userBirthDateCtrl.text = convertToThaiDate(_picker); //31 มกราคม 2567
      });
    }
  }

  //เมธอดแปลงวันที่แบบสากล (ปี ค.ศ.-เดือน ตัวเลข-วัน ตัวเลข) ให้เป็นวันที่แบบไทย (วัน เดือน ปี)
  //                             2023-11-25
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

    return int.parse(day).toString() + ' ' + month + ' ' + year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3E7C78),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        backgroundColor: Color(0xFF3E7C78),
        title: Text(
          'ลงทะเบียน',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.020,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: ImageIcon(
            AssetImage('assets/icons/back.png'),
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(
                        'ข้อมูลผู้ใช้งาน',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        _openCamera().then(
                                            (value) => Navigator.pop(context));
                                      },
                                      leading: Icon(
                                        Icons.camera_alt,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        'Open Camera...',
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 5.0,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        _openGallery().then(
                                            (value) => Navigator.pop(context));
                                      },
                                      leading: Icon(
                                        Icons.browse_gallery,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        'Open Gallery...',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                // border: Border.all(width: 0.1, color: Colors.grey),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: _imageSelected == null
                                      ? AssetImage(
                                          'assets/images/user.png',
                                        )
                                      : FileImage(_imageSelected!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          controller: userFullNameCtrl,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Color(0xFF666666),
                            ),
                            labelText: 'ชื่อ-สกุล',
                            hintText: 'YOUR NAME',
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
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(children: [
                                TextField(
                                  controller: userBirthDateCtrl,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Color(0xFF666666),
                                    ),
                                    labelText: 'วัน-เดือน-ปี เกิด',
                                    hintText: 'YOUR BIRTHDAY',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    disabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF3E7C78)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF3E7C78)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 288, top: 4),
                                  child: IconButton(
                                    onPressed: () {
                                      _showCalendar();
                                    },
                                    icon: ImageIcon(
                                        AssetImage(
                                          'assets/icons/calendar.png',
                                        ),
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.029),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                        child: TextField(
                          controller: userNameCtrl,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Color(0xFF666666),
                            ),
                            labelText: 'ชื่อผู้ใช้',
                            hintText: 'USERNAME',
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
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                        child: TextField(
                          controller: userPasswordCtrl,
                          obscureText: _obscurePssword,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Color(0xFF666666),
                              ),
                              labelText: 'รหัสผ่าน',
                              hintText: 'PASSWORD',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF3E7C78)),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF3E7C78)),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: IconButton(
                                icon: _obscurePssword
                                    ? ImageIcon(
                                        AssetImage('assets/icons/lock.png'))
                                    : Icon(FontAwesomeIcons.unlockKeyhole),
                                onPressed: () {
                                  setState(() {
                                    _obscurePssword = !_obscurePssword;
                                  });
                                },
                              )),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 40),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_imageSelected == null) {
                                showWaringDialog(context,
                                    'กรุณาถ่ายรูป/อัปโหลดรูปโปรไฟล์ด้วย');
                              } else if (userFullNameCtrl.text.trim().length ==
                                  0) {
                                showWaringDialog(context, 'กรุณาป้อนชื่อ-สกุล');
                              } else if (_BirthDateSelected == '' ||
                                  _BirthDateSelected == null) {
                                showWaringDialog(context, 'กรุณาเลือกวันเกิด');
                              } else if (userNameCtrl.text.trim().length == 0) {
                                showWaringDialog(
                                    context, 'กรุณาป้อนชื่อผู้ใช้');
                              } else if (userPasswordCtrl.text.trim().length ==
                                  0) {
                                showWaringDialog(context, 'กรุณาป้อนรหัสผ่าน');
                              } else {
                                User user = User(
                                  userFullName: userFullNameCtrl.text,
                                  userBirthDate: userBirthDateCtrl.text,
                                  userName: userNameCtrl.text,
                                  userPassword: userPasswordCtrl.text,
                                  userImage: _image64Selected,
                                );
                                CallAPI.callRegisterAPI(user).then((value) {
                                  if (value.message == '1') {
                                    showCompleteDialog(
                                            context, 'ลงทะเบียนสำเร็จ')
                                        .then(
                                            (value) => Navigator.pop(context));
                                  } else {
                                    showCompleteDialog(context,
                                        'เกิดข้อผิดพลาดในการลงทะเบียน กรุณาลองใหม่อีกครั้ง');
                                  }
                                });
                              }
                            },
                            child: Text(
                              'บันทึกการลงทะเบียน',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.018,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3E7C78),
                                elevation: 15,
                                shadowColor:
                                    Color.fromARGB(255, 133, 225, 219)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.065,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}