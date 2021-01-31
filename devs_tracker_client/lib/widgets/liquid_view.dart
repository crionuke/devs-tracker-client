import 'package:flutter/material.dart';

class LiquidView extends StatelessWidget {
  final Widget child;

  LiquidView({this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: <Widget>[SliverFillRemaining(child: child)]);
  }
}
