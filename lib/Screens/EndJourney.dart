import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_app/Screens/FinishScan.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;


class EndPointC extends StatefulWidget{
  EndPointC(this.sPoint) : super();
  String sPoint;

  @override
  _EndPoint createState() => _EndPoint();
}


class _EndPoint extends State <EndPointC>{

  @override
  void initState() {
    onStart();
    _fetchData();
    _fetchUser();
    super.initState();
  }

  int fDist = 0;
  int dist;
  int fCred = 0;

  List lists = List();
  List users = List();
  var isLoading = false;
  var tot = 0;
  var currentCred;

  var element = "";

  getCount(){

  }

  void onStart() async{
    await _fetchData();
    await _fetchUser();
  }



  void _fetchUser() async{
    final response =  await http.get("http://10.0.2.2:8000/user/");
    if (response.statusCode == 200) {
      users = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  void _fetchData() async {
//    getCount();
    setState(() {
      isLoading = true;
    });
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
  var startDis;
  var EndDis;

  int getDistance() {
     lists.map((item) =>
     {
       print(item),
       if(item['busStand'] == widget.sPoint){
          startDis = item['DistanceFromCol'],
           if(item['busStand'] == element){
             EndDis = item['DistanceFromCol'],
         }
       }
     }
     );
     setState(){
       tot = startDis - EndDis;
     }
     print(startDis);
      return tot;

  }

  int getCredits(){

  }

  var stands = [];

// generates a new Random object
  final _random = new Random();

  var x;
  var credits;

// generate a random index based on the list length
// and use it to retrieve the element


//  void EndJourney() async{
//
//
//    final response =  await http.post("http://10.0.2.2:8000/user/5f6754a91cc10b4a5c380ba7",fDist);
//  }

  Future<http.Response> EndJourney(int cred,int fare, String end) async {
      String url =
          'http://10.0.2.2:8000/user/updateCredit/5f6754a91cc10b4a5c380ba7';
      Map map = {
        'Credits': cred,
      };
      print(await apiRequest(url, map));



      String HisURL =
      'http://10.0.2.2:8000/user/pushHistory';
      Map body = {
        '_id':'5f6754a91cc10b4a5c380ba7',
        'history':[{"Start":widget.sPoint,"End":end, "Fare": fare}],
      };
      print(await apiRequest(HisURL, body));
  }


  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    for(var i = 0 ; i < lists.length;i++){
      if(lists[i]['busStand'] != widget.sPoint)
       stands.add(lists[i]['busStand']);
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
    else {
     x = stands[_random.nextInt(stands.length)];
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
    else {
      element = stands[_random.nextInt(stands.length)];
    }


    for(var i = 0 ; i < lists.length;i++){
      if(lists[i]['busStand'] == widget.sPoint) {
        startDis = lists[i]['DistanceFromCol'];
      }

        if(lists[i]['busStand'] == element){
           EndDis = lists[i]['DistanceFromCol'];
        }
    }



    if(startDis !=null  && EndDis != null) {
       dist = startDis - EndDis;
    }

    if(dist != null) {
      if (dist < 0 && dist != 0) {
        fDist = 0 - dist;
      }
      else {
        fDist = dist;
      }
    }
    double inKM = (fDist/10);

    for(var i = 0 ; i < users.length;i++){
      if(users[i]['_id'] == "5f6754a91cc10b4a5c380ba7")
        currentCred = users[i]['Credits'];

    }
    if(currentCred !=null && fDist !=null){
      credits = currentCred - fDist;
    }

    if(credits != null){
        fCred = credits;
    }

    print(fCred);

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
                              child: Text('Journey Ended!', style: TextStyle(
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
              Text('Starting point : '+ widget.sPoint,
                  style: TextStyle(color: Colors.black54, fontSize: 30))
              ,
              Text('Ending point : '+ element,
                  style: TextStyle(color: Colors.black54, fontSize: 30))
              ,
              Text('Distance : '+ inKM.toString() +' KM',
                  style: TextStyle(color: Colors.black54, fontSize: 30))
              , Text('Fare : LKR. '+ fDist.toString(),
                  style: TextStyle(color: Colors.black54, fontSize: 30))
              ,
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50.0,

                child:
                RaisedButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    this.EndJourney(fCred,fDist,element)
                  },
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
                        "OK",
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

