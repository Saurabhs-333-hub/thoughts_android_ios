// import 'dart:async';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/models/user.dart';
import 'package:thoughts/providers/userProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:thoughts/models/user.dart';
// import 'package:thoughts/providers/userProvider.dart';
import 'package:thoughts/resources/firestoreMethods.dart';
import 'package:thoughts/resources/storageMethod.dart';
import 'package:thoughts/screens/uploadQuoteSuggestions.dart';
// import 'package:thoughts/utils/colors.dart';
import 'package:thoughts/utils/utils.dart';
import 'package:thoughts/widgets/backup.dart';
// import 'package:thoughts/widgets/factCard.dart';
// import 'package:thoughts/widgets/factsCard.dart';
import 'package:thoughts/widgets/followButton.dart';
// import 'package:thoughts/widgets/likeAnimation.dart';
// import 'package:thoughts/widgets/postCard.dart';
import 'package:thoughts/widgets/postsCard.dart';
import 'package:thoughts/widgets/storiesCard.dart';
// import 'package:thoughts/widgets/storyCard.dart';
// import 'package:intl/intl.dart';

// bool isrefreshing = false;

class Profile extends StatefulWidget {
  final String uid;
  const Profile({super.key, required this.uid});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? value;
  double? updatedvalue;
  String? updatedfont;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isrefreshing = false;
  @override
  void initState() {
    super.initState();
    // isrefreshing = false;
    isrefreshing
        ? setState(() {
            // isLoading = true;
            getData();
            // isrefreshing = false;
            // isLoading = false;
          })
        : getData();
    // readLoacationData();
    // readLoacationData1();
    // getData();
  }

  var str;
  List value1 = [];
  List values1 = [];
  readLoacationData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('QGB0kPKhUygzD61irohdquifaCt2')
        .get()
        .then((value) {
      List<String> values = List.from((value.data() as dynamic)['followers']);
      setState(() {
        // values1.add(values);
        values.forEach((element) {
          values1.add(element);
          str = element;
          value1.add(str);
          print(value1);
          setState(() {
            // value1.add(str);
            values1.add(element);
          });
        });
        // print(value1);
        setState(() {});
      });
      setState(() {});
      return value1;
    });
    return values1;
  }

  var str1;
  List value11 = [];
  List values11 = [];
  readLoacationData1() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('QGB0kPKhUygzD61irohdquifaCt2')
        .get()
        .then((value) {
      List<String> values = List.from((value.data() as dynamic)['following']);
      setState(() {
        // values1.add(values);
        values.forEach((element) {
          values11.add(element);
          str1 = element;
          value11.add(str1);
          print(value11);
          setState(() {
            // value1.add(str);
            values11.add(element);
          });
        });
        // print(value1);
        setState(() {});
      });
      setState(() {});
      return value11;
    });
    return values11;
  }

  // getData() async {
  //   // List any = [];
  //   // setState(() {
  //   //   // print(value1.toString());
  //   //   // return await values1.length;
  //   // });
  //   print(str);
  //   print(value1);
  // }
  final textEditingController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  void refresh(bool newrefresh) {
    setState(() {
      isrefreshing = newrefresh;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      var factSnap = await FirebaseFirestore.instance
          .collection('facts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      var storySnap = await FirebaseFirestore.instance
          .collection('stories')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = snap.data()!;
      followers = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;
      isFollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> fontStyle = [
      'posts',
      'facts',
      'stories',
    ];
    Future updateUser(
      String username,
      String bio,
    ) async {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final UserModel? user =
          Provider.of<UserProvider>(context, listen: false).getUser;
      setState(() {
        // _bioController.text = user!.bio;
        // _usernameController.text = user.username;
      });
      UsersModel users = UsersModel(
          username: _usernameController.text.isNotEmpty
              ? _usernameController.text
              : user!.username,
          bio: _bioController.text.isNotEmpty ? _bioController.text : user!.bio,
          email: user!.email,
          followers: user.followers,
          following: user.following,
          profilePic: user.profilePic,
          uid: user.uid);
      try {
        await _firestore.collection('users').doc(user.uid).update(
              users.toJson(),
            );
        print(user.toString());
      } catch (e) {
        print(e.toString());
        showSnackBar(context, e.toString());
      }
    }

    final UserModel? user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    isLoading
                        ? Expanded(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                // backgroundImage: NetworkImage(userData['profilePic']),
                                radius: 60.0,
                              ),
                            ),
                          )
                        : Expanded(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userData['profilePic']),
                              radius: 60.0,
                            ),
                          ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : buildStatColumn(postLen, "posts"),
                              SizedBox(
                                width: 8,
                              ),
                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () => showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ListView.builder(
                                                itemCount: value1.length,
                                                itemBuilder: (context, index) =>
                                                    ListTile(
                                                      title:
                                                          Text(value1[index]),
                                                    ));
                                          }),
                                      child: buildStatColumn(
                                          followers, "followers")),
                              SizedBox(
                                width: 8,
                              ),
                              isLoading
                                  ? Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 52, 52, 52),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    )
                                  : buildStatColumn(following, "following")
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: [
                              isLoading
                                  ? Container(
                                      width: 60,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 52, 52, 52),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    )
                                  : Container(
                                      child: Text(userData['username']),
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                              isLoading
                                  ? Container(
                                      width: 100,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 52, 52, 52),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    )
                                  : Container(
                                      child: Text(userData['bio']),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                            backgroundColor: Color.fromARGB(255, 138, 54, 255),
                            borderColor: Colors.transparent,
                            text: "Edit",
                            textColor: Colors.white,
                            width: 100,
                            function: () => showModalBottomSheet(
                                context: context,
                                isDismissible: true,
                                isScrollControlled: true,
                                constraints: BoxConstraints.expand(height: 400),
                                barrierColor: Color.fromARGB(114, 0, 0, 0),
                                builder: (context) {
                                  return Container(
                                    // color: Colors.amber,
                                    height: 300,
                                    // width: 300,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          Color.fromARGB(0, 0, 0, 0),
                                          Color.fromARGB(255, 0, 0, 0)
                                        ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(
                                                label: Text(user!.username),
                                                hintText: user.username),
                                            autocorrect: true,
                                            controller: _usernameController,
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                label: Text(user.bio),
                                                hintText: user.bio),
                                            autocorrect: true,
                                            controller: _bioController,
                                          ),
                                          // TextField(
                                          //   decoration: InputDecoration(
                                          //       label: Text(user!.username),
                                          //       hintText: user.username),
                                          //   autocorrect: true,
                                          //   controller: _usernameController,
                                          // ),
                                          OutlinedButton(
                                              onPressed: () => updateUser(
                                                  _usernameController.text,
                                                  _bioController.text),
                                              child: Text("Update"))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : isFollowing
                            ? FollowButton(
                                backgroundColor:
                                    Color.fromARGB(255, 131, 33, 243),
                                borderColor: Colors.transparent,
                                text: "UnFollow",
                                textColor: Colors.white,
                                width: 100,
                                function: (() async {
                                  await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = false;
                                    followers--;
                                  });
                                }),
                              )
                            : FollowButton(
                                backgroundColor:
                                    Color.fromARGB(255, 131, 33, 243),
                                borderColor: Colors.transparent,
                                text: "Follow",
                                textColor: Colors.white,
                                width: 100,
                                function: (() async {
                                  await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = true;
                                    followers++;
                                  });
                                }),
                              ),
                    widget.uid == 'V2dQ1ownFsV3AsFUifgdEwJo5g22'
                        ? IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(CupertinoPageRoute(builder: (context) {
                                return UploadQuoteSuggestions(
                                  uid: widget.uid,
                                );
                              }));
                            },
                            icon: Icon(CupertinoIcons.add_circled_solid))
                        : SizedBox.shrink(),
                    Expanded(
                      child: SizedBox(
                        child: DropdownButton<String>(
                          // alignment: Alignment.topCenter,
                          // isExpanded: true,
                          items: fontStyle.map(buildItem).toList(),
                          value: value,
                          onChanged: (value) => {
                            setState(() => {
                                  this.value = value,
                                  updatedfont = value,
                                }),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          updatedfont == 'posts'
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState ==
                    //     ConnectionState.waiting) {
                    //   return Center(
                    //     child: Container(
                    //       width: 300,
                    //       height: 300,
                    //       color: Colors.amber,
                    //     ),
                    //   );
                    // }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Container(
                                // width: 60,
                                // height: 60,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 52, 52, 52),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                                // isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return PostsCard(
                                    snap: snapshot.data!.docs[index].data(),
                                    onSonChanged: ((bool isrefreshing) =>
                                        refresh(isrefreshing)),
                                  );
                                }),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : updatedfont == 'facts'
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('facts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return Center(
                        //     child: Container(
                        //       // width: 100,
                        //       height: 200,
                        //       color: Color.fromARGB(255, 57, 57, 57),
                        //     ),
                        //   );
                        // }

                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Container(
                                  // width: 60,
                                  // height: 60,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 52, 52, 52),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              );
                            }
                            return GestureDetector(
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        // onTap: () =>
                                        child: FactsCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                          onSonChanged: ((bool isrefreshing) =>
                                              refresh(isrefreshing)),
                                        ),
                                      );
                                    }),
                                child: Container(child: Text(snap['facts'])));
                          },
                        );
                      },
                    )
                  : FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('stories')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Container(
                                  // width: 60,
                                  // height: 60,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 52, 52, 52),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              );
                            }
                            return GestureDetector(
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StoriesCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                          onSonChanged: (bool isrefreshing) =>
                                              refresh(isrefreshing));
                                    }),
                                child: Container(child: Text(snap['stories'])));
                          },
                        );
                      },
                    )
        ],
      ),
    );
  }

  Column buildStatColumn(int nums, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nums.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
      value: item,
      enabled: true,
      child: Text(
        '$item',
        style: TextStyle(color: Colors.amber),
      ));
}
