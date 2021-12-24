import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  final String token;

  NetworkHelper(this.url, this.token);

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communicating with server with status code: ${response
                .statusCode}');
    }
  }

  //   if (result.statusCode == 200) {
  //     return (jsonDecode(result.body));
  //   } else {
  //
  //     throw HttpException('${result.statusCode}');
  //   }
  // } on Exception catch (e) {
  //   print(e);
  // }
  Future getData() async {
    var responseJson;
    try {
      //http.Response result = await http.get(
      final response = await http.get(
        url,
        headers: {
          'X-AUTH-TOKEN': token,
          HttpHeaders.acceptHeader: '*/*',
        },
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Communication error: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid input: ");
}