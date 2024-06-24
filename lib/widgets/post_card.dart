import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:find_it/resources/firestore_method.dart';
import 'package:find_it/screens/comment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getComments();
  }

  void getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      (context, err.toString(),);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(182, 208, 226, 1), // Set the color here
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentUserId == widget.snap['uid'])
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            children: ['Delete']
                                .map((e) => InkWell(
                              onTap: () async {
                                FirestoreMethods()
                                    .deletePost(widget.snap['postId']);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Text(e),
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          // Image section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Comments section
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.insert_comment_sharp,
                    color: Colors.red,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  DateFormat('HH:mm:a')
                      .format(widget.snap['timePublished'].toDate()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 10),
            child: Text(
              "Title: ${widget.snap['title']}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 10),
            child: Text(
              "Category: ${widget.snap['category']}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // See more button
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Title: ${widget.snap['title']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Category
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Category: ${widget.snap['category']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Location
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Location: ${widget.snap['location']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Date
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Date: ${DateFormat.yMMMd().format(widget.snap['date'].toDate())}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Description
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Description: ${widget.snap['description']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Contact No
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Contact No: ${widget.snap['contactNo']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "See more",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.more_horiz_sharp, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
