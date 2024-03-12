part of 'http_either_base.dart';

class HttpLogEncoder {
  static JsonDecoder decoder = const JsonDecoder();
  static JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  static prettyLogJson(
    String input, {
    required String statusCode,
    bool error = false,
  }) {
    if (input != '') {
      final logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          colors: true,
          printTime: false,
          printEmojis: false,
        ),
      );
      if (error) {
        logger.e('STATUS CODE => $statusCode \n\n$input');
      } else {
        logger.i('STATUS CODE => $statusCode \n\n$input');
      }
    }
  }
}
