import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onPressed;

  ErrorView(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Sorry, something failed."),
        RaisedButton(
          onPressed: onPressed,
          child: Text("Try again"),
        )
      ]),
    );
  }
}
