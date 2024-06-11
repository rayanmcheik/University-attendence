import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university_app_by_rayan/config.dart';
import 'package:university_app_by_rayan/screens/Home.dart';
import 'package:university_app_by_rayan/screens/login.dart';
import 'package:university_app_by_rayan/widgets/input.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController Id_university = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isNotValidate = false;

  File? _ProfileImage;

  void registerUser() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      final bytes = File(_ProfileImage!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      String l = "";
      l = "0";
      var regBody = {
        "Name": Name.text,
        "email": email.text,
        "password": password.text,
        "profileimg": base64Image,
        "Id_university": Id_university.text,
        "l": l.toString(),
      };

      var response = await http.post(Uri.parse(register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));
      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                Name:Name.text,
                email: email.text,
                profileimg:base64Image,
                Id_university: Id_university.text,
              ),
            ));
        print("SomeThing Went Wrongsssss");
      } else {
        print("SomeThing Went Wrong");
      }
    } else {
      setState(() {
        isNotValidate = true;
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>registre_screen()));
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_ProfileImage == null) return;

    // Replace the URL with your server endpoint
    final url = Uri.parse(upload);

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(
            await http.MultipartFile.fromPath('uploads', _ProfileImage!.path));
      final bytes = File(_ProfileImage!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle success
        print('Image uploaded successfully');
      } else {
        // Handle failure
        print('Failed to upload image');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://w0.peakpx.com/wallpaper/172/817/HD-wallpaper-paper-white-bertil-paper-abstract-background-lines-simple-white-thumbnail.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  // Person icon
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Color.fromARGB(255, 111, 88, 241),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _ProfileImage != null
                                ? Image.file(
                                    _ProfileImage!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.person_pin,
                                    size: 150,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Camera icon
                  Positioned(
                    top: 120,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo_outlined,
                          size: 60, color: Colors.black),
                      onPressed: () {
                        pickimage();
                      },
                    ),
                  ),
                ],
              ),
              Input(
                controller: Name,
                obscureText: false,
                title: "Name",
                t: isNotValidate,
                iconn: Icons.person,
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
                padding: const EdgeInsets.only(
                    top: 10, left: 16, right: 16, bottom: 10),
                child: TextField(
                  controller: Id_university,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.pin),
                      labelText: 'Enter Your University Id',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  registerUser();
                },
                child: Text("Sign up",
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
                  Text("Already have an account ? "),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      });
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Color.fromARGB(255, 90, 3, 252),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickimage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      _ProfileImage = File(pickedImage.path);
    });
  }
}
