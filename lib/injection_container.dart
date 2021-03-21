import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';
import 'features/trivia/data/datasources/number_trivia_remote_data_source.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! features = Number Trivia
  //* bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  /// data
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(
            client: sl(),
          ));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(
            sharedPreferences: sl(),
          ));

  //! Core
  sl.registerLazySingleton(
    () => InputConverter(),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetWorkInfoImpl(sl()),
  );
  //! External
  final sharedPrefrences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => sharedPrefrences,
  );

  sl.registerLazySingleton(
    () => http.Client(),
  );
  sl.registerLazySingleton(
    () => DataConnectionChecker(),
  );
}
