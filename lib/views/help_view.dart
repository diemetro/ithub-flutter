import 'package:flutter/material.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Помощь'),
      ),
      body: Center(
        child: Text('Help content goes here.'),
      ),
    );
  }
}
