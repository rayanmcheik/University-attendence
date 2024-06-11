import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:university_app_by_rayan/config.dart';
import 'package:university_app_by_rayan/screens/Registre.dart';
import 'package:university_app_by_rayan/widgets/input.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:http/http.dart' as http;

class InstructorPage extends StatefulWidget {
  final String nameIns;
  final String EmailIns;
  final String? profileimg;
  const InstructorPage({Key? key,required this.nameIns,required this.EmailIns,required this.profileimg}) : super(key: key);

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}
class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });
}


class _InstructorPageState extends State<InstructorPage> {
  TextEditingController emailIns = TextEditingController();
  TextEditingController NameIns = TextEditingController();
  TextEditingController Id_university_ins = TextEditingController();
  TextEditingController passwordIns = TextEditingController();
  TextEditingController NameSub = TextEditingController();
  bool isNotValidate = false;
  File? _ProfileImageIns;
  int _tabIndex = 1;
  int get tabIndex => _tabIndex;
  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor = Colors.blue;
  Color? _shadeColor = Colors.blue[800];
  Color? _selectedColor;

  String imgs='';

 List<ValueItem> _userOptions = [];
   List<ValueItem> selcteddOptions = [];

Future<void> fetchUsers() async {
  try {
    final response = await http.get(Uri.parse(userss));
    if (response.statusCode == 200) {
      final List<dynamic> usersData = json.decode(response.body);
      List<ValueItem> userOptions = [];
      for (var userData in usersData) {
        userOptions.add(
          ValueItem(label: userData['Name'], value: userData['Name']),
        );
      }
      setState(() {
        _userOptions = userOptions;
      });
    } else {
      throw Exception('Failed to load users');
    }
  } catch (err) {
    throw Exception('Failed to load users: $err');
  }
}


set tabIndex(int v) {
  _tabIndex = v;
  setState(() {});
}
void getAllUsers() async {
  try {
    final response = await http.get(Uri.parse(userss));
    if (response.statusCode == 200) {
      final List<dynamic> usersData = json.decode(response.body);
      List<ValueItem> userOptions = [];
      for (var userData in usersData) {
        userOptions.add(
          ValueItem(label: userData['user']['name'], value: userData['user']['name']),
        );
      }
      setState(() {
        _userOptions = userOptions;
      });
    } else {
      throw Exception('Failed to load users');
    }
  } catch (err) {
    throw Exception('Failed to load users: $err');
  }
}
  late PageController pageController;

  @override
  void initState() {
    super.initState();
        fetchUsers();
    pageController = PageController(initialPage: _tabIndex);
  }



//   

void AddSubjects() async {
  if (NameSub.text.isNotEmpty) {
    List<dynamic> students = selcteddOptions.map((option) {
      return {
        "name": option.value.toString(), 
      };
    }).toList();

    var regBody = {
      "NameSub": NameSub.text,
      "backgroundColor": _selectedColor != null ? _selectedColor!.value.toString() : null,
      "NameIns": widget.nameIns,
      "emailIns": widget.EmailIns,
      "students": students,
    };

    try {
      var response = await http.post(
        Uri.parse(addSubjecttt),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);

      print("Response: $jsonResponse");

      if (jsonResponse['status']) {
        // Success
        print("Subject added successfully");

      } else {
        // Show error message to the user
        print("Failed to add subject");
      }
    } catch (e) {
      // Handle HTTP request errors
      print("HTTP Request Error: $e");
    }
  } else {
    setState(() {
      isNotValidate = true;
    });
  }
}


void registerIns()async{

      if(emailIns.text.isNotEmpty && passwordIns.text.isNotEmpty ){

final bytes = File(_ProfileImageIns!.path).readAsBytesSync();  
String base64Image = base64Encode(bytes);
 String l="";
 l="1";
        var regBody={
          
          "NameIns":NameIns.text, 
          "emailIns":emailIns.text,
          "passwordIns":passwordIns.text,
          "profileimgIns":base64Image,
          "Id_university_Ins":Id_university_ins.text,
          "l":l.toString(),
        };

var response = await http.post(Uri.parse(register_Ins),
headers: {"Content-Type":"application/json"},
body: jsonEncode(regBody)


);
var jsonResponse =  jsonDecode(response.body);

      print(jsonResponse['status']);

      if(jsonResponse['status']){
      
    }else{
      setState(() {
        isNotValidate = true;
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.person_add_alt_rounded,
              color: Color.fromARGB(255, 255, 2, 2)),
          Icon(
            Icons.add,
            color: Color.fromARGB(255, 0, 255, 85),
            size: 40,
            
          ),
          Icon(Icons.group_add, color: Colors.blue),
        ],
        inactiveIcons: const [
          Text("Add admin"),
          Text("Add subjects"),
          Text("Add student"),
        ],
        color: Colors.white,
        height: 60,
        circleWidth: 60,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.red,
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
                            color: Color.fromARGB(255, 250, 144, 162),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _ProfileImageIns != null
                                    ? Image.file(
                                        _ProfileImageIns!,
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
                              size: 60,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          onPressed: () {
                            pickimage();
                          },
                        ),
                      ),
                    ],
                  ),
                  Input(
                    controller: NameIns,
                    obscureText: false,
                    title: "Name",
                    t: isNotValidate,
                    iconn: Icons.person,
                  ),
                  Input(
                    controller: emailIns,
                    obscureText: false,
                    title: "Email",
                    t: isNotValidate,
                    iconn: Icons.email,
                  ),
                  Input(
                    controller: passwordIns,
                    obscureText: true,
                    title: "Password",
                    t: isNotValidate,
                    iconn: Icons.password,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 16, right: 16, bottom: 10),
                    child: TextField(
                      controller: Id_university_ins,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.pin),
                          labelText: 'Enter Your University Id',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {registerIns();},
                    child: Text("Add Admin",
                        style: GoogleFonts.abrilFatface(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 25))),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                          left: 100, right: 100, top: 10, bottom: 10),
                      backgroundColor: Color.fromARGB(255, 250, 144, 162),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)), // Button border radius
                      textStyle: TextStyle(fontSize: 18), // Text style
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------------------------------------------------------------------------------------

          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.green,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100,),
                    Text("ADD Subject",style: TextStyle(color: Colors.white,fontSize: 20),),
                    Input(controller: NameSub, obscureText: false, title: "Name Subject", iconn: Icons.arrow_right_outlined, t: isNotValidate),
 SizedBox(height: 20),
 Text("Choose background color",style:TextStyle(color: Colors.white)),
  SizedBox(height: 20),
 MaterialColorPicker(
  allowShades: true,
  onColorChange: (Color color) {
    setState(() {
      _selectedColor = color;
    });
  },
  selectedColor: _selectedColor ?? Color.fromARGB(255, 66, 2, 241),
),

 Text("Choose student",style:TextStyle(color: Colors.white)),
  SizedBox(height: 20),
MultiSelectDropDown(
  showClearIcon: true,
  onOptionSelected: (options) {
    debugPrint("Selected options: $options");
    setState(() {
      selcteddOptions = options.cast<ValueItem>(); // Update selected options
    });
  },
  options: _userOptions,
  selectionType: SelectionType.multi,
  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
  dropdownHeight: 300,
  optionTextStyle: const TextStyle(fontSize: 16),
  selectedOptionIcon: const Icon(Icons.check_circle),
  selectedOptions: selcteddOptions, // Pass selected options
),


  SizedBox(height: 20),
ElevatedButton(
  onPressed: () {
    print("Button pressed");
    AddSubjects();
  },
  child: Icon(Icons.assignment_add, size: 40, color: Colors.green),
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.all(10),
    backgroundColor: Color.fromARGB(255, 225, 253, 240),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    textStyle: TextStyle(fontSize: 18),
  ),
),

                  SizedBox(height: 60,)
                  ],
                ),
              )),

          // --------------------------------------------------------------------------------------------------------------------------------

          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blue),
        ],
      ),
    );
  }

  Future pickimage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      _ProfileImageIns = File(pickedImage.path);
    });
  }


}
