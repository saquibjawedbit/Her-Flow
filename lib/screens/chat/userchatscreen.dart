
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:her_flow/screens/authentication/signin_screen.dart';
import 'package:her_flow/screens/authentication/signup_screen.dart';
import 'package:her_flow/screens/profile/profileScreen.dart';

import '../../theme/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_scaffold.dart';
import 'messageScreen.dart';



class ChatScreen extends StatefulWidget {
   final String type;
  ChatScreen({super.key, required this.type} );

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final search = TextEditingController();
  final userref = FirebaseDatabase.instance.ref("user");
  final docref = FirebaseDatabase.instance.ref("doctor");
  List<QueryDocumentSnapshot> _documents = [];

  String SenderName = "";
  final _auth = FirebaseAuth.instance;
  String idd = "";
  int bottomnavbar_index = 0;

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    search.dispose();
  }
  Future<String> fetchData() async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));
    return "Fetched Data!";
  }


  // String chatRoomId(String user1, String user2) {
  //   if (user1[0].toLowerCase().codeUnits[0] >
  //       user2.toLowerCase().codeUnits[0]) {
  //     return "$user1$user2";
  //   } else {
  //     return "$user2$user1";
  //   }
  // }
  String chatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '$userId1$userId2' : '$userId2$userId1';
  }

  void fetch_current_user_id(){
    idd = _auth.currentUser!.uid;
    debugPrint("**************************************************");
  }
  Future<void> fetch_name_of_sender() async{
     final s = await widget.type=="user"?
     await FirebaseDatabase.instance.ref().child("user").child(idd.toString()).child("name").get():
     await FirebaseDatabase.instance.ref().child("doctor").child(idd.toString()).child("name").get();
     String ss = s.value.toString();
     SenderName = ss;
     }

  Future<void> _fetchDocuments() async {
    try {
      // Query for documents where 'one' field matches
      QuerySnapshot querySnapshotOne = await FirebaseFirestore.instance
          .collection("chats")
          .where("one", isEqualTo: idd)
          .get();

      // Query for documents where 'from' field matches
      QuerySnapshot querySnapshotFrom = await FirebaseFirestore.instance
          .collection("chats")
          .where("from", isEqualTo: idd)
          .get();

      // Combine both query results
      List<QueryDocumentSnapshot> combinedDocs = [
        ...querySnapshotOne.docs,
        ...querySnapshotFrom.docs
      ];

      // Remove duplicates based on document ID
      Set<String> seenDocIds = Set();
      List<QueryDocumentSnapshot> uniqueDocs = [];
      for (var doc in combinedDocs) {
        if (!seenDocIds.contains(doc.id)) {
          uniqueDocs.add(doc);
          seenDocIds.add(doc.id);
        }
      }

      // Update the list with unique documents
      setState(() {
        _documents = uniqueDocs;
      });
    } catch (e) {
      print("Error fetching documents: $e");
    }
  }



      @override
      void initState() {
        // TODO: implement initStatep
        fetch_current_user_id();
        fetch_name_of_sender();
        _fetchDocuments();
        super.initState();
      }





      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.type == "user" ? "Doctor" : "User"} List'),
            backgroundColor: Colors.blueAccent,
            actions: [
              widget.type=="doctor"? IconButton(
                icon: const Icon(Icons.person_outline_outlined),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (e) =>
                        ProfileScreen(userType: "doctor", userId: idd),));
                },
              ):Icon(Icons.girl_outlined)
            ],
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomnavbar_index,
            onTap: (index) {
              setState(() {
                bottomnavbar_index = index;
                if (index == 1) _fetchDocuments();
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'All',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat Room',
              ),

            ],
          ),

          body: bottomnavbar_index == 0 ? Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 4, 10, 5),
                child: TextFormField(
                  controller: search,
                  decoration: InputDecoration(
                      hintText: 'search by ${widget.type == "user"
                          ? "Location"
                          : "Name"}',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(CupertinoIcons.search)
                  ),
                  onChanged: (String value) {
                    setState(() {

                    });
                  },
                ),
              ),

              Expanded(
                child: FirebaseAnimatedList(

                    query: widget.type == "user" ? docref : userref,
                    defaultChild: Text('Loading...'),
                    itemBuilder: (context, snapshot, animation, index) {
                      final location = snapshot
                          .child('location')
                          .value
                          .toString();
                      final searchh = widget.type == "user"
                          ? location
                          : SenderName;

                      if (search.text.isEmpty) {
                        return InkWell(
                          onTap: () {
                            String Ridd = snapshot
                                .child('useridd')
                                .value
                                .toString();
                            String chatid = chatRoomId(idd.toString(), Ridd);


                            Navigator.push(context, MaterialPageRoute(
                              builder: (e) =>
                                  ChatRoom(
                                      Rid: Ridd.toString(),
                                      type: widget.type,
                                      chatRoomId: chatid,
                                      senderId: idd.toString(),
                                      Rname: snapshot
                                          .child('name')
                                          .value
                                          .toString(),
                                      Sname: SenderName
                                  ),));
                          },
                          child: DoctorStyle(
                            snapshot
                                .child('name')
                                .value
                                .toString(),
                            snapshot
                                .child('bio')
                                .value
                                .toString(),
                            snapshot
                                .child('age')
                                .value
                                .toString(),
                            snapshot
                                .child('useridd')
                                .value
                                .toString(),
                          ),
                        );
                      }
                      else if (searchh.toLowerCase().contains(
                          search.text.toString().toLowerCase())) {
                        return InkWell(
                          onTap: () {
                            // String? idd = _auth.currentUser?.uid;
                            String Ridd = snapshot
                                .child('useridd')
                                .value
                                .toString();
                            String chatid = chatRoomId(idd.toString(), Ridd);
                            // String Sendername =

                             Navigator.push(context, MaterialPageRoute(
                              builder: (e) =>
                                  ChatRoom(
                                      Rid: Ridd.toString(),
                                      type: widget.type,
                                      chatRoomId: chatid,
                                      senderId: idd.toString(),
                                      Rname: snapshot
                                          .child('name')
                                          .value
                                          .toString(),
                                      Sname: SenderName
                                  ),));

                          },
                          child: DoctorStyle(
                            snapshot
                                .child('name')
                                .value
                                .toString(),
                            snapshot
                                .child('bio')
                                .value
                                .toString(),
                            snapshot
                                .child('age')
                                .value
                                .toString(),
                            snapshot
                                .child('useridd')
                                .value
                                .toString(),
                          ),
                        );
                      }
                      else {
                        return Container();
                      }
                    }),
              ),


            ],
          ) : _documents.isEmpty
              ? Center(
              child: CircularProgressIndicator()) // Show loading indicator
              : ListView.builder(
            itemCount: _documents.length,
            itemBuilder: (context, index) {
              // Get the document at the current index
              var doc = _documents[index];

              // Extract the document data
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              // Build each list item
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: InkWell(
                  onTap: ()async{
                     String rid = data["from_name"]==SenderName?data["one"]:data["from"];
                     String chatid = chatRoomId(idd.toString(), rid);

                    await Navigator.push(context, MaterialPageRoute(
                      builder: (e) =>
                          ChatRoom(
                              Rid: rid,
                              type: widget.type,
                              chatRoomId: chatid,
                              senderId: idd.toString(),
                              Rname: "${data["from_name"]==SenderName?data["one_name"]:data["from_name"]}",
                              Sname: SenderName
                          ),));
                    initState();
                  },
                  child: DoctorStyle2(
                      name: "${data["from_name"]==SenderName?data["one_name"]:data["from_name"]}",
                      unreadMessages: (data["from_name"]==SenderName?data["from_count"]:data["one_count"]) ),
                ),
                  // data["from_name"]==SenderName?data["one"]:data["from"]
                // child: ListTile(
                //   title: Text("Room ID: ${doc.id}"), // Display document ID
                //   subtitle: Text(
                //       "Data: ${data.toString()}"), // Display document data
                // ),
              );
            },
          ),

        );
      }

      Widget DoctorStyle(String name, String bio, String age, String uidd) {
        return
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Big Icon
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                        ),
                        child: Icon(
                          widget.type == "user" ?
                          Icons.medical_services :
                          Icons.person_outline_outlined,
                          size: 60.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 16.0), // Space between icon and text
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name Field with Horizontal Scrolling
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            // Age Field
                            Text(
                              "Age: $age",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            // Bio Field
                            widget.type == "user" ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                bio,
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ) : SizedBox(height: 3,),

                          ],
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Video Call Button
                      ElevatedButton.icon(

                        onPressed: () {
                          // Handle Video Call action
                          print("Video Call Pressed");
                        },
                        icon: Icon(Icons.video_call),
                        label: Text("Video Call"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      // Audio Call Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle Audio Call action
                          print("Audio Call Pressed");
                        },
                        icon: Icon(Icons.phone),
                        label: Text("Audio Call"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),


          );
      }

      Widget DoctorStyle2({
        required String name,
        required int unreadMessages, // Accept unreadMessages as a parameter
      }) {
        return Container(
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Big Icon
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade100,
                    ),
                    child: Icon(
                      Icons.medical_services,
                      // Always showing medical icon (or use widget.type for condition)
                      size: 60.0,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 16.0), // Space between icon and text
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field with Horizontal Scrolling
                        Row(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            // Show unread messages count in a small circle (badge)
                            if (unreadMessages > 0)
                              CircleAvatar(
                                radius: 12.0,
                                backgroundColor: Colors.red,
                                child: Text(
                                  unreadMessages.toString(),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        // Age Field

                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Video Call Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Video Call action
                      print("Video Call Pressed");
                    },
                    icon: Icon(Icons.video_call),
                    label: Text("Video Call"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  // Audio Call Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Audio Call action
                      print("Audio Call Pressed");
                    },
                    icon: Icon(Icons.phone),
                    label: Text("Audio Call"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }


}

