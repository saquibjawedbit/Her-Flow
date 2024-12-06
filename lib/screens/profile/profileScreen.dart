import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:her_flow/screens/authentication/signin_screen.dart';
import 'package:her_flow/screens/methods.dart';

class ProfileScreen extends StatefulWidget {
  final String userType; // 'user' or 'doctor'
  final String userId;

  const ProfileScreen({required this.userType, required this.userId, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? profileData;

  // Controllers for update dialog
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(); // For doctors
  final TextEditingController _locationController = TextEditingController(); // For doctors
  String _gender = "Male";

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  void _fetchProfileData() async {
    final ref = widget.userType == 'user'
        ? _dbRef.child('user/${widget.userId}')
        : _dbRef.child('doctor/${widget.userId}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      setState(() {
        profileData = Map<String, dynamic>.from(snapshot.value as Map);

        // Populate controllers for update dialog
        _nameController.text = profileData!['name'];
        _ageController.text = profileData!['age'];
        _gender = profileData!['gender'];
        if (widget.userType == 'doctor') {
          _bioController.text = profileData!['bio'];
          _locationController.text = profileData!['location'];
        }
      });
    }
  }

  void _updateProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(

                    style: TextStyle(color: Colors.black),

                    value: _gender,
                    items:[
                      DropdownMenuItem<String>(
                        value: 'one',
                        child:  Container(
                          child: Text('Male'),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'two',
                        child:  Container(
                          child: Text('Femail'),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'three',
                        child:  Container(
                          child: Text('other'),
                        ),
                      ),
                    ] ,
                    onChanged: (String? valuee){
                      setState(() {
                       _gender = valuee!;
                      });
                    }
                ),
                if (widget.userType == 'doctor') ...[
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Bio'),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update Firebase
                final updatedData = {
                  'name': _nameController.text.trim(),
                  'age': _ageController.text.trim(),
                  'gender': _gender,
                  if (widget.userType == 'doctor') 'bio': _bioController.text.trim(),
                  if (widget.userType == 'doctor') 'location': _locationController.text.trim(),
                };
                final ref = widget.userType == 'user'
                    ? _dbRef.child('user/${widget.userId}')
                    : _dbRef.child('doctor/${widget.userId}');

                await ref.update(updatedData);

                // Refresh the screen with updated data
                _fetchProfileData();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
    GlobalVariable.toast(context, "User Updated Successfully");

  }

  void _deleteAccount() async {
    final ref = widget.userType == 'user'
        ? _dbRef.child('user/${widget.userId}')
        : _dbRef.child('doctor/${widget.userId}');
    await ref.remove();
    await _auth.currentUser?.delete();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (e) => SignInScreen()), (route) => false);
    GlobalVariable.toast(context, "Account Deleted Successfully");

  }

  void _logout() async {
    await _auth.signOut();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (e) => SignInScreen()), (route) => false);
    GlobalVariable.toast(context, "Successfully Logout");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userType.toUpperCase()}-Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: profileData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              child: Text(profileData!['name'][0].toUpperCase(),
                style: TextStyle(fontSize: 50),
              ),
            ),
            const SizedBox(height: 20),
            Text('Name: ${profileData!['name']}',
              style: TextStyle(fontSize: 20),
            ),
            Text('Age: ${profileData!['age']}',
              style: TextStyle(fontSize: 20),),
            Text('Gender: ${gender(profileData!['gender'])}',
              style: TextStyle(fontSize: 20),),
            if (widget.userType == 'doctor') ...[
              Text('Bio: ${profileData!['bio']}',
                style: TextStyle(fontSize: 20),),
              Text('Location: ${profileData!['location']}',
                style: TextStyle(fontSize: 20),),
            ],
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Update Information'),

                  ),
                  ElevatedButton(
                    onPressed: _deleteAccount,
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
            )

          ],
        ),

      ),
    );
  }

  String gender(String s){
    if(s=="one")return "Male";
    else if(s=="two")return "Femail";
    else return "Other";
  }


}








































