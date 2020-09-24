import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/FinishScan.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;


class TopUp extends StatefulWidget{
  @override
  _TopUP createState() => _TopUP();
}


class _TopUP extends State<TopUp> {

  @override
  void initState() {

    super.initState();
  }

  int _value = 0;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: NavDrawer(),
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
        body: Column(
            children: [
              Container(
                decoration: new BoxDecoration(
//                   border: Border.all(color: Colors.red),
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
                          child: Center(
                              child: Text('Add credit', style: TextStyle(
                                  color: Colors.white, fontSize: 40),
                                textAlign: TextAlign.center,

                              )
                          )
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
              children: [
                Row(
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Text('Add amount',style: TextStyle(fontSize: 25)),
                    ),
              Container(
                  margin: EdgeInsets.only(left: 25),
              width: 150,
                  child:TextField
                    (decoration: InputDecoration(
                    border:  const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    hintText: '0.00',
                  ),
                  )
              )
            ],
              ),
                Row(
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 25,top: 10),
                      child: Text('Select Card type',style: TextStyle(fontSize: 19)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25,top: 10),
                    child:Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => setState(() => _value = 0),
                          child: Container(
                            height: 56,
                            width: 56,
                            color: _value == 0 ? Colors.grey : Colors.transparent,
                            child: Image.asset('assets/images/visa.png'),
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() => _value = 1),
                          child: Container(
                            height: 56,
                            width: 56,
                            color: _value == 1 ? Colors.grey : Colors.transparent,
                            child: Image.asset('assets/images/MasterC.png'),

                          ),
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 10,top: 10),
                    width: 300,
                    child:TextField
                      (decoration: InputDecoration(
                      border:  const OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),
                      ),
                      hintText: 'Name',
                    ),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 10,top: 10),
                    width: 300,
                    child:TextField
                      (decoration: InputDecoration(
                      border:  const OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),
                      ),
                      hintText: 'Card number',
                    ),
                    )
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 60,top: 10),
                        width: 80,
                        child:TextField
                          (decoration: InputDecoration(
                          border:  const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          hintText: 'CSV',
                        ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 25,top: 10),
                        width: 80,
                        child:TextField
                          (decoration: InputDecoration(
                          border:  const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          hintText: 'MM',
                        ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 25,top: 10),
                        width: 80,
                        child:TextField
                          (decoration: InputDecoration(
                          border:  const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          hintText: 'YY',
                        ),
                        )
                    )
                  ],
                ),

                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () => {},
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
                        "PAY",
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
              Container(
//                child:UserList(),
              ),


            ]
        )
    );
  }
}

