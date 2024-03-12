part of 'http_either_base.dart';

class ApiException implements Exception {
  ApiException({
    this.code,
    this.message,
    this.res,
  });

  final int? code;
  final String? message;
  final dynamic res;
}
