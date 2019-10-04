import 'dart:convert';

import 'package:flutter_clean_archicture/core/error/exception.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailed404() {
    when(mockHttpClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response("some", 404));
  }

  group("getConcreteNumber", () {
    test('''should perform a get request on a URL with a number 
    being an endpoint with application/json for header''', () async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(
        "http://numbersapi.com/$tNumber",
        headers: {"Content-Type": "application/json"},
      ));
    });

    test("should return a number when the respons code is 200", () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, tNumberTriviaModel);
    });

    test(
        "should retrun a response exception when the response code is 404 or other",
        () async {
      setUpMockHttpClientFailed404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumber", () {
    test('''should perform a get request on a URL with a number 
    being an endpoint with application/json for header''', () async {
      setUpMockHttpClientSuccess200();
      dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(
        "http://numbersapi.com/random",
        headers: {"Content-Type": "application/json"},
      ));
    });

    test("should return a number when the respons code is 200", () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, tNumberTriviaModel);
    });

    test(
        "should retrun a response exception when the response code is 404 or other",
        () async {
      setUpMockHttpClientFailed404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
