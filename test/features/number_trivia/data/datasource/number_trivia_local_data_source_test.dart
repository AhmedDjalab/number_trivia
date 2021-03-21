import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPrefrences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPrefrences mockSharedPrefrences;

  setUp(() {
    mockSharedPrefrences = MockSharedPrefrences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPrefrences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      "should return NumberTrivia from Sharedpreferences when there is one in the cached ",
      () async {
        // arrange
        when(mockSharedPrefrences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPrefrences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw CacheException  when there is no cached value ",
      () async {
        // arrange
        when(mockSharedPrefrences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<CacheExceptions>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "test Trivia");
    test(
      "should call sharedPreference to cache data  ",
      () async {
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);

        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPrefrences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
