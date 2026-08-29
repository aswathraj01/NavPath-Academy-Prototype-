import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navpath_academy/main.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const NavPathAcademyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
