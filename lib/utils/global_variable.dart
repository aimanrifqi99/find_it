import "package:flutter/material.dart";
import "package:find_it/screens/add_post_screen.dart";
import 'package:find_it/screens/lost_item_screen.dart';
import 'package:find_it/screens/found_item_screen.dart';
import "package:find_it/screens/profile_screen.dart";

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const LostItemsScreen(),
  const FoundItemsScreen(),
  const AddPostScreen(),
  const ProfileScreen(),
];
