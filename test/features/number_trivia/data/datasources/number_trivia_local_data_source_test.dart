import 'dart:convert';

import 'package:flutter_clean_archicture/core/error/exception.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return numbertrivia from sharedPreferences when there is cached data',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw  a CacheException when there is no cached number_trivia',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cache number_trivia', () {
    final tNumnerTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');
    test('should call SharedPreferences ', () async {
      dataSource.cacheNumberTrivia(tNumnerTriviaModel);
      final expectJsonString = json.encode(tNumnerTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectJsonString));
    });
  });
}
