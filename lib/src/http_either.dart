import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:logger/logger.dart';

part 'api_exception.dart';
part 'http_common_request.dart';
part 'http_log_encoder.dart';
part 'http_status_code.dart';

///[HttpEither]
/// A base class Dio Either Package
class HttpEither with HttpCommonRequest {
  ///[HttpEither]
  /// default constructor
  HttpEither({
    required this.baseUrl,
    required this.headers,
    required http.Client client,
    int retriesAttempt = 3,
  }) {
    _client = RetryClient(
      client,
      retries: retriesAttempt,
    );
  }

  /// baseUrl
  final String baseUrl;

  ///headers
  final Map<String, String>? headers;

  late final RetryClient _client;

  @override
  Future<Either<ApiException, dynamic>> delete<T>(
    String url, {
    Map<String, dynamic>? query,
    T? data,
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps
        ? Uri.https(baseUrl, url, query)
        : Uri.http(baseUrl, url, query);

    return _eitherCallHttp(
      _client.delete(
        uri,
        body: data,
        headers: headers,
      ),
      _client,
      showLog: showLog,
      query: query,
      method: 'DELETE',
      path: url,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps
        ? Uri.https(baseUrl, url, query)
        : Uri.http(baseUrl, url, query);

    return _eitherCallHttp(
      _client.get(
        uri,
        headers: headers,
      ),
      _client,
      showLog: showLog,
      query: query,
      method: 'GET',
      path: url,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> head<T>(
    String url,
    T? data, {
    Map<String, dynamic>? query,
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps
        ? Uri.https(baseUrl, url, query)
        : Uri.http(baseUrl, url, query);

    return _eitherCallHttp(
      _client.head(
        uri,
        headers: headers,
      ),
      _client,
      showLog: showLog,
      query: query,
      method: 'HEAD',
      path: url,
      body: data,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> patch<T>(
    String url,
    T? data, {
    Map<String, dynamic>? query,
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps
        ? Uri.https(baseUrl, url, query)
        : Uri.http(baseUrl, url, query);

    return _eitherCallHttp(
      _client.patch(
        uri,
        headers: headers,
        body: data,
      ),
      _client,
      showLog: showLog,
      query: query,
      method: 'PATCH',
      body: data,
      path: url,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> post<T>(
    String url,
    T? data, {
    Map<String, dynamic>? query,
    showLog = false,
    useHttps = true,
  }) async {
    final Uri uri = useHttps
        ? Uri.https(baseUrl, url, query)
        : Uri.http(baseUrl, url, query);

    return _eitherCallHttp(
      _client.post(
        uri,
        body: data,
        headers: headers,
      ),
      _client,
      showLog: showLog,
      query: query,
      method: 'POST',
      path: url,
      body: data,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> put<T>(
    String url, {
    T? data,
    Map<String, dynamic>? query,
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps
        ? Uri.https(baseUrl, url, query)
        : Uri.http(baseUrl, url, query);

    return _eitherCallHttp(
      _client.put(
        uri,
        headers: headers,
        body: data,
      ),
      _client,
      showLog: showLog,
      query: query,
      method: 'PUT',
      path: url,
      body: data,
    );
  }

  Future<Either<ApiException, dynamic>> _eitherCallHttp(
    Future<http.Response> future,
    RetryClient client, {
    bool showLog = false,
    Map<String, dynamic>? query,
    String? path,
    String? method,
    Object? body,
  }) async {
    try {
      http.Response? response;
      await future.then((res) {
        if (showLog) {
          HttpLogEncoder().prettyLogJson(
            res.statusCode,
            path,
            method,
            res,
            query,
            body,
          );
        }

        response = res;
      });

      switch (response?.statusCode) {
        case HttpStatusCode.ok:
          return Right(
            jsonDecode(response?.body ?? ''),
          );

        case HttpStatusCode.internalServerError:
          return Left(
            ApiException(
              code: response?.statusCode,
              message: response?.reasonPhrase,
              response: _internalSeverErrorMap,
            ),
          );

        case HttpStatusCode.notImplemented:
          return Left(
            ApiException(
              code: response?.statusCode,
              message: response?.reasonPhrase,
              response: _notImplementedMap,
            ),
          );

        default:
          return Left(
            ApiException(
              code: response?.statusCode,
              message: response?.reasonPhrase,
              response: jsonDecode(response?.body ?? '') ?? _somethingErrorMap,
            ),
          );
      }
    } on SocketException catch (e, trace) {
      if (showLog) {
        HttpLogEncoder().prettyErrorLog(e.message, trace);
      }

      return Left(
        ApiException(
          message: e.message,
        ),
      );
    } on FormatException catch (e, trace) {
      if (showLog) {
        HttpLogEncoder().prettyErrorLog(e.message, trace);
      }
      return Left(
        ApiException(
          message: e.message,
        ),
      );
    } on Exception catch (e, trace) {
      if (showLog) {
        HttpLogEncoder().prettyErrorLog(e.toString(), trace);
      }
      return Left(
        ApiException(
          message: 'Something Wrong',
        ),
      );
    } finally {
      client.close();
    }
  }
}

const Map<String, dynamic> _somethingErrorMap = {"message": "SOMETHING ERROR"};
const Map<String, dynamic> _notImplementedMap = {"message": "NOT IMPLEMENTED"};
const Map<String, dynamic> _internalSeverErrorMap = {
  "message": "INTERNAL SERVER ERROR"
};
