import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage ({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

  class _ProfilePageState extends State<ProfilePage> {
    bool _busy = false;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF555B6E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: Text("PROFILE"),
          centerTitle: true
        ),
        body: ListView(),
      );
    }

  }