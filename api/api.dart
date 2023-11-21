import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/users.dart';

import 'package:http/http.dart' as http;

import '../models/commentsmodel.dart';
import '../models/postmodel.dart';

class Api {
  String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<UserModel>> getAllUserList() async {
    Uri url = Uri.parse(baseUrl + "/users");
    var response = await http.get(url);
    debugPrint("RESPONSE:" + response.body.toString(), wrapWidth: 1024);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<UserModel> users =
          List<UserModel>.from(list.map((model) => UserModel.fromJson(model)));
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    Uri url = Uri.parse(baseUrl + "/posts");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<PostModel> posts =
          List<PostModel>.from(list.map((model) => PostModel.fromJson(model)));
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> deletePost(int postId) async {
    Uri url = Uri.parse('$baseUrl/posts/$postId');
    var response = await http.delete(url);
    print("Deleted post triggered: ");
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }

  Future<List<CommentsModel>> getAllComments() async {
    Uri url = Uri.parse('$baseUrl/comments');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<CommentsModel> comments = [];
      final List<dynamic> commentList = json.decode(response.body);
      commentList.forEach((commentty) {
        comments.add(CommentsModel.fromJson(commentty));
      });
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> createPost(String title, String description, int userId) async {
    var url = Uri.parse('$baseUrl/posts');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'body': description,
          'userId': userId,
        }),
      );

      if (response.statusCode >= 200) {
        print('Post created successfully!');
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception('Error occurred while creating post: $e');
    }
  }
}
