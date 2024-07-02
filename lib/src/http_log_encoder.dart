part of 'http_either_base.dart';

class HttpLogEncoder {
  HttpLogEncoder._();

  factory HttpLogEncoder() {
    return HttpLogEncoder._();
  }

  /// Pretty print JSON

  final Logger logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      methodCount: 0,
      printEmojis: false,
    ),
  );

  void prettyLogJson(
    int statusCode,
    String? path,
    String? method,
    http.Response response,
    Map<String, dynamic>? query,
    Object? body,
  ) {
    var requestString = '', responseString = '';
    var combined = '';

    requestString = '⤴ REQUEST ⤴\n\n';

    requestString += '$method $path \n';

    if (query != null) {
      requestString += '\n${_getQueryParams(query)}';
    }
    if (body != null) {
      requestString += '\n\n${_getBody(body)}';
    }

    requestString += '\n\n';

    responseString = '⤵ RESPONSE [$statusCode/${response.reasonPhrase}] '
        '⤵\n\n';

    responseString += _getBody(response.body);

    combined = requestString + responseString;

    switch (statusCode) {
      case 200:
        logger.i(combined);

      default:
        logger.e(response);
    }
  }

  /// Whether to pretty print a JSON or return as regular String
  String _getBody(dynamic data) {
    return data.toString();
  }

  String _getQueryParams(Map<String, dynamic>? queryParams) {
    var result = '';

    if (queryParams != null && queryParams.isNotEmpty) {
      result += '===== Query Parameters =====';
      // Temporarily save the query params as string concatenation to be joined
      final params = <String>[];
      for (final entry in queryParams.entries) {
        params.add('${entry.key} : ${entry.value.toString()}');
      }
      result += '\n${params.join('\n')}';
    }
    return result;
  }
}
