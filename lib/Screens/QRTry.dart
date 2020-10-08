import 'package:flutter/material.dart';


class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePages(),
    );
  }
}

class MyHomePages extends StatefulWidget {
  @override
  _MyHomePageStates createState() => _MyHomePageStates();
}

class _MyHomePageStates extends State<MyHomePages> {
  bool isPressed = false;
  var data;
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("QR Code Generator"),
      ),
      floatingActionButton: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        color: Colors.purple[300],
        child: Text("Generate QR"),
        onPressed: () {
          setState(() {
            data = _controller.text;
            isPressed = true;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
          child: Column(children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple[300]),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: "Enter the Data to generate QR code (eg. url)"),
                )),
            isPressed
                ? Image.network(
              "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$data",
            )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            isPressed
                ? Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 30,
                      ),
                      Text(
                        "QR Generated..!",
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                Text(
                  "Take a ScreenShot and Share it..😜",
                  style: TextStyle(fontSize: 20),
                )
              ],
            )
                : SizedBox()
          ])),
    );
  }
}