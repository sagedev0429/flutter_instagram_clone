import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'something went wrong';

    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'commmentId': commentId,
            'datePublished': DateTime.now(),
          },
        );
      } else {}
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following = snapshot['following'];

      if (following.contains(followId)) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
        await FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        await FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {}
  }
}
