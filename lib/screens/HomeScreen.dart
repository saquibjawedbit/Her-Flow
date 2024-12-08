import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:her_flow/screens/marketplace/marketplace_screen.dart';
import 'package:her_flow/screens/methods.dart';
import 'package:her_flow/screens/chat/userchatscreen.dart';
import 'package:her_flow/screens/profile/profileScreen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:text_neon_widget/text_neon_widget.dart';

import 'tracking/TrackingScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HerFlow'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            for (var card in const [
              {'icon': Icons.home, 'label': 'Home'},
              {'icon': Icons.settings, 'label': 'Settings'},
              {'icon': Icons.message, 'label': 'Consultancy'},
              {'icon': Icons.calendar_month, 'label': 'Tracking'},
              {'icon': Icons.person, 'label': 'Profile'},
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: StylishCard(
                  icon: card['icon'] as IconData,
                  label: card['label'] as String,
                  cardWidth: screenWidth * 0.9,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StylishCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double cardWidth;

  const StylishCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.cardWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth, // Responsive width
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            if (label == "Home") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Marketplacescreen()));
            } else if (label == "Tracking") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) => CalendarScreen(),
                ),
              );
              // showDialog(
              //   context: context,
              //   builder: (context) => const CustomDatePickerDialog(),
              // );
            } else if (label == "Consultancy") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => ChatScreen(
                      type: 'user',
                    ),
                  ));
            } else if (label == "Profile") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (e) => ProfileScreen(
                        userType: "user",
                        userId:
                            FirebaseAuth.instance.currentUser!.uid.toString()),
                  ));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              Icon(
                icon,
                size: cardWidth * 0.2, // Icon size relative to card width
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10.0),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDatePickerDialog extends StatefulWidget {
  const CustomDatePickerDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? _currentdate = DateTime.now();
  DateTime? _prevdate = DateTime.now();
  bool loading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("user");
  int diff = 0;
  void _selectDate(BuildContext context, String label, DateTime date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: date,
    );

    if (label == "prevdate") {
      setState(() {
        _prevdate = picked;
        diff = calculateDateDifference(
            DateFormat('yyyy-MM-dd').format(_prevdate!),
            DateFormat('yyyy-MM-dd').format(_currentdate!));
      });
    } else {
      setState(() {
        _currentdate = picked;
        diff = calculateDateDifference(
            DateFormat('yyyy-MM-dd').format(_prevdate!),
            DateFormat('yyyy-MM-dd').format(_currentdate!));
      });
    }
  }

  Future<void> _fetchUserData() async {
    setState(() {
      loading = true;
    });

    try {
      String? uidd = _auth.currentUser?.uid.toString();

      Query query = _databaseRef.child(uidd.toString());
      DataSnapshot snapshot = await query.get();
      debugPrint(snapshot.child('name').value.toString());
      String currdate = snapshot.child('currentdate').value.toString();
      String prevdate = snapshot.child('prevdate').value.toString();
      if (currdate != 'na') {
        _currentdate = DateTime.parse(currdate);
      }
      if (prevdate != "na") {
        _prevdate = DateTime.parse(prevdate);
      }
      debugPrint(_currentdate.toString());
      diff = calculateDateDifference(
          _prevdate.toString(), _currentdate.toString());
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDate(context, "prevdate", _prevdate!),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Text("Last Period: "),
                      Text(
                          _prevdate != null
                              ? DateFormat('dd-MM-yyyy').format(_prevdate!)
                              : "nill",
                          style: const TextStyle(
                            fontSize: 16.0,
                          )),
                    ],
                  )),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDate(context, "current", _currentdate!),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Text("Current Period: "),
                      Text(
                        _currentdate != null
                            ? DateFormat('dd-MM-yyyy').format(_currentdate!)
                            : 'Tap to select a date',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 16.0),
            loading == true
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      Text(
                        "Days Count: ",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      PTTextNeon(
                        text: '$diff',
                        color: Colors.deepOrange,
                        font: "four",
                        shine: true,
                        shineDuration: Duration(milliseconds: 200),
                        fontSize: 30,
                        strokeWidthTextHigh: 3,
                        blurRadius: 25,
                        strokeWidthTextLow: 1,
                        backgroundColor: Colors.black,
                      ),
                    ],
                  ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String? uidd = _auth.currentUser?.uid.toString();
                    _databaseRef.child(uidd.toString()).update({
                      'currentdate': "${_currentdate.toString()}",
                      'prevdate': "${_prevdate.toString()}",
                      'days_count': "${diff}"
                    });

                    Navigator.pop(context);
                    GlobalVariable.toast(context, "Data Saved SuccessFully");
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int calculateDateDifference(String date1Str, String date2Str) {
    try {
      // Define the date format
      DateFormat format = DateFormat("yyyy-MM-dd");

      // Parse the input strings to DateTime objects
      DateTime date1 = format.parse(date1Str);
      DateTime date2 = format.parse(date2Str);

      // Calculate the absolute difference in days
      return date2.difference(date1).inDays.abs();
    } catch (e) {
      print("Invalid date format: $e");
      return -1; // Return -1 to indicate an error
    }
  }
}
