import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    model.User user = model.User.fromSnap(snapshot);
    return user;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Something went wrong';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // await credential.user!.sendEmailVerification();

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          email: email,
          uid: credential.user!.uid,
          username: username,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());

        // await _firestore.collection('users').add(
        //       user.toJson(),
        //     );

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'invalid-email':
          res = 'invalid email';
          break;
        case 'weak-password':
          res = 'Password should be at least 6 passwords';
          break;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Something went wrong';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'user-not-found':
          res = 'User not found';
          break;
        case 'wrong-password':
          res = 'Wrong Password';
          break;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
