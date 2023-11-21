import 'package:flutter/material.dart';
import 'addpost.dart';
import '../api/api.dart';
import '../models/postmodel.dart';
import '../models/users.dart';
import '../utils/widgets.dart';
import '../widgets/postTile.dart';
import 'postDetails.dart';

class HomeScreen extends StatefulWidget {
  static const routName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Api api;
  List<UserModel> userData = [];
  List<PostModel> allPostsData = [];
  List<PostModel> filteredPostsData = [];
  dynamic selectedUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    api = Api();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      userData = await api.getAllUserList();
      allPostsData = await api.getAllPosts();
      filteredPostsData = allPostsData;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await api.deletePost(postId);
      await fetchData();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  void filterPostsByUser(dynamic user) {
    if (user != null) {
      setState(() {
        selectedUser = user;
        if (user == "All Users") {
          filteredPostsData = allPostsData;
        } else {
          filteredPostsData =
              allPostsData.where((post) => post.userId == user.id).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monolithia Task"),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 15, top: 15),
            child: CustomDropDown(
              hint: 'Select User',
              onChanged: (dynamic val) {
                filterPostsByUser(val);
              },
              selectedValue: selectedUser,
              items: [
                DropdownMenuItem<dynamic>(
                  value: "All Users",
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("All Users"),
                  ),
                ),
                ...userData.map((user) {
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
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: filteredPostsData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              filteredPostsData.removeAt(index);
                            });
                            deletePost(filteredPostsData[index].id!);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(top: 8, bottom: 8),
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PostDetails.routName,
                                arguments: filteredPostsData[index],
                              );
                            },
                            child: PostTile(filteredPostsData[index]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddPostScreen.routName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
