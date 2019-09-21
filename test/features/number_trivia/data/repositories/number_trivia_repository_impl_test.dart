import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/exception.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';
import 'package:flutter_clean_archicture/core/plateform/newwork_info.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('deivce is online', () {
      setUp(() {
        when(mockNetworkInfo.isConncted).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('deivce is online', () {
      setUp(() {
        when(mockNetworkInfo.isConncted).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: "Test text",
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the deviice is online', () {
      when(mockNetworkInfo.isConncted).thenAnswer((_) async => true);

      repositoryImpl.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConncted);
    });

    runTestsOnline(() {
      test('should return remote data when the server works well', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTrivia));
      });

      test('should cached the returned remote data', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the remote datasource is unsuccessful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('shoule return last local data when the caced data is not null',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('shoule return last local data when the caced data is null',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });


  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 123,
      text: "Test text",
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the deviice is online', () {
      when(mockNetworkInfo.isConncted).thenAnswer((_) async => true);

      repositoryImpl.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConncted);
    });

    runTestsOnline(() {
      test('should return remote data when the server works well', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should cached the returned remote data', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the remote datasource is unsuccessful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test('shoule return last local data when the caced data is not null',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);
        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('shoule return last local data when the caced data is null',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
