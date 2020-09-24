import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/FinishScan.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import 'dart:async';
import "dart:math";
import 'package:http/http.dart' as http;


class showHistory extends StatefulWidget{
  @override
  _showHistory createState() => _showHistory();
}


class _showHistory extends State<showHistory> {

  @override
  void initState() {
    onStart();
    _fetchData();
    getData();
//    fetchUserHistory();
    super.initState();
  }


  List lists = List();
  var isLoading = true;

  var element = "";

  String _name(dynamic user){
    return user['Start'];

  }

  void onStart() async{
    await _fetchData();
//    await fetchUserHistory();
  }

  final String apiUrl = "http://10.0.2.2:8000/user/";
  Future<List<dynamic>> fetchUserHistory() async {

    var result = await http.get(apiUrl);
    return json.decode(result.body)['history'];

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


  List stands = List();

// generates a new Random object
  final _random = new Random();
  List data;
  List users = List();

// generate a random index based on the list length
// and use it to retrieve the element

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://10.0.2.2:8000/user/"),
        headers: {
          "Accept": "application/json"
        }
    );

    users = json.decode(response.body) as List;
    this.setState(() {
      data = json.decode(response.body);
    });

    print(data[0]["history"]);

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    for(var i = 0 ; i < users.length;i++){
        stands.add(users[i]['history']);
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
    else {
      print("object");
      print(stands);
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
                              child: Text('History', style: TextStyle(
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
//              new ListView.builder(
//                itemCount: stands == null ? 0 : stands.length,
//                itemBuilder: (BuildContext context, int index) {
//            new Card(
//                          child: Column(
//                          children: <Widget>[
//                          ListTile(
//                          title: Text(stands[2]["Start"] + " - " +
//                              stands[2]["End"]),
//                          subtitle: Text("LKR. " +
//                              stands[2]["Fare"].toString() + ".00"),
//                          )
//                          ],
//                          ),
//                          ),
//
////              ),

              new  Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(data[0]["history"][1]["Start"] + " - " +
                          data[0]["history"][1]["End"]),
                      subtitle: Text("LKR. " +
                          data[0]["history"][1]["Fare"].toString() + ".00"),
                    )
                  ],
                ),
              ),
//                }
//     ),

//              new ListView.builder(
//                itemCount: data == null ? 0 : data.length,
//                itemBuilder: (BuildContext context, int index){
//                  return new Card(
//                    child: new Text(data[0]["history"]),
//                  );
//                },),
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


            ]
        )
    );
  }
}



