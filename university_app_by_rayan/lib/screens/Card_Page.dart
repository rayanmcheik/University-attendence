import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:university_app_by_rayan/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CardPage extends StatefulWidget {
  final List<dynamic> students;
  final String studentName;
  const CardPage({Key? key, required this.students, required this.studentName}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Map<DateTime, List<String>> _events;
  Map<DateTime, List<String>> dailyAttendance = {};

  int _tabIndex = 1;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {};
    pageController = PageController(initialPage: _tabIndex);
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    final response = await http.get(Uri.parse(getAttendencee));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        dailyAttendance.clear();
        data.forEach((date, students) {
          dailyAttendance[DateTime.parse(date)] = List<String>.from(students);
        });
      });
    } else {
      print('Failed to fetch attendance. Error code: ${response.statusCode}');
    }
  }

  void addAttendance(DateTime date, String studentName) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      bool isUpdate = dailyAttendance.containsKey(date);

      if (isUpdate) {
        final List<String> students = dailyAttendance[date]!;
        if (!students.contains(studentName)) {
          students.add(studentName);
          dailyAttendance[date] = students;
        }

        final response = await http.put(
          Uri.parse(UpdateAttendance.replaceAll(':attendanceId', formattedDate)),
          body: jsonEncode({
            'date': formattedDate,
            'studentName': studentName,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('Attendance updated successfully');
        } else {
          print('Failed to update attendance. Error code: ${response.statusCode}');
        }
      } else {
        dailyAttendance[date] = [studentName];

        final response = await http.post(
          Uri.parse(AddAttendencee),
          body: jsonEncode({
            'date': formattedDate,
            'studentName': studentName,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('Attendance added successfully');
        } else {
          print('Failed to add attendance. Error code: ${response.statusCode}');
        }
      }

      setState(() {});

    } catch (e) {
      print('Error adding/updating attendance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.verified_user_sharp, color: Color.fromARGB(255, 0, 255, 115)),
          Icon(Icons.home, color: Colors.deepPurple),
          Icon(Icons.people_sharp, color: Colors.deepPurple),
        ],
        inactiveIcons: const [
          Text("Attendance"),
          Text("Home"),
          Text("People"),
        ],
        color: Colors.white,
        height: 60,
        circleWidth: 60,
        activeIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
            pageController.jumpToPage(_tabIndex);
          });
        },
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) {
          _tabIndex = index;
        },
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.green,
            child: ListView.builder(
              itemCount: dailyAttendance.length,
              itemBuilder: (context, index) {
                final date = dailyAttendance.keys.toList()[index];
                final students = dailyAttendance[date];

                return Card(
                  child: ListTile(
                    title: Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                    subtitle: Text('Students: ${students!.join(", ")}'),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/736x/b6/88/73/b6887332e89c7fec0471837084b60bbf.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 60),
                TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  headerStyle: HeaderStyle(
                    headerPadding: EdgeInsets.all(8),
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white, size: 35),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white, size: 35),
                    formatButtonVisible: false,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 96, 78, 253),
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 73, 9, 248),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    outsideTextStyle: TextStyle(color: Color.fromARGB(214, 78, 76, 76)),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                SizedBox(height: 100),
                LiteRollingSwitch(
                  value: dailyAttendance.containsKey(_selectedDay),
                  textOn: 'Attend',
                  textOff: 'Absent',
                  iconOn: Icons.done,
                  iconOff: Icons.remove_circle_outline,
                  textSize: 16.0,
                  width: 150,
                  onChanged: (bool state) {
                    // if (state) {
                    //   addAttendance(_selectedDay, widget.studentName);
                    // } else {

                    // }
                  },
                  onTap: () {
                    addAttendance(_selectedDay, widget.studentName);
                  },     
                    onDoubleTap: () {},
                  onSwipe: () {
                    // addAttendance(_selectedDay, 'Student Name');
                  },
                ),

              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue,
            child: ListView.builder(
              itemCount: widget.students.length,
              itemBuilder: (context, index) {
                final List<dynamic> student = widget.students[index];

                return Column(
                  children: student.map((s) {
                    final name = s['name'];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(name[0])),
                        title: Text(name),
                        onTap: () {
                          setState(() {
                            s['attended'] = !s['attended'];
                            addAttendance(_selectedDay, name);
                          });
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


