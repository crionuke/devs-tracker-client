import 'package:devs_tracker_client/widgets/liquid_view.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LiquidView(
        child: Center(
      child: CircularProgressIndicator(color: Colors.black,),
    ));
  }
}
