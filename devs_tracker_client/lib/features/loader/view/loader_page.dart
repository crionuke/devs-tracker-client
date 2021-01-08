import 'package:flutter/material.dart';

class LoaderPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoaderPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
