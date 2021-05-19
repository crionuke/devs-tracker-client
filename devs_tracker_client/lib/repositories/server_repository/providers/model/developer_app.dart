import 'package:country_codes/country_codes.dart';

class DeveloperApp {
  final int appleId;
  final DateTime releaseDate;
  final Map<String, String> translations;

  DeveloperApp(this.appleId, String releaseDateString, this.translations)
      : releaseDate = DateTime.parse(releaseDateString);

  factory DeveloperApp.fromJson(Map<String, dynamic> json) {
    Map<String, String> translations = (json["translations"] as Map)
        .map((country, title) => MapEntry<String, String>(country, title));
    return DeveloperApp(json["appleId"], json["releaseDate"], translations);
  }

  @override
  String toString() {
    return "(appleId=${appleId}, releaseDate=\"${releaseDate}\", translations=${translations})";
  }

  String get title {
    if (translations.isEmpty) {
      return "<Unknown>";
    } else {
      String deviceCountryCode =
          CountryCodes.getDeviceLocale().countryCode.toLowerCase();

      if (translations.containsKey(deviceCountryCode)) {
        return translations[deviceCountryCode];
      } else if (translations.containsKey("us")) {
        return translations["us"];
      } else {
        return translations.values.toList()[0];
      }
    }
  }
}
