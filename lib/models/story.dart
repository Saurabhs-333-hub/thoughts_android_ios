import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String username;
  final String uid;
  final String stories;
  final String storyId;
  final String datePublished;
  // final String storyUrl;
  final String email;
  // final List datePublished;
  final String profilePic;
  final likes;

  StoryModel({
    required this.username,
    required this.uid,
    required this.stories,
    required this.storyId,
    // required this.storyUrl,
    required this.datePublished,
    required this.likes,
    required this.profilePic,
    required this.email,
  });

  get isNotEmpty => null;
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'stories': stories,
        'storyId': storyId,
        // 'storyUrl': storyUrl,
        'profilePic': profilePic,
        'likes': likes,
        'datePublished': datePublished,
        'email': email,
      };

  static StoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StoryModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      stories: snapshot['stories'],
      storyId: snapshot['storyId'],
      // storyUrl: snapshot['storyUrl'],
      datePublished: snapshot['datePublished'],
      profilePic: snapshot['profilePic'],
      likes: snapshot['likes'],
      email: snapshot['email'],
    );
  }
}
