import 'dart:convert';

import 'package:crewmeister_frontend_coding_challenge/features/absences/data/models/absence_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../test_constants.dart';

void main() {
  test('Should be a subclass of Absence entity', () async {
    // assert
    expect(TestConstants.tAbsenceModel, isA<AbsenceModel>());
  });

  group('fromJson', () {
    test('should return a valid model after reading data from json', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(TestConstants.fixture('absences/models/absence_map.json'));

      // act
      final result = AbsenceModel.fromJson(jsonMap);

      // assert
      expect(result, TestConstants.tAbsenceModel);
    });
  });
}
