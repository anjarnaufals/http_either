part of 'http_either.dart';

/// [HttpStatusCode]
///
/// list of http status code
sealed class HttpStatusCode {
  // Success

  ///  http status code 200
  static const int ok = 200;

  ///  http status code 201
  static const int created = 201;

  ///  http status code 202
  static const int accepted = 202;

  ///  http status code 204
  static const int noContent = 204;

  ///  http status code 205
  static const int resetContent = 205;

  // Redirection

  ///  http status code 301
  static const int permanentRedirect = 301;

  ///  http status code 302
  static const int temporaryRedirect = 302;

  ///  http status code 303
  static const int seeOther = 303;

  ///  http status code 304
  static const int notModified = 304;

  // Client Error

  ///  http status code 400
  static const int badRequest = 400;

  ///  http status code 401
  static const int unauthorized = 401;

  ///  http status code 403
  static const int forbidden = 403;

  ///  http status code 404
  static const int notFound = 404;

  ///  http status code 405
  static const int methodNotAllowed = 405;

  ///  http status code 408
  static const int requestTimeout = 408;

  // Server Error

  ///  http status code 500
  static const int internalServerError = 500;

  ///  http status code 501
  static const int notImplemented = 501;

  ///  http status code 502
  static const int badGateway = 502;

  ///  http status code 503
  static const int serviceUnavailable = 503;

  ///  http status code 504
  static const int gatewayTimeout = 504;
}
