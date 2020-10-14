import 'package:flutter/material.dart';

class UpdatesTab extends StatefulWidget {
  @override
  _UpdatesTabState createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Icon(
            Icons.notifications_none,
            size: 100,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
