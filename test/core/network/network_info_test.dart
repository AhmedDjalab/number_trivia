import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetWorkInfoImpl netWorkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    netWorkInfoImpl = NetWorkInfoImpl(mockDataConnectionChecker);
  });

  group("isConnected ", () {
    test(
      "should forward a call to DataConnectionChecker.haasConection",
      () async {
        final tHasconnectionFuture = Future.value(true);
        // arrange
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasconnectionFuture);
        // act
        final result = netWorkInfoImpl.isConnected;
        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasconnectionFuture);
      },
    );
  });
}
