import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void expectTextInOrder(List<String> text, {skipOffstage = false}) {
  TestAsyncUtils.guardSync();
  final elements = collectAllElementsFrom(
      WidgetsBinding.instance.rootElement!,
      skipOffstage: skipOffstage);

  var iter = text.iterator;
  if (!iter.moveNext()) return;

  for (final element in elements) {
    final widget = element.widget;
    if (widget is RichText && widget.text.toPlainText() == iter.current) {
      if (!iter.moveNext()) return;
    }
  }

  throw TestFailure('Cannot find text ${iter.current} from the widgets.');
}
