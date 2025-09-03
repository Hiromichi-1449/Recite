import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage ({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

  class _SettingsPageState extends State<SettingsPage> {
    bool _busy = false;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF555B6E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: Text("SETTINGS"),
          centerTitle: true
        ),
        body: ListView(),
      );
    }

  }