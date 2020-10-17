import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import 'package:ticketing_app/Screens/History/ShowHistory.dart';
import 'package:ticketing_app/Screens/Journey/ScanQR.dart';
import 'package:ticketing_app/Screens/LoginPage.dart';



void main() {
  testWidgets(
      'LoginPage contains two text fields', (WidgetTester tester) async {
    // create a loginPage
    LoginPage loginPage = new LoginPage();

    // add it to the widget tester
    await tester.pumpWidget(loginPage);

    expect(find.byType(TextField), findsNWidgets(2));
  });


  testWidgets(
      'LoginPage contains one Raised Button', (WidgetTester tester) async {

    // create a loginPage
    LoginPage loginPage = new LoginPage();

    // add it to the widget tester
    await tester.pumpWidget(loginPage);

    expect(find.byType(RaisedButton), findsOneWidget);
  });
}
