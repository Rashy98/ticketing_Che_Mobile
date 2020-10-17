import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import 'dart:async';
import "dart:math";
import 'package:http/http.dart' as http;



//Display History according to the user
class showHistory extends StatefulWidget{
  @override
  _showHistory createState() => _showHistory();
}


class _showHistory extends State<showHistory> {

  //Initializing variables
  var isLoading = true;
  var element = "";
  var id = null;

  List users = List();
  List lists = List();
  List stands = List();
  List<Widget> listArray = [];
  List data;

  final String apiUrl = "http://10.0.2.2:8000/user/";



  //Initial state
  @override
  void initState() {
    _fetchData();
    getdata();
    getData();
    super.initState();
  }


//Get user token from the logged in user
  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }



  getdata() async{
    var user = await getUser();
    print(await getUser());
    setState(() {
      id =  user;
    });
  }

  String _name(dynamic user){
    return user['Start'];

  }


  //Get history according to the user
  Future<List<dynamic>> fetchUserHistory() async {

    var result = await http.get(apiUrl);
    return json.decode(result.body)['history'];

  }


  void _fetchData() async {

    final response = await http.get("http://10.0.2.2:8000/busStand/");
    if (response.statusCode == 200) {
      lists = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Retrieve all users
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

    return "Success!";
  }
  //Return history as list items
   _returnHistory(){
    if(users.length != 0 && users.length != null) {
      print("users:" + users.length.toString());
      for (var x = 0; x <= users.length; x++) {
        if (users[x]['_id'] == id) {
          for (var y = 0; y < users[x]['history'].length; y++) {
            if( users[x]['history'][y] == null) {
                    y++;
            }
            else{
              print("history : " + y.toString() + " -->" +
                  users[x]['history'][y].toString());
              listArray.add(new ListTile(
                title: Text(users[x]["history"][y]["Start"] + " - " +
                    users[x]["history"][y]["End"]),
                subtitle: Text(users[x]["history"][y]["Distance"].toString()+"Km"+" - LKR. " +
                    users[x]["history"][y]["Fare"].toString() + ".00"),
                trailing:Icon(Icons.check_circle,
                    color: Color.fromARGB(255, 182, 82, 80)),
              ));
            }
          }
          break;
        }
      }
      setState(() {
        isLoading = false;
      });
          }
        }



  @override
  Widget build(BuildContext context) {

    _returnHistory();
      // TODO: implement build
    return MaterialApp(
        home :Scaffold(
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
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                   Card(
                          child: Column(
                            children: isLoading? [CircularProgressIndicator()]:listArray
                      ),
                      ),

                    SizedBox(
                      height: 20,
                    ),
                    ]
                )
            )
        )
    )
    );
  }
}



