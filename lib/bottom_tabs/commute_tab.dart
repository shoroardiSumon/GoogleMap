import 'package:flutter/material.dart';

class CommuteTab extends StatefulWidget {
  @override
  _CommuteTabState createState() => _CommuteTabState();
}

class _CommuteTabState extends State<CommuteTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Icon(
            Icons.location_city,
            size: 100,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
