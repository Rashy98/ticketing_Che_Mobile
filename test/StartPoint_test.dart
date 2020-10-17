import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import 'package:ticketing_app/Screens/History/ShowHistory.dart';
import 'package:ticketing_app/Screens/Journey/ScanQR.dart';
import 'package:ticketing_app/Screens/Journey/StartPoint.dart';
import 'package:ticketing_app/Screens/LoginPage.dart';
import 'package:ticketing_app/Screens/Register.dart';

void main() {
  testWidgets('StartPointC contains 8 containers', (WidgetTester tester) async {
    // create a LoginPage
    StartPointC startPointC = new StartPointC();
    // add it to the widget tester
    await tester.pumpWidget(startPointC);

    expect(find.byType(Container),findsNWidgets(8));
  });


  testWidgets('ScanQR contains the text Scan to Finish journey', (WidgetTester tester) async {
    // create a LoginPage
    StartPointC loginPage = new StartPointC();
    // add it to the widget tester
    await tester.pumpWidget(loginPage);

    final labelFinder = find.text('Scan to Finish journey');
    expect(labelFinder, findsOneWidget);
  });

}