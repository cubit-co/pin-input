import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_input/pin_input.dart';
import 'package:pin_input/src/pin_input_cursor.dart';

const DEFAULT_LENGTH = 4;

void main() {
  test('should have default length of $DEFAULT_LENGTH', () {
    final pinInput = PinInput();

    expect(pinInput.length, equals(DEFAULT_LENGTH));
    expect(pinInput.obscureText, equals(true));
  });

  test('should have new length with custom paramters', () {
    final customLength = 6;

    final pinInput = PinInput(length: customLength);

    expect(pinInput.length, equals(customLength));
  });

  testWidgets('should have only one text form field',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: PinInput(),
    )));

    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('shouldn\'t have cursor on disabled',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: PinInput(),
    )));

    expect(find.byType(PinInputCursor), findsNothing);
  });
}
