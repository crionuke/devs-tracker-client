import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onPressed;

  ErrorView(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return LiquidView(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Sorry, something failed."),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: FlatButton(
              onPressed: onPressed,
              child: Text("Try again"),
            ))
      ]),
    ));
  }
}
