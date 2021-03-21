import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test(
      "should return a integer when a string represent an unsigned integer",
      () async {
        // arrange
        final str = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Right(123));
      },
    );

    test(
      "should return a Failure when a string is not  an unsigned integer",
      () async {
        // arrange
        final str = 'abc';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      "should return a Failure when a string is a negative number",
      () async {
        // arrange
        final str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
