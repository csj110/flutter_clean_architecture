import 'dart:convert';

import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test('should retrun a valid model when the Json number is an interger',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
    test(
        'should retrun a valid model when the Json number is regarded as a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test(
      'should return a json contianing the proper data',
      () async {
        final result = tNumberTriviaModel.toJson();
        final target = {"text": "Test text", "number": 1.0};
        expect(
          result,
          target,
        );
      },
    );
  });
}
