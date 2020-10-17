import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Screens/Journey/FinishScan.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import "dart:math";
import 'package:http/http.dart' as http;

import '../Journey/ScanQR.dart';


class TopUp extends StatefulWidget{
  @override
  _TopUP createState() => _TopUP();
}


class _TopUP extends State<TopUp> {

  @override
  void initState() {
    _getUsersCredits();
    getdata();
    super.initState();
  }

  int _value = 0;
  List users = List();
  var currentCred = 0 ;
  var credits = 0;
  var id = null;

  final AmountController = TextEditingController();
  final YearController = TextEditingController();
  final nameController = TextEditingController();
  final cardNoController = TextEditingController();
  final csvController = TextEditingController();
  final monthController = TextEditingController();
  var enteredAmount = 0;


  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }

  _displayDialogBoxSec(BuildContext context) async {
    onClickUpdate(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height:200,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 60,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color.fromARGB(255, 115, 71, 108)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(color: Color.fromARGB(255, 115, 71, 108))
                            ]
                        ),
                        child:Center(
                            child:Text('Top up account',style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,)
                        )
                    ),

                    Container(
                        margin: EdgeInsets.only(left: 40,top: 30),
                        child:
                        Text("Rs. "+ AmountController.text+ " is added to the account!",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold))),

                    Container(
                        margin: EdgeInsets.only(left: 90,top: 20),
                        child: ButtonBar(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 130,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(color:  Color.fromARGB(255, 182, 82, 80)),
                                ),
                                color:  Color.fromARGB(255, 182, 82, 80),
                                textColor: Colors.white,
                                child: new Text('OK'),
                                onPressed: ()=>_success(context),
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _success(BuildContext context) {
    Navigator.pop(context);
    onClickUpdate(context);
    _ResetButton(context);
  }

  void _ResetButton(BuildContext context){
    setState(() {
      AmountController.text="";
       YearController.text="";
      nameController.text="";
      cardNoController.text="";
       csvController.text="";
      monthController.text="";

    });
  }
  onClickUpdate(BuildContext context) {
    enteredAmount = int.parse(AmountController.text);
    if(enteredAmount != null && currentCred != 0){
      credits = currentCred + enteredAmount;
      if(credits != 0 ){
        _TopUPAccount(credits,context);
      }
    }

  }
  void _getUsersCredits() async{
    final response =  await http.get("http://10.0.2.2:8000/user/");
    if (response.statusCode == 200) {
      users = json.decode(response.body) as List;
      }
//    else {
//      throw Exception('Failed to load data');
//    }
  }

  void _getCred(){
    if(users.length !=0){
      for(var i = 0 ; i < users.length;i++){
        if(users[i]['_id'] == id) {
          print(users[i]['history']);
          currentCred = users[i]['Credits'];
        }
      }
    }
  }

  getdata() async{
    var user = await getUser();
    print(await getUser());
    setState(() {
      id =  user;
    });
  }


  Future<http.Response> _TopUPAccount(int cred,BuildContext context) async {
    String url =
        'http://10.0.2.2:8000/user/updateCredit/' + id;
    Map map = {
      'Credits': cred,
    };

    print(await apiRequest(url, map));
    if (await apiRequest(url, map) == "Credits updated") {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScanQR())
      );
    }
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
    _getCred();
    if(currentCred != 0 ){
      print(currentCred);


    }

    // TODO: implement build
    return
      new MediaQuery(
          data: new MediaQueryData(),
          child:MaterialApp(
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

//        title: Text('TicketingApp'),

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
                    (
                    controller: AmountController,
                    decoration: InputDecoration(
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
                      (controller: nameController,
                      decoration: InputDecoration(
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
                      (controller: cardNoController,
                      decoration: InputDecoration(
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
                          (controller: csvController,
                          decoration: InputDecoration(
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
                          (controller: monthController,
                          decoration: InputDecoration(
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
                          (controller: YearController,
                          decoration: InputDecoration(
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
                  onPressed: ()=>_displayDialogBoxSec(context),
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
    )
    )
    )
          )
      );
  }
}

