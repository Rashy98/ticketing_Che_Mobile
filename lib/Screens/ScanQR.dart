import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import 'StartPoint.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class ScanQR extends StatefulWidget {

  @override
  _ScanQR createState() => _ScanQR();
}
class _ScanQR extends State<ScanQR>{

  String _base64;
  List users = List();
  var isLoading = true;
  var id = null;
  Uint8List bytes ;

  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }


  @override
  void initState() {
    _fetchData();

    getdata();
    getBase64();
    super.initState();
//    setState(() {
//      _base64 = "data:image/png;base64,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";
//    });
  }

//  ScanQR({Key key, @required this.sPoint,this.main,this.button}) : super(key: key);
  void _fetchData() async {


    final response = await http.get("http://10.0.2.2:8000/user/");
    if (response.statusCode == 200) {
      users = json.decode(response.body) as List;
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  getBase64() {
    for (var x = 0; x < users.length; x++) {
      if (id != null) {
        if (users[x]['_id'] == id) {
          print(users[x]['generatedQR']);
          setState(() {
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

  getdata() async{
    var user = await getUser();
    print(await getUser());
   setState(() {
      id =  user;
   });
  }
  @override
  Widget build(BuildContext context) {

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

    // TODO: implement build
    return Scaffold(
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
//                        border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                            boxShadow: [
//                          BoxShadow(color:  Colors.red)
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
              Navigator.of(context).pop(),
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => StartPointC())
              )},
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
    );
  }



}