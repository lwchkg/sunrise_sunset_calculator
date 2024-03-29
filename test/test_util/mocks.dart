// This file is copied directly from package flutter_map, which is under a
// 3-clause BSD license, except for having this comment added to show its
// copyright status. However, the content of this file lacks originality and
// therefore is likely not copyrightable.

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunrise_sunset_calculator/utils/settings.dart';

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  final _stream = readFile();

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => File('test/res/map.png').lengthSync();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  static Stream<List<int>> readFile() => File('test/res/map.png').openRead();
}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() => Future.value(MockHttpClientResponse());
}

class MockClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(MockHttpClientRequest());
  }
}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? securityContext) => MockClient();
}

void setupMocks() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
    SharedPreferences.setMockInitialValues({});
    return Settings.init();
  });
}
