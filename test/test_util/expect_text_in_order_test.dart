import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'expect_text_in_order.dart';

void main() {
  testWidgets('expectTextInOrder', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Row(children: [Text('123'), Text('123'), Text('456')]),
      ),
    );

    expectTextInOrder([]);
    expectTextInOrder(['123']);
    expectTextInOrder(['456']);
    expectTextInOrder(['123', '123']);
    expectTextInOrder(['123', '456']);
    expectTextInOrder(['123', '123', '456']);

    expect(
        () => expectTextInOrder(['789']),
        throwsA(isA<TestFailure>().having(
          (error) => error.message,
          'message',
          stringContainsInOrder(['Cannot find', '789']),
        )));

    expect(
        () => expectTextInOrder(['456', '123']),
        throwsA(isA<TestFailure>().having(
          (error) => error.message,
          'message',
          stringContainsInOrder(['Cannot find', '123']),
        )));

    expect(
        () => expectTextInOrder(['123', '123', '123']),
        throwsA(isA<TestFailure>().having(
          (error) => error.message,
          'message',
          stringContainsInOrder(['Cannot find', '123']),
        )));

    expect(
        () => expectTextInOrder(['456', '456']),
        throwsA(isA<TestFailure>().having(
          (error) => error.message,
          'message',
          stringContainsInOrder(['Cannot find', '456']),
        )));

    expect(
        () => expectTextInOrder(['123', '456', '789']),
        throwsA(isA<TestFailure>().having(
          (error) => error.message,
          'message',
          stringContainsInOrder(['Cannot find', '789']),
        )));
  });
}
