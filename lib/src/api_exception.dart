part of 'http_either_base.dart';

class ApiException implements Exception {
  ApiException({
    this.code,
    this.message,
    this.data,
  });

  final int? code;
  final String? message;
  final dynamic data;
}
