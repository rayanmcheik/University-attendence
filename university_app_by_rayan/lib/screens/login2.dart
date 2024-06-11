import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_app_by_rayan/config.dart';
import 'package:university_app_by_rayan/screens/Home.dart';
import 'package:university_app_by_rayan/screens/Instructor.dart';
import 'package:university_app_by_rayan/screens/Registre.dart';
import 'package:university_app_by_rayan/screens/login.dart';
import 'package:university_app_by_rayan/widgets/input.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:http/http.dart' as http;

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  TextEditingController Id_university = TextEditingController();
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
  if (Id_university.text.isNotEmpty && password.text.isNotEmpty) {
    var reqBody = {
      "Id_university": Id_university.text,
      "password": password.text
    };

    var response = await http.post(
      Uri.parse(login2),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);

      // Accessing the value of 'l' from jsonResponse
      var l = jsonResponse['l'];

      if (l == 0) {
        // Navigate to HomePage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(
                    Name: jsonResponse['user']['Name'],
                    email: jsonResponse['user']['email'],
                    profileimg:jsonResponse['user']['profileimg'], 
                    Id_university: jsonResponse['user']['Id_university'],
                
                ),));
      } else {
        // Navigate to another page
        // Replace 'AnotherPage()' with the actual page you want to navigate to
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InstructorPage(                        nameIns: jsonResponse['user']['Name'],
                        EmailIns: jsonResponse['user']['email'],
                        profileimg: jsonResponse['user']['profileimg'],)));
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
  if (Id_university.text.isNotEmpty && password.text.isNotEmpty) {
    var reqBody = {
      "email": Id_university.text,
      "password": password.text
    };

    var response = await http.post(
      Uri.parse(login2Ins),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);

      // Accessing the value of 'l' from jsonResponse
      var l = jsonResponse['l'];

      if (l == 0) {
        // Navigate to HomePage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(
                    Name: jsonResponse['user']['Name'],
                    email: jsonResponse['user']['email'],
                    profileimg:jsonResponse['user']['profileimg'], 
                    Id_university: jsonResponse['user']['Id_university'],
                
                ),));
      } else {
        // Navigate to another page
        // Replace 'AnotherPage()' with the actual page you want to navigate to
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InstructorPage(
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
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 16, right: 16, bottom: 10),
                child: TextField(
                  controller: Id_university,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.pin),
                      labelText: 'University ID',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
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
                      "Login by Email",
                    ),
                 IconButton(
                        icon:    Icon(Icons.email, 
                                    
                       
                        ), onPressed: () {     Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => LoginPage(),
                ),
              ); },
                        ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {loginUser() ;},
                child: Text("  Login  ",
                    style: GoogleFonts.abrilFatface(
                        textStyle: TextStyle(color: Colors.white, fontSize: 25))),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.only(left: 120, right: 120, top: 10, bottom: 10),
                  backgroundColor: Color.fromARGB(255, 90, 3, 252),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8)), // Button border radius
                  textStyle: TextStyle(fontSize: 18), // Text style
                ),
              ),
              SizedBox(height: 10,),
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
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          });
                        },
                        child:   Text(
                  "Sign up",
                  style: TextStyle(color: Color.fromARGB(255, 90, 3, 252),),
                ),
                      ),
            
              ],
            ),
            SizedBox(height: 80,)
            ],
          ),
        ),
      ),
    );
  }
}
