// ignore_for_file: prefer-match-file-name

import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:http_either/http_either.dart';

import 'todo.dart';
import 'your_error.dart';

// set tup
// https://jsonplaceholder.typicode.com
// remove https://
const String baseUrl = 'jsonplaceholder.typicode.com';
const String postlistUrl = '/comments';
const Map<String, dynamic> query = {"postId": "1"};
const Map<String, String> _constHeader = {};

void main() async {
  await getPostList();
}

class YourClient {
  static Future<Map<String, String>> _authorization() async {
    //your logic token case
    final token = '';
    final authorizationHeader = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      //your unique device id system
      "Device-ID": Platform.isAndroid ? 'Unique.androidId' : ' Unique.iosId',
    };

    return authorizationHeader;
  }

  Future<HttpEither> call({
    bool useAuthentication = false,
  }) async {
    return HttpEither(
      client: http.Client(),
      baseUrl: baseUrl,
      headers: useAuthentication ? await _authorization() : _constHeader,
    );
  }
}

// Repository GET todo list
Future<Either<YourError, List<Todo>>> getPostList() async {
  final YourClient yourClient = YourClient();
  try {
    var data = await yourClient.call().then((http) => http.get(
          postlistUrl,
          query: query,
          showLog: true,
        ));

    if (data.isLeft) {
      final yourError = YourError(
        code: data.left.code,
        msg: data.left.message,
      );

      return Left(yourError);
    } else {
      final todoList = List<Todo>.from(
        List.from(data.right).map((e) => Todo.fromMap(e)),
      ).toList();

      return Right(todoList);
    }
  } catch (e) {
    rethrow;
  }
}
