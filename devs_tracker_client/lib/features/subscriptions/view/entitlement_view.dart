import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class EntitlementView extends StatelessWidget {
  final EntitlementInfo entitlementInfo;

  EntitlementView(this.entitlementInfo);

  @override
  Widget build(BuildContext context) {
    String originalDate = _formatDate(
        context, DateTime.parse(entitlementInfo.originalPurchaseDate));
    String expirationDate =
        _formatDate(context, DateTime.parse(entitlementInfo.expirationDate));
    String latestPurchaseDate = _formatDate(
        context, DateTime.parse(entitlementInfo.latestPurchaseDate));

    return ListTile(
        title: Text("Subscribed: $originalDate"),
        subtitle: Text(
            "Latest purchase: $latestPurchaseDate, expiration: $expirationDate"));
  }

  static String _formatDate(BuildContext context, DateTime dateTime) {
    final Locale locale = Localizations.localeOf(context);
    final DateFormat format = DateFormat.Hms(locale.toString());
    return format.format(dateTime.toLocal()).toString();
  }
}
