import 'dart:convert';

import 'package:crewmeister_frontend_coding_challenge/features/absences/data/models/member_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../test_constants.dart';

void main() {
  test('Should be a subclass of Member entity', () async {
    // assert
    expect(TestConstants.tMemberModel, isA<MemberModel>());
  });

  group('fromJson', () {
    test('should return a valid model after reading data from json', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(TestConstants.fixture('absences/models/member_map.json'));

      // act
      final result = MemberModel.fromJson(jsonMap);

      // assert
      expect(result, TestConstants.tMemberModel);
    });
  });
}
