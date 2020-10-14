import 'package:flutter/material.dart';

class ContributeTab extends StatefulWidget {
  @override
  _ContributeTabState createState() => _ContributeTabState();
}

class _ContributeTabState extends State<ContributeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Icon(
            Icons.add_circle_outline,
            size: 100,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
