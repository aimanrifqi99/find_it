import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:find_it/widgets/post_card.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({super.key});

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent, // Change to your desired color
        title: const Text('Lost Items'),
        centerTitle: false,
        actions: [],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          }

          // Filter posts to only include lost items
          List<QueryDocumentSnapshot<Map<String, dynamic>>> lostPosts = snapshot.data!.docs
              .where((doc) => doc.data()['isLost'] == true)
              .toList();

          if (lostPosts.isEmpty) {
            return const Center(
              child: Text('No items available'),
            );
          }

          return ListView.builder(
            itemCount: lostPosts.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> postData = lostPosts[index].data();
              return PostCard(snap: postData);
            },
          );
        },
      ),
    );
  }
}
