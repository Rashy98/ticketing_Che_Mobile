import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/ScanQR.dart';
import 'package:ticketing_app/Screens/ShowHistory.dart';
import 'package:ticketing_app/Screens/StartPoint.dart';
import 'package:ticketing_app/Screens/TopUp.dart';


class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
//            decoration: BoxDecoration(
//                color: Colors.green,
//                image: DecorationImage(
//                    fit: BoxFit.fill,
//                    )),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.directions_transit),
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
            leading: Icon(Icons.history),
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
            leading: Icon(Icons.payment),
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
            leading: Icon(Icons.help),
            title: Text('HELP' , style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18
            ),
            ),
            onTap: () {
            },

          ),

          SizedBox(
            height: 250,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout',style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18
            ),),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => StartPointC())
              )
            },
          ),
        ],
      )
      ),
    );
  }
}