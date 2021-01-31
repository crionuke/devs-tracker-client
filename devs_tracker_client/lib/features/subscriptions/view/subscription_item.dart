import 'package:flutter/material.dart';

class SubscriptionItem extends StatelessWidget {
  final String title;
  final String totalPrice;
  final bool active;
  final GestureTapCallback onTap;
  final String description;

  SubscriptionItem(
      {@required this.title,
      @required this.totalPrice,
      @required this.active,
      @required this.onTap,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        height: 200,
        child: Opacity(
            opacity: active ? 1 : 0.3,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PriceView(
                    title: title,
                    totalPrice: totalPrice,
                    active: active,
                    onTap: onTap),
                description == null ? Container() : DescriptionView(description)
              ],
            )));
  }
}

class PriceView extends StatelessWidget {
  final String title;
  final String totalPrice;
  final bool active;
  final GestureTapCallback onTap;

  PriceView(
      {@required this.title,
      @required this.totalPrice,
      @required this.active,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
            child: ClipPath(
                child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      children: [
                        Container(
                            height: 100,
                            color: Theme.of(context).primaryColor,
                            child: Center(
                                child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))),
                        Expanded(
                            child: Container(
                                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(totalPrice,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )))
                      ],
                    )),
                clipper: ShapeBorderClipper(
                    shape: Theme.of(context).cardTheme.shape))));
  }
}

class DescriptionView extends StatelessWidget {
  final String description;

  DescriptionView(this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          description,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
