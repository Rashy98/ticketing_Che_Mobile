import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Screens/Common/NavDrawer.dart';
import 'StartPoint.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../Topup/TopUp.dart';


//Class to start a journey by scanning the QR
class ScanQR extends StatefulWidget {

  @override
  _ScanQR createState() => _ScanQR();

}

class _ScanQR extends State<ScanQR>{

//  initializing variables
  String _base64;
  List users = List();
  var isLoading = true;
  var id = null;
  Uint8List bytes ;
  var credits;


  //initial state
  @override
  void initState(){
    getdata();
    getBase64();
    _fetchUsers();
    super.initState();
  }


  //Get user token from the logged in user
  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }


  //Get all users from the database to a variable users
  void _fetchUsers() async {

    final response = await http.get("http://10.0.2.2:8000/user/");
    if (response.statusCode == 200) {
      users = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    }
//    else {
//      throw Exception('Failed to load data');
//    }
  }

  //Get userid according to the logged in user
  getdata() async{
    var user = await getUser();
    print(await getUser());
    setState(() {
      id =  user;
    });
  }

  //Get QR code according to the user
  getBase64() {
    for (var x = 0; x < users.length; x++) {
      if (id != null) {
        if (users[x]['_id'] == id) {
          print(users[x]['generatedQR']);
          setState(() {
            credits  = users[x]['Credits'];
            _base64 = users[x]['generatedQR'].toString();
            bytes = Base64Codec().decode(_base64.substring(22));
          });
          break;
        }
      }
      else{
        print("else");
      }
    }
  }

  //Displays the popup when credits aren't enough to proceed
  _DisplayPop(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height:220,
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
                            child:Text('ALERT',style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,)
                        )
                    ),

                    Container(
                        margin: EdgeInsets.only(left: 40,top: 30),
                        child:
                        Text("No enough Credits in your account. Please recharge your account ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold))),

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

  //Display success popup
  _success(BuildContext context) async{
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TopUp())
    );
  }


  //Main Widget
  @override
  Widget build(BuildContext context) {



    //convert base64 to bytes to display the QR as an image
    if (_base64 != null) {
      setState(() {
        bytes = Base64Codec().decode(_base64.substring(22));
      });
      print("bytes in" + bytes.toString());
    }
    else if(_base64 == null)
      {
        getBase64();
      }

    return
      new MediaQuery(
        data: new MediaQueryData(),
      child:MaterialApp(
        home:Scaffold(
      drawer: NavDrawer(),
      appBar:AppBar(
              flexibleSpace: Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromARGB(255, 182,82,80),
                Color.fromARGB(255, 115,71,108),
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
                      Color.fromARGB(255, 182,82,80),
                      Color.fromARGB(255, 115,71,108),
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
                            boxShadow: [
                            ]
                        ),
                        child:Center(
                            child:Text('Scan To Start   Journey',style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)
                        )
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(
            height: 50,
          ),
            Text('Scan & Start',style:TextStyle(color: Colors.black54,fontSize: 30)),
          SizedBox(
            height: 20,
          ),
            bytes == null ?CircularProgressIndicator():Image.memory(bytes,fit: BoxFit.cover,) ,
          Container(
            height: 50.0,
            child: RaisedButton(
              onPressed: () => {
                if(credits >=60){
              Navigator.of(context).pop(),
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => StartPointC()))
              }
                else{
                  _DisplayPop(context)
              }},
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color.fromARGB(255, 182,82,80),    Color.fromARGB(255, 115,71,108)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
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
    )
    )
      );
  }


}