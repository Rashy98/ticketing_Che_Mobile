
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/Journey/ScanQR.dart';
import 'package:ticketing_app/Screens/History/ShowHistory.dart';
import 'package:ticketing_app/Screens/Topup/TopUp.dart';
import 'package:ticketing_app/Screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';




class NavDrawer extends StatelessWidget {
  SharedPreferences preference;
  @override
  Widget build(BuildContext context) {
    return
      Drawer(
      child: Container(
          color: Color.fromARGB(255, 115, 71, 108),
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 180.0,
          child: DrawerHeader(

            child: Text(
              'MANUJAYA'+"\n" + "07738203938" +"\n" + "Pay-As-You-Go",
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.directions_transit,
                           color: Colors.white),
            title: Text('START JOURNEY' , style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18
            ),
            ),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ScanQR())
              )
            },
          ),

          ListTile(
            leading: Icon(Icons.history,
                color: Colors.white),
            title: Text('VIEW PAST JOURNEYS' , style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18
            ),
            ),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => showHistory())
              )
            },
          ),

            ListTile(
            leading: Icon(Icons.payment,
                color: Colors.white),
            title: Text('TOP UP ACCOUNT' , style: const TextStyle(
              color: Color(0xFFFFFFFF),
                fontSize: 18
            ),
            ),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => TopUp())
                )
              },

          ),
          ListTile(
            leading: Icon(Icons.help,
                color: Colors.white),
            title: Text('HELP' , style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18
            ),
            ),
            onTap: () {
            },

          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                color: Colors.white),
            title: Text('Logout',style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18
            ),),
            onTap: () async => {
              preference = await SharedPreferences.getInstance(),
              preference.remove('token'),
              Navigator.of(context).pop(),
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginPage())
              )
            },
          ),
        ],
      )
      ),
    );
  }
}