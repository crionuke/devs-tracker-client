import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PackageView extends StatelessWidget {
  final Package package;
  final String description;
  final GestureTapCallback onTap;
  final bool selected;

  PackageView(
      {@required this.package,
      @required this.description,
      @required this.onTap,
      @required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        height: 200,
        child: Opacity(
            opacity: selected ? 1 : 0.3,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PriceView(package: package, active: selected, onTap: onTap),
                description == null
                    ? Container()
                    : DescriptionView(description)
              ],
            )));
  }
}

class PriceView extends StatelessWidget {
  final Package package;
  final GestureTapCallback onTap;
  final bool active;

  PriceView(
      {@required this.package, @required this.onTap, @required this.active});

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
                              package.product.title,
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
                            Text(package.product.priceString,
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
