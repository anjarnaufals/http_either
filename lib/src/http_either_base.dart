import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

part 'api_exception.dart';
part 'http_common_request.dart';
part 'http_log_encoder.dart';
part 'http_status_code.dart';

class HttpEither with HttpCommonRequest {
  HttpEither({
    required this.baseUrl,
    this.headers,
  }) {
    _client = RetryClient(
      http.Client(),
    );
  }

  final String baseUrl;
  final Map<String, String>? headers;

  late final RetryClient _client;

  @override
  Future<Either<ApiException, dynamic>> delete<T>(
    String url, {
    T? data,
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    return _eitherCallHttp(
      _client.delete(
        uri,
        body: data,
        headers: headers,
      ),
      _client,
      showLog: showLog,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
    showLog = false,
    useHttps = true,
    useConsolePrint = false,
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
      useConsolePrint: useConsolePrint,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> head(
    String url, {
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
    );
  }

  @override
  Future<Either<ApiException, dynamic>> patch<T>(
    String url,
    T? data, {
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    return _eitherCallHttp(
      _client.patch(
        uri,
        headers: headers,
        body: data,
      ),
      _client,
      showLog: showLog,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> post<T>(
    String url,
    T? data, {
    showLog = false,
    useHttps = true,
  }) async {
    final Uri uri = useHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    return _eitherCallHttp(
      _client.post(
        uri,
        body: data,
        headers: headers,
      ),
      _client,
      showLog: showLog,
    );
  }

  @override
  Future<Either<ApiException, dynamic>> put<T>(
    String url,
    T? data, {
    showLog = false,
    useHttps = true,
  }) {
    final Uri uri = useHttps ? Uri.https(baseUrl, url) : Uri.http(baseUrl, url);

    return _eitherCallHttp(
      _client.put(
        uri,
        headers: headers,
        body: data,
      ),
      _client,
      showLog: showLog,
    );
  }

  Future<Either<ApiException, dynamic>> _eitherCallHttp(
    Future<http.Response> future,
    RetryClient client, {
    bool showLog = false,
    bool useConsolePrint = false,
  }) async {
    try {
      http.Response? response;
      await future.then((res) {
        if (showLog) {
          log('RESPONSE[${res.statusCode}');
          HttpLogEncoder.prettyLogJson(
            res.body,
          );
        }

        response = res;
      });

      switch (response?.statusCode) {
        case HttpStatusCodes.ok:
          return Right(
            jsonDecode(response?.body ?? ''),
          );

        case HttpStatusCodes.internalServerError:
          return Left(
            ApiException(
              code: response?.statusCode,
              message: response?.reasonPhrase,
              data: _internalSeverErrorMap,
            ),
          );

        case HttpStatusCodes.notImplemented:
          return Left(
            ApiException(
              code: response?.statusCode,
              message: response?.reasonPhrase,
              data: _notImplementedMap,
            ),
          );

        default:
          return Left(
            ApiException(
              code: response?.statusCode,
              message: response?.reasonPhrase,
              data: response?.body ?? _somethingErrorMap,
            ),
          );
      }
    } on SocketException catch (e) {
      return Left(
        ApiException(
          message: e.message,
        ),
      );
    } on FormatException catch (e) {
      return Left(
        ApiException(
          message: e.message,
        ),
      );
    } on Exception catch (e, t) {
      return Left(
        ApiException(
          message:
              '<----Exception----> \n ${e.toString()} \n\n <----Trace----> \n ${t.toString()}',
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
