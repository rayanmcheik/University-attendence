import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:background_bubbles/background_bubbles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_drawer/sliding_drawer.dart';
import 'package:university_app_by_rayan/config.dart';
import 'package:university_app_by_rayan/screens/Card_Page.dart';
import 'package:university_app_by_rayan/screens/Welcome.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:university_app_by_rayan/screens/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


String? Name1="";

class HomePage extends StatefulWidget {
  final String Name;
  final String email;
  final String Id_university;
  final String? profileimg;

  const HomePage({
    Key? key,
    required this.Name,
    required this.email,
    required this.profileimg,
    required this.Id_university,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SlidingDrawerController _drawerController = SlidingDrawerController();

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  List<dynamic> _subjects = [];




  Future<void> _fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse(subjects));

      if (response.statusCode == 200) {
        final List<dynamic> subjectsData = json.decode(response.body);
        setState(() {
          _subjects = subjectsData;
        });
      } else {
        print('Failed to fetch subjects: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching subjects: $error');
    }
  }

  Future<void> _infoInstructor(
      String name, String email, String imgInstructor) async {
    print("Opening modal bottom sheet...");
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        print("Building modal bottom sheet...");
        return Container(
          width: MediaQuery.of(context).size.width / 1,
          height: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color.fromARGB(255, 173, 173, 173),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: ClipOval(
                  child: Image.network(
                    imgInstructor ??
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLLEQi867pCGSjQjqD5fmjpSlZenWMhUGGtYaVNdEzA09wNb5VekVoO-iW1LuArPwGSko&usqp=CAU",
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: Text(
                  email,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Send Email"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          SlidingDrawer(
            controller: _drawerController,
            shadeColor: Colors.black.withOpacity(0.35),
            axisDirection: AxisDirection.right,
            onShadedAreaTap: () {
              _drawerController.animateClose(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            drawer: DrawerWidget(
              Name: widget.Name,
              email: widget.email,
              Id_university: widget.Id_university,
              profileimg: widget.profileimg,
            ),
            body: BodyWidget(
              onMenuPressed: () {
                _drawerController.animateOpen(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              infoInstructorCallback: _infoInstructor,
              subjects: _subjects, studentName:Name1 ,
            ),
          ),
        ],
      ),
    );
  }
}
class Nameee extends StatefulWidget {
  final String? name;
  const Nameee({
    Key? key,
    required this.name,

  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class DrawerWidget extends StatelessWidget {
  final String? Name;
  final String? email;
  final String? Id_university;
  final String? profileimg;

  const DrawerWidget({
    Key? key,
    this.Name,
    this.email,
    this.Id_university,
    this.profileimg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
Nameee(name: Name);
Name1 = Name;
    Uint8List? profileImgBytes;
    if (profileimg != null) {
      profileImgBytes = base64Decode(profileimg!);
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                SizedBox(height: 5),
                ClipOval(
                  child: profileImgBytes != null && profileImgBytes.isNotEmpty
                      ? Image.memory(
                          profileImgBytes,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        )
                      : Icon(Icons.account_circle_rounded,
                          color: Colors.white, size: 100),
                ),
                Text(
                  Name ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            subtitle: Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 10),
                Text(email ?? ''),
              ],
            ),
          ),
          ListTile(
            subtitle: Row(
              children: [
                Icon(Icons.pin),
                SizedBox(width: 10),
                Text(Id_university ?? ''),
              ],
            ),
          ),
          SizedBox(height: 280),
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: ListTile(
              subtitle: Row(
                children: [
                  Icon(Icons.logout_outlined),
                  SizedBox(width: 10),
                  Text("Logout"),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final Function(String, String, String) infoInstructorCallback;
  final List<dynamic> subjects;
  final String? studentName;

  const BodyWidget({
    Key? key,
    required this.onMenuPressed,
    required this.infoInstructorCallback,
    required this.subjects,
    required this.studentName, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 195, 253),
        leading: IconButton(
          icon: Icon(
            Icons.person_outline_rounded,
            size: 40,
          ),
          onPressed: onMenuPressed,
        ),
      ),
      body: BubblesAnimation(
        backgroundColor: Colors.white,
        particleColor: Color.fromARGB(255, 216, 195, 253),
        particleCount: 200,
        particleRadius: 3,
        widget: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subjectt = subjects[index];
            final backgroundColor =
                Color(int.parse(subjectt['backgroundColor'], radix: 16))
                    .withOpacity(1.0);

            final String nameSub = subjectt['NameSub'] ?? '';
            final String nameIns = subjectt['NameIns'] ?? '';

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardPage(
                        students: [subjectt['students']],
                        studentName: Name1 ?? '', 
                      ),
                    ),
                  );
                },
                child: Card(
                  color: backgroundColor,
                  child: ListTile(
                    subtitle: Stack(
                      children: [
                        Positioned(
                          top: 20,
                          left: 15,
                          child: Text(
                            nameSub,
                            style: GoogleFonts.breeSerif(
                              textStyle: TextStyle(
                                fontSize: 40,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      print("Building modal bottom sheet...");
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height: 290,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          color: Color.fromARGB(
                                              255, 173, 173, 173),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: ClipOval(
                                                child: Image.network(
                                                  //   imgInstructor ??
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLLEQi867pCGSjQjqD5fmjpSlZenWMhUGGtYaVNdEzA09wNb5VekVoO-iW1LuArPwGSko&usqp=CAU",
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  subjectt['NameIns'],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Center(
                                              child: Text(
                                                subjectt['emailIns'],
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _launchEmailApp();
                                                },
                                                child: Text("Send Email"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ClipOval(
                                  child: Image.network(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLLEQi867pCGSjQjqD5fmjpSlZenWMhUGGtYaVNdEzA09wNb5VekVoO-iW1LuArPwGSko&usqp=CAU",
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 0,
                          child: Column(
                            children: [
                              Icon(Icons.supervised_user_circle_outlined,
                                  color: Colors.white, size: 30)
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 55,
                          width: 380,
                          child: Divider(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        SizedBox(
                          height: 180,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
}


void _launchEmailApp() async {
  const url = 'https://mail.google.com/mail/u/0/#inbox?compose=new';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
