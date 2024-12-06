import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:text_neon_widget/text_neon_widget.dart';

import '../methods.dart';


class  CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<DateTime> savedDates = [];  // List to store all saved dates
  DateTime focusedDate = DateTime.now();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool Loading = false;



  // Calculate the start and end dates for the past 4 months
  DateTime get startOfRange {
    return DateTime.now().subtract(Duration(days: 30 * 5)); // 4 months ago
  }

  DateTime get endOfRange {
    return DateTime.now(); // Current date
  }

  /// Fetch saved dates from Firebase
  Future<void> _fetchDatesFromFirebase() async {
    setState(() {
      Loading = true;
    });

    String? idd = _auth.currentUser?.uid;

    final snapshot = await _database.child('dates').child(idd.toString()).get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      // Parse dates from Firebase and sort them
      final List<DateTime> fetchedDates = data.values
          .map((entry) => DateFormat('yyyy-MM-dd').parse(entry['date']))
          .toList();

      // Sort dates in chronological order
      fetchedDates.sort((a, b) => a.compareTo(b));
      setState(() {
        savedDates = fetchedDates;
        Loading = false;
      });
    }
 else{
      setState(() {
        Loading = false;
      });
    }


  }

  /// Save a new date to Firebase
  Future<void> _saveDateToFirebase(DateTime date) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    
    String? idd = _auth.currentUser?.uid;
    try {
      await _database.child('dates').child(idd.toString()).push().set({'date': formattedDate});
      _fetchDatesFromFirebase(); // Refresh events after saving
      GlobalVariable.toast(context, "${date.toString().substring(0,10)} saved Successfully");
    } catch (e) {
      print('Error saving date: $e');
    }
  }

  /// Delete a date from Firebase
  Future<void> _deleteDateFromFirebase(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String? idd = _auth.currentUser?.uid;

    try {
      final snapshot = await _database.child('dates').child(idd.toString()).get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        // Find the date key
        data.forEach((key, value) {
          if (value['date'] == formattedDate) {
            _database.child('dates').child(idd.toString()).child(key).remove();
            _fetchDatesFromFirebase(); // Refresh events after deletion
          }
        });
      }
    } catch (e) {
      print('Error deleting date: $e');
    }
  }

  /// Remove date from local list when clicked again
  void _removeDateFromList(DateTime date) {
    setState(() {
      savedDates.remove(date); // Remove the date from the local list
    });
    _deleteDateFromFirebase(date); // Remove the date from Firebase
  }

  /// Add a new date to the list and Firebase
  void _addDateToList(DateTime date) {
    setState(() {
      savedDates.add(date); // Add the date to the local list
    });
    _saveDateToFirebase(date);
    // Save the date to Firebase
  }

  @override
  void initState() {
    super.initState();

    _fetchDatesFromFirebase(); // Load saved dates on app start
  }

  @override
  Widget build(BuildContext context) {
    return Loading? Container(
       color: Colors.white,
        child: Center(child: CircularProgressIndicator()))
        : Scaffold(
      appBar: AppBar(
        title:  PTTextNeon(text: 'Periods Tracker',color: Colors.deepOrange,
          font: "four",
          shine: true,
          fontSize: 30,
          strokeWidthTextHigh: 3,
          blurRadius: 25,
          strokeWidthTextLow: 1,
          backgroundColor: Colors.black,
        ),
      ),
      body: Column(
        children: [
          // Calendar viewer
          TableCalendar(

            firstDay: startOfRange,
            lastDay: endOfRange,
            focusedDay: focusedDate,
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              // Return events (saved dates) for the current day
              return savedDates
                  .where((date) =>
              date.year == day.year &&
                  date.month == day.month &&
                  date.day == day.day)
                  .toList();
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                focusedDate = focusedDay;
              });
              _toggleDate(selectedDay); // Toggle save/remove date when clicked
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),

          SizedBox(height: 20),

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: savedDates.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(
          //           DateFormat('yyyy-MM-dd').format(savedDates[index]),
          //         ),
          //         trailing: IconButton(
          //           icon: Icon(Icons.delete),
          //           onPressed: () {
          //             _removeDateFromList(savedDates[index]);
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  /// Toggle save or remove the date when clicked in calendar
  void _toggleDate(DateTime selectedDate) {
    String formattedDate = DateFormat('yyyy:MM:dd').format(selectedDate);
    DateTime parsedDate = DateFormat('yyyy:MM:dd').parse(formattedDate);
    print("$parsedDate");
    if (savedDates.contains(parsedDate)) {
      _removeDateFromList(parsedDate); // Remove if it exists
    } else {
      _addDateToList(parsedDate); // Add if it does not exist
    }
  }
}