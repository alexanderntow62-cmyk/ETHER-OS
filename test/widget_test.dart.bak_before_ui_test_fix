import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/main.dart';

void main() {
  testWidgets('ETHER-OS launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const EtherOS());

    expect(find.text('ETHER-OS'), findsOneWidget);
    expect(find.text('WELCOME TO ETHER'), findsOneWidget);
    expect(find.text('CORE'), findsOneWidget);
    expect(find.text('AI'), findsOneWidget);
    expect(find.text('BUSINESS'), findsOneWidget);
    expect(find.text('SYSTEM'), findsOneWidget);
  });
}
