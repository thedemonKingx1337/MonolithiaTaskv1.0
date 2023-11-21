import 'package:flutter/material.dart';
import '../api/api.dart';
import '../models/users.dart';
import '../utils/widgets.dart';

class AddPostScreen extends StatefulWidget {
  static const routName = "/addpost";

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late Api apiCall_Data;
  List<UserModel> userData = [];
  var selectedUser;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var isLoadingSubmit = false;

  @override
  void initState() {
    super.initState();
    apiCall_Data = Api();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      userData = await apiCall_Data.getAllUserList();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> submitPost() async {
    String title = titleController.text;
    String description = descriptionController.text;

    if (_formKey.currentState!.validate() &&
        title.isNotEmpty &&
        description.isNotEmpty) {
      setState(() {
        isLoadingSubmit = true;
      });
      try {
        await apiCall_Data.createPost(
          title,
          description,
          selectedUser?.id,
        );

        print(
            'Post created successfully!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoadingSubmit = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.length < 7) {
                    return 'Title should be at least 7 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description should be at least 10 characters';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              CustomDropDown(
                hint: 'Select User',
                onChanged: (dynamic val) {
                  setState(() {
                    selectedUser = val;
                  });
                },
                selectedValue: selectedUser,
                items: userData.map((user) {
                  return DropdownMenuItem<dynamic>(
                    value: user,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "${user.name ?? ""}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Spacer(),
              ElevatedButton(
                onPressed: submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[700],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                child: isLoadingSubmit
                    ? CircularProgressIndicator()
                    : Text('Save Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
