import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String photoUrl;
  final String uid;
  final String contactNo;
  final String username;

  User({
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.contactNo,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    'contactNo': contactNo,
    'uid': uid,
    'photoUrl': photoUrl,
    'email': email,
  };

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      username: data['username'],
      uid: data['uid'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      contactNo: data['contactNo'],
    );
  }
}