import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:university_app_by_rayan/config.dart';
import 'package:university_app_by_rayan/screens/Card_Page.dart';
import 'package:university_app_by_rayan/screens/Home.dart';
import 'package:university_app_by_rayan/screens/Instructor.dart';
import 'package:university_app_by_rayan/screens/Registre.dart';
import 'package:university_app_by_rayan/screens/login2.dart';
import 'package:university_app_by_rayan/widgets/input.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      var reqBody = {"email": email.text, "password": password.text};

      var response = await http.post(
        Uri.parse(login1),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);

        var p;
        p = jsonResponse['user']['l'];

        if (p == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  Name: jsonResponse['user']['Name'],
                  email: jsonResponse['user']['email'],
                  profileimg: jsonResponse['user']['profileimg'],
                  Id_university: jsonResponse['user']['Id_university'],
                ),

              ));
             CardPage(
                        students: [],
                        studentName: jsonResponse['user']['Name'], 
                      );
         //     studentt(namee:  jsonResponse['user']['Name'],);
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => InstructorPage(
                                        nameIns: jsonResponse['user']['Name'],
                        EmailIns: jsonResponse['user']['email'],
                        profileimg: jsonResponse['user']['profileimg'],)));


                      //  User(name:jsonResponse['user']['Name'], email: jsonResponse['user']['email']);
        }
      } else {
        print('Something went wrong');
      }
    } else {
      setState(() {
        isNotValidate = true;
      });
    }
  }

  void loginIns() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      var reqBody = {"email": email.text, "password": password.text};

      var response = await http.post(
        Uri.parse(login1Ins),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);

        var p;
        p = jsonResponse['user']['l'];

        if (p == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  Name: jsonResponse['user']['Name'],
                  email: jsonResponse['user']['email'],
                  profileimg: jsonResponse['user']['profileimg'],
                  Id_university: jsonResponse['user']['Id_university'],
                ),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => InstructorPage(
                        nameIns: jsonResponse['user']['Name'],
                        EmailIns: jsonResponse['user']['email'],
                        profileimg: jsonResponse['user']['profileimg'],
                      )));
        }
      } else {
        print('Something went wrong');
      }
    } else {
      setState(() {
        isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://i.pinimg.com/originals/b2/b5/7d/b2b57d79b56c02b0a2c08dfdb07c520c.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 140,
              ),
              Stack(
                children: [
                  Positioned(
                    child: CircularText(children: [
                      TextItem(
                        text: Text(
                          "Crestview University".toUpperCase(),
                          style: TextStyle(
                            fontSize: 28,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        space: 10,
                        startAngle: -90,
                        startAngleAlignment: StartAngleAlignment.center,
                        direction: CircularTextDirection.clockwise,
                      ),
                    ]),
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Image.network(
                        "https://static.vecteezy.com/system/resources/thumbnails/006/897/801/small/eagle-design-for-logo-icon-vector.jpg",
                        width: 190,
                        height: 190,
                      ),
                    ),
                  ),
                ],
              ),
              Input(
                controller: email,
                obscureText: false,
                title: "Email",
                t: isNotValidate,
                iconn: Icons.email,
              ),
              Input(
                controller: password,
                obscureText: true,
                title: "Password",
                t: isNotValidate,
                iconn: Icons.password,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "Login by ID",
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.pin,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage2(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  loginUser();
                  loginIns();
                },
                child: Text("  Login  ",
                    style: GoogleFonts.abrilFatface(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 25))),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(
                      left: 120, right: 120, top: 10, bottom: 10),
                  backgroundColor: Color.fromARGB(255, 90, 3, 252),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8)), // Button border radius
                  textStyle: TextStyle(fontSize: 18), // Text style
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an account ? "),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      });
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 90, 3, 252),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
