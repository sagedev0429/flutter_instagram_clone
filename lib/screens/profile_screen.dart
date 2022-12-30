import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  model.User user = const model.User(
      bio: '',
      email: '',
      uid: '',
      photoUrl: '',
      username: '',
      followers: [],
      following: []);
  int postLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int following = 0;
  int followers = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          )
          .snapshots()
          .listen((event) {
        setState(() {
          postLen = event.docs
              .where((element) => element['uid'] == widget.uid)
              .length;
        });
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .snapshots()
          .listen(
        (event) {
          var data = event.data()!;
          setState(() {
            user = model.User(
              bio: data['bio'],
              username: data['username'],
              email: data['email'],
              photoUrl: data['photoUrl'],
              uid: data['uid'],
              followers: data['followers'],
              following: data['following'],
            );
            followers = user.followers.length;
            following = user.following.length;
            isFollowing = user.followers.contains(widget.uid);
          });
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(user.username),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                            radius: 40,
                            backgroundColor: Colors.grey,
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(postLen, 'posts'),
                                buildStatColumn(followers, 'followers'),
                                buildStatColumn(following, 'following'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? FollowButton(
                                  borderColor: Colors.grey,
                                  backgroundColor: mobileBackgroundColor,
                                  text: 'Sign Out',
                                  textColor: primaryColor,
                                  function: () async {
                                    await AuthMethods().signOut();
                                  },
                                )
                              : isFollowing
                                  ? FollowButton(
                                      borderColor: Colors.grey,
                                      backgroundColor: mobileBackgroundColor,
                                      text: 'Unfollow',
                                      textColor: primaryColor,
                                      function: () async {
                                        await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.uid,
                                        );
                                        setState(() {
                                          isFollowing = false;
                                        });
                                      },
                                    )
                                  : FollowButton(
                                      borderColor: Colors.blue,
                                      backgroundColor: Colors.blue,
                                      text: 'Follow',
                                      textColor: Colors.white,
                                      function: () async {
                                        await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.uid,
                                        );
                                        setState(() {
                                          isFollowing = true;
                                        });
                                      },
                                    ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          user.bio,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where(
                          'uid',
                          isEqualTo: widget.uid,
                        )
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = snapshot.data!.docs[index];
                          return Container(
                            child: Image(
                              image: NetworkImage(
                                snap['postUrl'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}
