import 'package:flutter_clean_archicture/core/network/newwork_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to dataConnectionChecker', () async {
      final Future<bool> tHasConnecctionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnecctionFuture);
      final result = networkInfoImpl.isConncted;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnecctionFuture);
    });
  });
}
