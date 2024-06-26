import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_it/models/user.dart' as model;
import 'package:find_it/utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  final model.User currentUser;

  const EditProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _contactNoController;
  bool _isLoading = false;

  final Color lightAccentBlue = Colors.lightBlueAccent;
  final Color darkerAccentBlue = Colors.blue;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUser.username);
    _contactNoController = TextEditingController(text: widget.currentUser.contactNo);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      model.User updatedUser = model.User(
        uid: widget.currentUser.uid,
        email: widget.currentUser.email,
        photoUrl: widget.currentUser.photoUrl,
        username: _usernameController.text,
        contactNo: _contactNoController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUser.uid)
          .update(updatedUser.toJson());

      showSnackBar(context, 'Profile updated successfully');

      // Optionally, update local user details if needed
      // Provider.of<UserProvider>(context, listen: false).setCurrentUser(updatedUser);

      Navigator.pop(context); // Return to previous screen after saving changes
    } catch (e) {
      showSnackBar(context, 'Failed to update profile: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveProfileChanges,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: darkerAccentBlue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: lightAccentBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: darkerAccentBlue),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contactNoController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                labelStyle: TextStyle(color: darkerAccentBlue),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: lightAccentBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: darkerAccentBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
