import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thoughts/models/fact.dart';
import 'package:thoughts/models/post.dart';
import 'package:thoughts/models/story.dart';
import 'package:thoughts/resources/storageMethod.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future uploadPost(
    String thoughts,
    Uint8List file,
    String uid,
    String username,
    String profilePic,
    String email,
    String tags,
  ) async {
    try {
      String pic =
          await StorageMethod().uploadToStorage("postImage", file, true);
      String postId = Uuid().v1();
      PostModel post = PostModel(
          username: username,
          uid: uid,
          thoughts: thoughts,
          postId: postId,
          postUrl: pic,
          datePublished: DateTime.now().toString(),
          likes: [],
          profilePic: profilePic,
          email: email,
          tags: tags);
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      String res = 'success';
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadFact(
    String facts,
    Uint8List file,
    String uid,
    String username,
    String profilePic,
    String email,
  ) async {
    try {
      // String pic =
      //     await StorageMethod().uploadToStorage("factImage", file, true);
      String factId = Uuid().v1();
      FactModel fact = FactModel(
        username: username,
        uid: uid,
        facts: facts,
        factId: factId,
        // factUrl: pic,
        datePublished: DateTime.now().toString(),
        likes: [],
        profilePic: profilePic,
        email: email,
      );
      await _firestore.collection('facts').doc(factId).set(fact.toJson());
      String res = 'success';
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadStory(
    String stories,
    // Uint8List file,
    String uid,
    String username,
    String profilePic,
    String email,
  ) async {
    try {
      // String pic =
      //     await StorageMethod().uploadToStorage("factImage", file, true);
      String storyId = Uuid().v1();
      StoryModel story = StoryModel(
        username: username,
        uid: uid,
        stories: stories,
        storyId: storyId,
        // factUrl: pic,
        datePublished: DateTime.now().toString(),
        likes: [],
        profilePic: profilePic,
        email: email,
      );
      await _firestore.collection('stories').doc(storyId).set(story.toJson());
      String res = 'success';
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid, uid.length])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId, followId.length])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid, uid.length])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId, followId.length])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String commentId = Uuid().v1();
  Future postComment(String postId, String text, String uid, String profilePic,
      String name) async {
    try {
      if (text.isNotEmpty) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String replyId = Uuid().v1();
  Future postReply(String postId, String text, String uid, String profilePic,
      String name) async {
    try {
      if (text.isNotEmpty) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .collection('replies')
            .doc(replyId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'replId': replyId,
          'datePublished': DateTime.now()
        });
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteFact(factId) async {
    try {
      await FirebaseFirestore.instance.collection('facts').doc(factId).delete();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(factId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteStory(storyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .delete();
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
