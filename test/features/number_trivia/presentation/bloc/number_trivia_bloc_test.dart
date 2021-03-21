import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/trivia/presentation/bloc/number_trivia_bloc.dart';

//  final GetConcreteNumberTrivia getConcreteNumberTrivia;
//   final GetRandomNumberTrivia getRandomNumberTrivia;
//   final InputConverter inputConverter;

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    "initilState should be empty  ",
    () async {
      // assert
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = "1";
    final tNumberParsed = 1;
    final tNumbereTrivia = NumberTrivia(text: 'test trivia ', number: 1);
    void setUpMockInputConverterSucess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      "should call the input converter to validate and convert the string to unsigned integer",
      () async {
        // arrange
        setUpMockInputConverterSucess();
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      "should emit [Error] when the input is invalid ",
      () async {
        // assert Later
        var matchers = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(matchers));
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      },
    );

    test(
      "should get data from the concrete use case ",
      () async {
        // arrange

        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumbereTrivia));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));

        // assert
        verify(mockGetConcreteNumberTrivia(Parmas(number: tNumberParsed)));
      },
    );

    test(
      "should emit [loading , Loaded ] when data is gotten succefully ",
      () async {
        // arrange

        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumbereTrivia));

        // assert Later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumbereTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
      },
    );

    test(
      "should emit [loading , Error ] when getting data failed  ",
      () async {
        // arrange

        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert Later

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
      },
    );

    test(
      "should emit [loading , Error ] when getting data failed with proper Error Message  ",
      () async {
        // arrange

        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CHACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
      },
    );
  });

  group('GetRandomTrivia', () {
    final tNumbereTrivia = NumberTrivia(text: 'test trivia ', number: 1);

    test(
      "should get data from Random use case ",
      () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumbereTrivia));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        // assert
        verify(mockGetRandomNumberTrivia(NoParmas()));
      },
    );

    test(
      "should emit [loading , Loaded ] when data is gotten succefully ",
      () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumbereTrivia));

        // assert Later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumbereTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
      },
    );

    test(
      "should emit [loading , Error ] when getting data failed  ",
      () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert Later

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
      },
    );

    test(
      "should emit [loading , Error ] when getting data failed with proper Error Message  ",
      () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert Later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CHACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
      },
    );
  });
}
