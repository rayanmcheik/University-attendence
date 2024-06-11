import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:university_app_by_rayan/screens/Registre.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:university_app_by_rayan/screens/login.dart';



class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        addButton: true,
  
        finishButtonText: 'Register',
        
        
        onFinish: () {

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
        },
        finishButtonStyle: FinishButtonStyle(

          backgroundColor: Color.fromARGB(255, 82, 25, 241),
          
        ),
        
        skipTextButton: Text('Skip'),
         trailing: GestureDetector(
          onTap: () {
            // Navigation logic to go to the login page
            
          },
          
        ),
        pageBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        totalPage: 3,
        background: [
          Image.network(
            'https://images.template.net/82880/free-studying-illustration-tmpqs.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / 1,
          ),
          Image.network(
            'https://img.freepik.com/free-vector/boy-student-sitting-stack-books-with-laptop-flat-icon-illustration_1284-64037.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / 1,
          ),
          Image.network(
            'https://img.freepik.com/free-vector/girl-writing-journal-diary_74855-7408.jpg?size=626&ext=jpg&ga=GA1.1.1224184972.1711929600&semt=ais',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width / 1,
          ),
        ],
        controllerColor: Color.fromARGB(255, 68, 0, 255),
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 350),
            child: GradientAnimationText(
              text: Text(
                'Welcome to Crestview University',
                style: TextStyle(
                 fontSize: 50,
                   fontWeight: FontWeight.bold,
                ),
                
              ),
              
              colors: [
                Color.fromARGB(255, 202, 190, 253),
                Color.fromARGB(255, 99, 46, 245),
              ],
              duration: Duration(seconds: 5),
              transform: GradientRotation(math.pi / 4), // tranform
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 350,right: 10),
            child:Text("Embark on your academic journey with ease . Welcome to your personalized course hub, where all your enrolled courses await.",
            style:GoogleFonts.breeSerif(
                      textStyle: 
   TextStyle(
          fontSize: 27, // Set your desired font size here
          color: Color.fromARGB(255, 99, 46, 245),
        ),
            ),
          ),),
          Container(
            padding: EdgeInsets.only(left: 20, top: 300,right: 20),
            child: Column(
              children: [
               
               Text("Mark your attendance effortlessly across all your courses with just a tap!",style:GoogleFonts.breeSerif(
                      textStyle: 
   TextStyle(
          fontSize: 30, // Set your desired font size here
          color: Color.fromARGB(255, 99, 46, 245),
        ),
     
               ),
),
                
               
 SizedBox(height: 70,),
                ElevatedButton(onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          ), child:Text("Login",
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsets.only(left: 103, right: 103, top: 12, bottom: 12),
                backgroundColor:  Color.fromARGB(255, 82, 25, 241),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5)), // Button border radius
                textStyle: TextStyle(fontSize: 18), // Text style
              ),
               ),
              ],
            ),
   
          ),
        ],
      ),
    );
  }
}
