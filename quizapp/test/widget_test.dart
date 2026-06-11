import 'package:flutter_test/flutter_test.dart';
import 'package:quizapp/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());
    expect(find.text('QuizMaster'), findsOneWidget);
  });
}
