import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'ScanQR.dart';
import '../History/ShowHistory.dart';



//Displays start point, end point, fare, distance and calculate fare according to distance
class EndPoint extends StatefulWidget{
  EndPoint(this.sPoint,this.startTime) : super();
  String sPoint;
  String startTime;

  @override
  _EndPoint createState() => _EndPoint();
}

class _EndPoint extends State <EndPoint>{

  //Initializing the variables
  int fDist = 0;
  int dist;
  int fCred = 0;

  var isLoading = false;
  var tot = 0;
  var currentCred;
  var element = "";
  var id = null;
  var allStands;
  var credits;
  var stands = [];
  var startDistance;
  var EndDistance;

  List busStands = List();
  List users = List();

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static final DateFormat timeFormatter = DateFormat.Hm();
  final String time = timeFormatter.format(now);
  final String formatted = formatter.format(now);

  // generates a new Random object
  final _random = new Random();

  BuildContext _context;


  //Initial state
  @override
  void initState() {
    onStart();
    _fetchBusStands();
    _fetchUser();
    getdata();
    print(widget.startTime +"  "+time);
    super.initState();
  }


  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }

  void onStart() async{
    await _fetchBusStands();
    await _fetchUser();
  }



  //Retrieve all users
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


  getdata() async{
    var user = await getUser();
    print(await getUser());
    setState(() {
      id =  user;
    });
  }


  //Retrieve all details of bus stands from the database
  void _fetchBusStands() async {
    setState(() {
      isLoading = true;
    });
    final response =  await http.get("http://10.0.2.2:8000/busStand/");
    if (response.statusCode == 200) {
      busStands = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Calculate Distance
  int getDistance() {
     busStands.map((item) => {
       print(item),
       if(item['busStand'] == widget.sPoint){
          startDistance = item['DistanceFromCol'],
           if(item['busStand'] == element){
             EndDistance = item['DistanceFromCol'],
            }
        }
     }
     );
     setState(){
       tot = startDistance - EndDistance;
     }
     print(startDistance);
      return tot;

  }




  Future<http.Response> EndJourney(int cred,int fare, String end,double distance) async {
    //Update user's credits after ending the journey
      String url =
          'http://10.0.2.2:8000/user/updateCredit/'+id;
      Map map = {
        'Credits': cred,
      };
      print(await apiRequest(url, map));



      //Updating user's history after ending the journey
      String historyURL =
      'http://10.0.2.2:8000/user/pushHistory';
      Map body = {
        '_id':id,
        'history':[{"Start":widget.sPoint,"End":end, "Fare": fare,"Distance":distance,"date":formatted,"startTime":widget.startTime,"endTime":time}],
      };

      print(await apiRequest(historyURL, body));
      _success(_context);

  }

  //Success pop up
  _success(context){
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => showHistory())
    );
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

    for(var i = 0 ; i < busStands.length;i++){
      if(busStands[i]['busStand'] != widget.sPoint)
       stands.add(busStands[i]['busStand']);
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
    else {
     allStands = stands[_random.nextInt(stands.length)];
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
    else {
      element = stands[_random.nextInt(stands.length)];
    }

    for(var i = 0 ; i < busStands.length;i++){
      if(busStands[i]['busStand'] == widget.sPoint) {
        startDistance = busStands[i]['DistanceFromCol'];
      }

        if(busStands[i]['busStand'] == element){
           EndDistance = busStands[i]['DistanceFromCol'];
        }
    }

    //Calculate total distance
    if(startDistance !=null  && EndDistance != null) {
       dist = startDistance - EndDistance;
    }

    if(dist != null) {
      if (dist < 0 && dist != 0) {
        fDist = 0 - dist;
      }
      else {
        fDist = dist;
      }
    }

    //Get Distance in KM
    double inKM = (fDist/10);
    for(var i = 0 ; i < users.length;i++){
      if(users[i]['_id'] == id)
        currentCred = users[i]['Credits'];

    }

    //Deduct credits from total credits of user
    if(currentCred !=null && fDist !=null){
      credits = currentCred - fDist;
    }

    if(credits != null){
        fCred = credits;
    }

    setState(() {
      _context = context;
    });


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


        ),
        body: Column(
            children: [
              Container(
                decoration: new BoxDecoration(
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
                    this.EndJourney(fCred,fDist,element,inKM)
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
            ]
        )
    );
  }
}

