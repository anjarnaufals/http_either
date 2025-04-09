import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart' as testing;
import 'package:http_either/http_either.dart';
import 'package:test/test.dart';

void main() {
  const String baseUrl = 'www.example.com';
  const String path = '/test';
  const Map<String, String> headers = {};
  const Map<String, dynamic> successResponse = {
    "code": 200,
    "data": {},
  };
  const Map<String, dynamic> failureResponse = {
    "error": "something Error",
  };
  Map<String, dynamic> uploadedData = {};

  group('Http Either Test', () {
    // only two case htpp code status tested
    // code 200 success
    // forbiden 403 failure

    //mocking http response success
    testing.MockClient mockHttpResponseSuccess = testing.MockClient((_) {
      // do something logic if use request query

      final bodyRes = jsonEncode(successResponse);
      return Future.value(Response(bodyRes, 200));
    });

    //mocking http response failure
    testing.MockClient mockHttpResponseFailure = testing.MockClient((_) {
      // do something logic if use request query

      final bodyRes = jsonEncode(failureResponse);
      return Future.value(Response(bodyRes, 403));
    });

    // if you want test each http method depend on your needs
    // try create every http method test case

    // testing.MockClient mockGETsuccess;
    // testing.MockClient mockGETfailure;
    // testing.MockClient mockPOSTsuccess;
    // testing.MockClient mockPOSTfailure;
    // testing.MockClient mockDELETEsuccess;
    // testing.MockClient mockDELETEfailure;
    // testing.MockClient mockPUTsuccess;
    // testing.MockClient mockPUTfailure;
    // testing.MockClient mockHEADsuccess;
    // testing.MockClient mockHEADfailure;
    // testing.MockClient mockPATCHsuccess;
    // testing.MockClient mockPATCHfailure;

    test('GET method success', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseSuccess,
      );

      var res = await httpEither.get(
        path,
        showLog: true,
      );

      dynamic eitherSuccess;

      if (res.isRight) {
        eitherSuccess = res.right;
      }

      expect(eitherSuccess, successResponse);
    });

    test('GET method failure', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseFailure,
      );

      var res = await httpEither.get(
        path,
        showLog: true,
      );

      dynamic eitherFailure;

      if (res.isLeft) {
        eitherFailure = res.left.response;
      }

      expect(eitherFailure, failureResponse);
    });

    test('POST method success', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseSuccess,
      );

      var res = await httpEither.post(
        path,
        uploadedData,
        showLog: true,
      );

      dynamic eitherSuccess;

      if (res.isRight) {
        eitherSuccess = res.right;
      }

      expect(eitherSuccess, successResponse);
    });

    test('POST method failure', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseFailure,
      );

      var res = await httpEither.post(
        path,
        uploadedData,
        showLog: true,
      );

      dynamic eitherFailure;

      if (res.isLeft) {
        eitherFailure = res.left.response;
      }

      expect(eitherFailure, failureResponse);
    });

    test('DELETE method success', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseSuccess,
      );

      var res = await httpEither.delete(
        path,
        showLog: true,
      );

      dynamic eitherSuccess;

      if (res.isRight) {
        eitherSuccess = res.right;
      }

      expect(eitherSuccess, successResponse);
    });

    test('DELETE method failure', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseFailure,
      );

      var res = await httpEither.delete(
        path,
        showLog: true,
      );

      dynamic eitherFailure;

      if (res.isLeft) {
        eitherFailure = res.left.response;
      }

      expect(eitherFailure, failureResponse);
    });

    test('PUT method success', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseSuccess,
      );

      var res = await httpEither.put<Map<String, dynamic>>(
        path,
        data: uploadedData,
        showLog: true,
      );

      dynamic eitherSuccess;

      if (res.isRight) {
        eitherSuccess = res.right;
      }

      expect(eitherSuccess, successResponse);
    });

    test('PUT method failure', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseFailure,
      );

      var res = await httpEither.put<Map<String, dynamic>>(
        path,
        data: uploadedData,
        showLog: true,
      );

      dynamic eitherFailure;

      if (res.isLeft) {
        eitherFailure = res.left.response;
      }

      expect(eitherFailure, failureResponse);
    });
    test('HEAD method success', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseSuccess,
      );

      var res = await httpEither.head(
        path,
        {},
        showLog: true,
      );

      dynamic eitherSuccess;

      if (res.isRight) {
        eitherSuccess = res.right;
      }

      expect(eitherSuccess, successResponse);
    });

    test('HEAD method failure', () async {
      final HttpEither httpEither = HttpEither(
        baseUrl: baseUrl,
        headers: headers,
        client: mockHttpResponseFailure,
      );

      var res = await httpEither.head(
        path,
        {},
        showLog: true,
      );

      dynamic eitherFailure;

      if (res.isLeft) {
        eitherFailure = res.left.response;
      }

      expect(eitherFailure, failureResponse);
    });
  });
}
