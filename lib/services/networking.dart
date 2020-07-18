import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  final String token;

  NetworkHelper(this.url, this.token);

  Future getData() async {
    http.Response result = await http.get(
      url,
      headers: {
        'X-AUTH-TOKEN': token,
        HttpHeaders.acceptHeader: '*/*',
      },
    );

    if (result.statusCode == 200) {
      print("good");
      return (jsonDecode(result.body));
    } else {
      print("oops");
      print(result.statusCode);
      print(result.reasonPhrase);
    }
  }
}
