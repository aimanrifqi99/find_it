import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:find_it/models/post.dart';
import 'package:find_it/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload the post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String title,
    String contactNo,
    String location,
    String? category,
    DateTime date,
    bool isLost,
  ) async {
    String res = 'some error occurred.';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postUrl: photoUrl,
        datePublished: DateTime.now(),
        timePublished: DateTime.now(),
        postId: postId,
        profImage: profImage,
        title: title,
        contactNo: contactNo,
        category: category,
        location: location,
        date: date,
        isLost: isLost,
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // Generate a unique commentId using Uuid package
        String commentId = const Uuid().v1();

        // Access Firestore instance and set the comment document
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });

        // If successful, set result to 'success'
        res = 'success';
      } else {
        // If text is empty, set result to an error message
        res = "Please enter text";
      }
    } catch (err) {
      // Capture and handle any exceptions
      res = err.toString();
    }
    return res;
  }



  //deleting a post

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
