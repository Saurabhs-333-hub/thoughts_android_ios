import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/models/user.dart';
import 'package:thoughts/providers/userProvider.dart';
import 'package:thoughts/resources/firestoreMethods.dart';
import 'package:thoughts/widgets/replyCard.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.black),
                    child: Column(
                      children: [
                        Text(' ${snap.data()['name']}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(' ${snap.data()['text']}',
                            style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd().format(
                            snap.data()['datePublished'].toDate(),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      // CupertinoButton(
                      //     child: Text("Reply"),
                      //     onPressed: () {
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
                      //                                   snap.data()['postId'],
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
                      //     })
                    ],
                  ),
                  // ReplyCard(snap: snap)
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
