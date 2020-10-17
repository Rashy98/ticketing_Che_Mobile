import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Screens/Journey/FinishScan.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


//Displays the Start point and gives the option to get directed to the interface to end the journey
class StartPointC extends StatefulWidget{
  @override
  _StartPoint createState() => _StartPoint();
}


class _StartPoint extends State<StartPointC> {
  // initializing variables
  List busStands = List();
  var isLoading = true;
  var element = "";
  var stands = [];


// generates a new Random object
  final _random = new Random();

  static final DateTime now = DateTime.now();
  static final DateFormat timeFormatter = DateFormat.Hm();
  final String time = timeFormatter.format(now);
  final String apiUrl = "http://localhost:8000/busStand/";

  //Initial state
  @override
  void initState() {
    onStart();
    _fetchBusStands();
    print(time);
    super.initState();
  }


  //Get user token from the logged in user
  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;
    String userId = sharedPreferences.getString('token');
    return userId;
  }


  void onStart() async{
    await _fetchBusStands();
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['busStand'];

  }

  //Retrieve all bus stands from database
  void _fetchBusStands() async {

    final response =  await http.get("http://10.0.2.2:8000/busStand/");
    if (response.statusCode == 200) {
      busStands = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    }
//    else {
//      throw Exception('Failed to load data');
//    }
  }




// generate a random index based on the list length
// and use it to retrieve the element


  @override
  Widget build(BuildContext context) {

    //Get all bus stands to a array
    for(var i = 0 ; i < busStands.length;i++){
      stands.add(busStands[i]['busStand']);
    }

    if(stands.length == 0){
      setState(() {
        isLoading:true;
      });
    }
    else {
      //get a random bus start to start the journey
      element = stands[_random.nextInt(stands.length)];
    }


    // TODO: implement build
    return
      MaterialApp(
        home:Scaffold(
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
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
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
                height: 150,
              ),
              isLoading ?
              Center(child: CircularProgressIndicator()) :
              Text('Starting point : '+ element,
                  style: TextStyle(color: Colors.black54, fontSize: 30))
                  ,
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () async => {
                    print(await getUser()),
                    Navigator.of(context).pop(),
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FinishScan(element,time))

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
    )
      );
  }
}

