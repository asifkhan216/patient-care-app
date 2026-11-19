import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash_screen_new/chat_room_screen.dart';

void main() {
  group('formatChatTime (unit tests)', () {
    test('returns an empty string for an empty value', () {
      expect(formatChatTime(''), '');
    });

    test('returns an empty string for an invalid date', () {
      expect(formatChatTime('not a date'), '');
    });

    test('shows HH:mm for a message sent today', () {
      final now = DateTime.now();
      final sentToday = DateTime(now.year, now.month, now.day, 9, 5);
      expect(formatChatTime(sentToday.toString()), '09:05');
    });

    test('shows dd/MM for an older message', () {
      expect(formatChatTime('2020-03-07 10:30:00.000'), '07/03');
    });
  });

  group('ChatAvatar (widget tests)', () {
    testWidgets('shows the first letter in capitals when there is no photo',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ChatAvatar(name: 'asif')),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('shows a question mark when the name is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ChatAvatar(name: '')),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('ignores a photo value of "null" and shows the letter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatAvatar(name: 'nurse', imageUrl: 'null'),
          ),
        ),
      );

      expect(find.text('N'), findsOneWidget);
    });
  });
}