import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/platfom/network_info.dart';
import 'package:number_trivia/features/trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaREpositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumberTriviaREpositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });
}
