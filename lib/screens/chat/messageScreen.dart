import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:her_flow/screens/chat/userchatscreen.dart';

class ChatRoom extends StatefulWidget {
  final String Rid;
  final String type;
  final String senderId;
  final String Rname;
  final String chatRoomId;
  final String Sname;

  ChatRoom({
    required this.chatRoomId,
    required this.senderId,
    required this.Rname,
    required this.Sname,
    required this.type,
    required this.Rid,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future getImage() async {
  void _clearmsg() async {
    String temp = widget.type == "user" ? "doctor" : "user";
    final docRef =
        FirebaseFirestore.instance.collection("chats").doc(widget.chatRoomId);

    try {
      final docSnapshot = await docRef.get();

      if (docSnapshot["one"] == widget.senderId.toString()) {
        docRef.update({'one_count': 0});
      } else {
        docRef.update({'from_count': 0});
      }
    } catch (e) {
      print("Error checking document existence: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _clearmsg();
    super.initState();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'senderId': widget.senderId,
        'text': _message.text.toString(),
        'timestamp': FieldValue.serverTimestamp(),
        'sendby': widget.Sname,
        "type": "text",
        "isread": false
      };

      _message.clear();
      await _firestore
          .collection('chats')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add(messages);

      String temp = widget.type == "user" ? "doctor" : "user";

      final docRef =
          FirebaseFirestore.instance.collection("chats").doc(widget.chatRoomId);
      try {
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          if (docSnapshot["one"] == widget.senderId.toString()) {
            int count = docSnapshot["from_count"];
            count = count + 1;
            docRef.update({
              "from_count": count,
              'time': FieldValue.serverTimestamp(),
            });
          } else {
            int count = docSnapshot["one_count"];
            count = count + 1;
            docRef.update({
              "one_count": count,
              'time': FieldValue.serverTimestamp(),
            });
          }
        } else {
          docRef.set({
            'one': widget.senderId.toString(),
            'one_count': 0,
            'one_name': widget.Sname.toString(),
            'from': widget.Rid.toString(),
            'from_name': widget.Rname.toString(),
            'from_count': 1,
            'time': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        debugPrint("Error checking document existence: $e");
      }
    } else {
      debugPrint("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.Rname}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Custom icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .orderBy("timestamp", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    for (var doc in snapshot.data!.docs) {
                      if (doc['sendby'] != widget.Sname &&
                          doc['isread'] == false) {
                        // Update 'isRead' to true for messages not sent by the user
                        _firestore
                            .collection('chats')
                            .doc(widget.chatRoomId)
                            .collection('messages')
                            .doc(doc.id)
                            .update({'isread': true});
                      }
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return InkWell(
                            onTap: () {},
                            child: messages(size, map, context,
                                snapshot.data!.docs[index].id));
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteMessage(String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(widget.chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
      print("Message deleted: $messageId");
    } catch (e) {
      print("Error deleting message: $e");
    }
  }

  @override
  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,
      String messageId) {
    bool isSender = map['sendby'] == widget.Sname;

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () {
            // Show a confirmation dialog for deletion
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Delete Message"),
                  content:
                      Text("Are you sure you want to delete this message?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteMessage(messageId);
                        Navigator.pop(context); // Close dialog
                      },
                      child: Text("Delete"),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: size.width,
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isSender ? Colors.blue[300] : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: isSender ? Radius.circular(15) : Radius.zero,
                  bottomRight: isSender ? Radius.zero : Radius.circular(15),
                ),
              ),
              child: Text(
                map['text'],
                style: TextStyle(
                  fontSize: 16,
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        if (isSender && map['isread'] == true)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              "Read",
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
      ],
    );
  }
}

// class ShowImage extends StatelessWidget {
//   final String imageUrl;
//
//   const ShowImage({required this.imageUrl, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Container(
//         height: size.height,
//         width: size.width,
//         color: Colors.black,
//         child: Image.network(imageUrl),
//       ),
//     );
//   }
// }
