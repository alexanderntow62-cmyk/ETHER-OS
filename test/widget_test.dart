import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/main.dart';

void main() {
  testWidgets('ETHER-OS launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const EtherOS());

    expect(find.text('ETHER'), findsOneWidget);
    expect(find.text('AUTONOMOUS INTELLIGENCE'), findsOneWidget);
    expect(find.text('ONLINE'), findsWidgets);

    expect(find.text('CORE'), findsWidgets);
    expect(find.text('AI'), findsWidgets);
    expect(find.text('BUSINESS'), findsWidgets);
    expect(find.text('SYSTEM'), findsWidgets);
  });
}
