import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_app/Widget/NavDrawer.dart';
import 'EndJourney.dart';
import 'package:http/http.dart' as http;
import 'StartPoint.dart';

class FinishScan extends StatefulWidget{
  FinishScan(this.sPoint,this.startTime) : super();
  String sPoint;
  String startTime;
  @override
  _FinishScan createState() => _FinishScan();

}
class _FinishScan extends State<FinishScan>{
  String _base64;
  List users = List();
  var id = null;
  Uint8List bytes ;
  var isLoading = true;

  @override
  void initState() {
    _fetchData();
  getdata();
  getBase64();
    super.initState();
  }


  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    return userId;
  }
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
                              child:Text('Scan To End     Journey',style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,)
                          )
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text('Scan & End',style:TextStyle(color: Colors.black54,fontSize: 30)),
              Text('Starting point : ' +widget.sPoint,style:TextStyle(color: Colors.black54,fontSize: 30)),

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
                        context, MaterialPageRoute(builder: (context) => EndPointC(widget.sPoint,widget.startTime))
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
                      constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "End Journey",
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