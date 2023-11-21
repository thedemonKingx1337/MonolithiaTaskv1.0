import 'package:flutter/material.dart';
import '../api/api.dart';
import '../models/postmodel.dart';
import '../models/commentsmodel.dart';

class PostDetails extends StatefulWidget {
  static const routName = "/postdetails";

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  late Future<List<CommentsModel>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = Api().getAllComments();
  }

  @override
  Widget build(BuildContext context) {
    final PostModel post =
        ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${post.id} ${post.title ?? ""}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '${post.body ?? ""}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Comments',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Failed to load comments');
                } else if (snapshot.hasData) {
                  final List<CommentsModel> comments = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            comments[index].name ?? '',
                          ),
                          subtitle: Text(comments[index].body ?? ''),
                        );
                      },
                    ),
                  );
                } else {
                  return Text('No comments available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
