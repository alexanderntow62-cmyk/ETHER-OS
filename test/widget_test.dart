import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/main.dart';

void main() {
  testWidgets('ETHER-OS launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const EtherOS());

    // Top-level UI
    expect(find.text('ETHER-OS'), findsOneWidget);
    expect(find.text('INTELLIGENT OPERATING SYSTEM'), findsWidgets);

    // Bottom navigation
    expect(find.text('CORE'), findsWidgets);
    expect(find.text('AI'), findsWidgets);
    expect(find.text('BUSINESS'), findsWidgets);
    expect(find.text('SYSTEM'), findsWidgets);

    // Core section
    expect(find.text('CORE INTELLIGENCE'), findsOneWidget);
    expect(find.text('ETHER CORE'), findsWidgets);

    // Scroll until Agent is built.
    await tester.scrollUntilVisible(
      find.text('AGENT'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('AGENT'), findsOneWidget);

    // Scroll until Business Engine is built.
    await tester.scrollUntilVisible(
      find.text('BUSINESS ENGINE'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('BUSINESS ENGINE'), findsOneWidget);
  });
}
