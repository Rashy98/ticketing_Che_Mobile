import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/FinishScan.dart';
import 'package:ticketing_app/Screens/ScanQR.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SignupPage extends StatefulWidget{

  @override
  _SignupPageState createState() => _SignupPageState();
}


class _SignupPageState extends State <SignupPage> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _nicController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool _isloading = false;


  Future<http.Response> AddPayee() async {
    final response = await http.post(
      'http://10.0.2.2:8000/user/add',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode({
        'name': _nameController.text,
        'email':_emailController.text,
        'password':_passController.text,
        'nic':_nicController.text,
        'contactNumber':_phoneController.text,
        'url':_nameController.text + _emailController.text + _nicController.text + _phoneController.text ,
        'TravelAccount':"Pay as You Go"
      }),
    );


//      print(response);

//      if (response.statusCode == 201) {
//        return http.Response.fromJson(jsonDecode(response.body));
//      } else {
//        throw Exception('Failed to create album.');
//      }
    }

//    if (response.statusCode == 201) {
//      return User.fromJson(jsonDecode(response.body));
//    } else {
//      throw Exception('Failed to create album.');
//    }
//  }


//  Future<http.Response>  AddPayee() async {
//    final response = await http
//        .post("http://10.0.2.2:8000/user/add/", body: {
//      'name':_nameController.text,
//      'email':_emailController.text,
//      'password':_passController.text,
//      'nic':_nicController.text,
//      'contactNumber':_phoneController.text,
//      'TravelAccount':"Pay as You Go"
//    });
//    var reponse = await http.get(response,
//        headers: {"Accept": "application/json"});
//      var user = json.decode(reponse.body);




//
//  AddPayee() async {
//    String url = "http://10.0.2.2:8000/user/add";
//    var user =  {
//      'name':_nameController.text,
//      'email':_emailController.text,
//      'password':_passController.text,
//      'nic':_nicController.text,
//      'contactNumber':_phoneController.text,
//      'TravelAccount':"Pay as You Go"
//
//    };
//    var reponse = await http.get(url,
//        headers: {"Accept": "application/json"});
//      user = json.decode(reponse.body);
//  }
//    String url =
//        'https://uee-pan-backend.herokuapp.com/user/pushRegisteredPayeesFund/';
//    Map map = {
//      '_id':'5f7094ced1c8261f4f9b756f',
//      'RegisteredPayeesFund':[{"name":_nameController.text,"accNumber":_nicController.text,"bankName":_phoneController.text,"email":_emailController.text,"email":_passController.text}]
//    };
//    print(await apiRequest(url, map));
//  }


//  Future<String> apiRequest(String url, Map jsonMap) async {
//    HttpClient httpClient = new HttpClient();
//    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//    request.headers.set('content-type', 'application/json');
//    request.add(utf8.encode(json.encode(jsonMap)));
//    HttpClientResponse response = await request.close();
//    // todo - you should check the response.statusCode
//    String reply = await response.transform(utf8.decoder).join();
//    httpClient.close();
//    return reply;
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
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
                            height: 150,
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
                                  Text('Sign Up', style: TextStyle(color: Colors
                                      .white, fontSize: 30,), textAlign: TextAlign.center,)

                                ]
                            )
                        ),
                      ]

                  ),
                )
            ),
            Container(
                padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),

                child: Column(
                  children: [
                    Container (
                        child:TextField
                          (
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple))),
                        )
                    ),
                    SizedBox(height: 5.0),
                    Container (
                        child:TextField
                          (
                          controller: _nicController,
                          decoration: InputDecoration(
                              labelText: 'NIC',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple))),
                        )
                    ),
                    SizedBox(height: 5.0),
                    Container (
                        child:TextField
                          (
                          controller: _phoneController,
                          decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple))),
                        )
                    ),
                    SizedBox(height: 5.0),
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
                    SizedBox(height: 5.0),
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

                    SizedBox(height: 15.0),

                    Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: ()=> AddPayee(),
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
                                maxWidth: 200.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Sign Up",
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
//                  Container(
//                    height: 40.0,
//                    child: Material(
//                      borderRadius: BorderRadius.circular(20.0),
//                      shadowColor: Colors.greenAccent,
//                      color: Color.fromARGB(255, 182, 82, 80),
//                      elevation: 7.0,
//                      child: GestureDetector(
//                        onTap: _emailController.text == "" || _passController.text ==""
//                        ? null
//                        :(){
//                          setState(() {
//                            _isloading = true;
//                          });
//                          signIn(_emailController.text, _passController.text);
//                        },
//                        child: Center(
//                          child: Text(
//                            'LOGIN',
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: 'Montserrat'),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
                    SizedBox(height: 10.0),



                  ],

                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already Registered ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Log In',
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
    );
  }
}
