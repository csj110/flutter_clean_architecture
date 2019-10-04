import 'dart:convert';

import 'package:flutter_clean_archicture/core/error/exception.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';
import "package:http/http.dart" as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  ///calls the http://numbersapi.com/{number} endpoint.
  ///
  ///Throw a [ServerException] for all errors.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// call the http://numbersapi.com/random endpoint.
  ///
  /// throw a [ServerException] for all errors.
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getNumbertrivaiByURL('http://numbersapi.com/$number');

  @override
  Future<NumberTrivia> getRandomNumberTrivia() =>
      _getNumbertrivaiByURL('http://numbersapi.com/random');

  Future<NumberTrivia> _getNumbertrivaiByURL(String url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }
}
