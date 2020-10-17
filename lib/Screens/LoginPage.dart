import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/Journey/FinishScan.dart';
import 'package:ticketing_app/Screens/Journey/ScanQR.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget{

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State <LoginPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool _isloading = false;
  var id = null;

  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }
  @override
  void initState (){

    getUser().then((value) => {
        if(value != null){
          Navigator.of(context).pop(),
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScanQR())
          )}
    });
    super.initState();
  }
  getdata() async{
    var user = await getUser();
    print(await getUser());
    setState(() {
      id =  user;
    });
  }

  signIn(String email, String pass) async {
    String url = "http://10.0.2.2:8000/user/login";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {"email": email, "password": pass};
    var jsonResponse;
    var res = await http.post(url, body: body);
    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);

//      print("Response Status: ${res.statusCode}");
//      print("Response Status: ${res.body}");

      if (jsonResponse != null) {
        setState(() {
          _isloading = false;
        });

        sharedPreferences.setString("token", jsonResponse['id']);
        print(sharedPreferences.getString('token'));
        var sId = sharedPreferences.getString('token');



        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => ScanQR()),
                (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isloading = false;
      });
      print("Response Status: ${res.body}");
    }
  }
    authenticate(String email, String pass) async {
      String myurl =
          "http://10.0.2.2:8000/user/login/";
      http.post(myurl, headers: {
        'Accept': 'application/json',
        'authorization': 'pass your key(optional)'
      }, body: {
        "email": email,
        "password": pass
      }).then((response) {
        print(response.statusCode);
        print(response.body);

      });
  }


  @override
  Widget build(BuildContext context) {
    return
      new MediaQuery(
        data: new MediaQueryData(),
        child:MaterialApp(
        home:Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 182, 82, 80),
                    Color.fromARGB(255, 115, 71, 108),
                  ])
          ),
        ),

//        title: Text('TicketingApp'),

      ),
      body: Container(
         child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: new BoxDecoration(
//                         border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70.0),
                      bottomRight: Radius.circular(70.0)),
                  gradient: new LinearGradient(
                      colors: [
                        Color.fromARGB(255, 182, 82, 80),
                        Color.fromARGB(255, 115, 71, 108),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 200,
                            width: 412,
                            decoration: BoxDecoration(
//                        border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                                boxShadow: [
//                          BoxShadow(color:  Colors.red)
                                ]
                            ),

//                            child:Center(
                            child: Column(
                                children: [
                                  Text('Destino', style: TextStyle(color: Colors
                                      .white, fontSize: 70, fontWeight: FontWeight
                                      .bold),  textAlign: TextAlign.center, ),
                                  Text('Log In', style: TextStyle(color: Colors
                                      .white, fontSize: 30,), textAlign: TextAlign.center,)

                                ]
                            )
                        ),
                      ]

                  ),
                )
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),

                child: Column(
                  children: [
                    Container (
                        child:TextField
                          (
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple))),
                        )
                    ),
                    SizedBox(height: 20.0),
                    Container (
                        child:TextField
                          (
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple))),
                        )
                    ),

                    SizedBox(height: 40.0),

                    Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: ()=> signIn(_emailController.text.trim(), _passController.text.trim()),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(255, 182, 82, 80),
                                Color.fromARGB(255, 115, 71, 108)
                              ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 150.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Log In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),



                 ],

                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New to Destino ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {

                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Color.fromARGB(255, 182, 82, 80),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )

          ],
        ),
      ),
      )
    )
    )
      );

  }
}
