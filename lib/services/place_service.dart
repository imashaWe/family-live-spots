import 'package:family_live_spots/utility/env.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static Future searchLoction(String q) async {
    var url =
        Uri.parse(ENV.GOOGLE_MAP_URL + 'input=$q&key=${ENV.GOOGLE_API_KEY}');
    final r = await http.get(
      url,
    );
    print(r.statusCode);
    print(r.body);
  }
}
