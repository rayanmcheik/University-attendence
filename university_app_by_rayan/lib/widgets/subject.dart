import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class subject extends StatefulWidget {
  const subject({super.key});

  @override
  State<subject> createState() => _subjectState();
}

class _subjectState extends State<subject> {
    late final VoidCallback onMenuPressed;
  late final Function(String, String, String) infoInstructorCallback;
  @override
  Widget build(BuildContext context) {
    return  Card(
                  color: Color.fromARGB(255, 94, 37, 250),
                  child: ListTile(
                    subtitle: Stack(
                      children: [
                        Positioned(
                          top: 20,
                          left: 15,
                          child: Text(
                            "MC101",
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
                                  print("Double tap detected, calling _Info_Instructor...");
                                  infoInstructorCallback("Name", "email", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLLEQi867pCGSjQjqD5fmjpSlZenWMhUGGtYaVNdEzA09wNb5VekVoO-iW1LuArPwGSko&usqp=CAU");
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
                );
  }
}