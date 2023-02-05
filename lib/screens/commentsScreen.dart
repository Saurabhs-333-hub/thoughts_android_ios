import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/models/user.dart';
import 'package:thoughts/providers/userProvider.dart';
import 'package:thoughts/resources/firestoreMethods.dart';
import 'package:thoughts/widgets/comment.dart';
import 'package:thoughts/widgets/replyCard.dart';
import 'package:uuid/uuid.dart';

class CommentsScreeen extends StatefulWidget {
  final snap;
  const CommentsScreeen({super.key, required this.snap});

  @override
  State<CommentsScreeen> createState() => _CommentsScreeenState();
}

class _CommentsScreeenState extends State<CommentsScreeen> {
  final TextEditingController _textInputController = TextEditingController();
  bool pressed = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: StreamBuilder(
        stream: pressed
            ? FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .doc('commentId')
                .collection('replies')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    CommentCard(
                      snap: snapshot.data!.docs[index],
                    ),
                    // CupertinoButton(
                    //     child: Text("Reply"),
                    //     onPressed: () {
                    //       setState(() {
                    //         pressed = true;
                    //       });
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return Dialog(
                    //               child: Row(
                    //                 children: [
                    //                   Container(
                    //                     width: 100,
                    //                     height: 20,
                    //                     child: TextField(
                    //                       maxLength: 6,
                    //                       controller: textEditingController,
                    //                     ),
                    //                   ),
                    //                   IconButton(
                    //                       onPressed: () async {
                    //                         try {
                    //                           await FirestoreMethods()
                    //                               .postReply(
                    //                                   widget.snap['postId'],
                    //                                   textEditingController
                    //                                       .text,
                    //                                   user!.uid,
                    //                                   user.profilePic,
                    //                                   user.username);
                    //                         } catch (e) {
                    //                           print(e.toString());
                    //                         }
                    //                       },
                    //                       icon: Icon(Icons.send_rounded))
                    //                 ],
                    //               ),
                    //             );
                    //           });
                    //     }),
                    // ReplyCard(
                    //   snap: snapshot.data!.docs[index],
                    // )
                  ],
                );
              });
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textInputController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Comment as ${user.username}"),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await FirestoreMethods().postComment(
                      widget.snap['postId'],
                      _textInputController.text,
                      user.uid,
                      user.profilePic,
                      user.username);
                },
                icon: Icon(Icons.send_rounded))
          ],
        ),
      )),
    );
  }
}
