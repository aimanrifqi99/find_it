import 'package:flutter/material.dart';
import 'package:find_it/resources/firestore_method.dart';
import 'package:intl/intl.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> initialData;

  const EditPostScreen({required this.postId, required this.initialData, Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialData['title'];
    _descriptionController.text = widget.initialData['description'];
    _locationController.text = widget.initialData['location'];
    _categoryController.text = widget.initialData['category'];
    _selectedDate = widget.initialData['date'].toDate();
  }

  void _saveChanges() async {
    await FirestoreMethods().updatePost(widget.postId, {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'category': _categoryController.text,
      'date': _selectedDate,
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.black), // Text color
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black), // Label text color
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.black), // Text color
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black), // Label text color
              ),
              maxLines: null,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _locationController,
              style: TextStyle(color: Colors.black), // Text color
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: Colors.black), // Label text color
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date chosen!'
                      : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                  style: TextStyle(color: Colors.black), // Text color
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // background color
                    foregroundColor: Colors.white, // text color
                  ),
                  child: Text('Choose Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
