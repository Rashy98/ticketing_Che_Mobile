import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import 'package:ticketing_app/Screens/History/ShowHistory.dart';
import 'package:ticketing_app/Screens/Journey/ScanQR.dart';



void main() {
  testWidgets(
      'ScanQR does not contain any images', (WidgetTester tester) async {
    // create a ScanQRPage
    ScanQR scanQR = new ScanQR();

    // add it to the widget tester
    await tester.pumpWidget(scanQR);

    expect(find.byType(Image), findsNothing);
  });


  testWidgets(
      'ScanQR contains a progress indicator', (WidgetTester tester) async {

    // create a ScanQRPage
    ScanQR scanQR = new ScanQR();
    // add it to the widget tester
    await tester.pumpWidget(scanQR);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
