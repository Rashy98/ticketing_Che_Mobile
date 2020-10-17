import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import 'package:ticketing_app/Screens/History/ShowHistory.dart';
import 'package:ticketing_app/Screens/Journey/ScanQR.dart';
import 'package:ticketing_app/Screens/Topup/TopUp.dart';



void main() {
  testWidgets(
      'TopUp contains a SingleChildScrollView ', (WidgetTester tester) async {
    // create a TopUp
    TopUp topUp = new TopUp();
    // add it to the widget tester
    await tester.pumpWidget(topUp);

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });


  testWidgets(
      'ScanQR does not contains a progress indicator', (WidgetTester tester) async {
    // create a TopUp
    TopUp topUp = new TopUp();
    // add it to the widget tester
    await tester.pumpWidget(topUp);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
