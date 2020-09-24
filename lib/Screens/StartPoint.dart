import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/FinishScan.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;


class StartPointC extends StatefulWidget{
  @override
  _StartPoint createState() => _StartPoint();
}


class _StartPoint extends State<StartPointC> {

  @override
  void initState() {
    onStart();
    _fetchData();
    super.initState();
  }


  List lists = List();
  var isLoading = true;

  var element = "";

  getCount(){

  }

  void onStart() async{
    await _fetchData();
  }

  final String apiUrl = "http://localhost:8000/busStand/";
  Future<List<dynamic>> fetchUsers() async {

    var result = await http.get(apiUrl);
    return json.decode(result.body)['busStand'];

  }

  void _fetchData() async {
//    getCount();

    final response =  await http.get("http://10.0.2.2:8000/busStand/");
    if (response.statusCode == 200) {
      lists = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  var stands = [];
  
// generates a new Random object
  final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element


  @override
  Widget build(BuildContext context) {
    for(var i = 0 ; i < lists.length;i++){
      stands.add(lists[i]['busStand']);
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
else {
      element = stands[_random.nextInt(stands.length)];
    }


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
                              child: Text('Journey Started!', style: TextStyle(
                                  color: Colors.white, fontSize: 40),
                                textAlign: TextAlign.center,)
                          )
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              isLoading ?
              Center(child: CircularProgressIndicator()) :
              Text('Starting point : '+ element,
                  style: TextStyle(color: Colors.black54, fontSize: 30))
                  ,
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FinishScan(sPoint:element))

                    )},
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
                          maxWidth: 350.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Scan to Finish journey",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26
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

