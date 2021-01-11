import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:smartpresensi_v2/test-scan.dart';

import 'test-login.dart';

class HomePage extends StatefulWidget {
  final String username;
  
  HomePage({this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final scheduleidController = TextEditingController();

  Future scanning() async{
    String scheduleid = scheduleidController.text;

    var url = 'http://10.0.2.2/smart_presensi/flutter/flutter-scanning.php';

    // Store all data with Param Name.
    var data = {'scheduleid': scheduleid};

     // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    if(message == 'Schedule Exist')
    {
      // Navigate to Profile Screen & Sending username to Next Screen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScanPage(scheduleid : scheduleidController.text))
        );
    }else{
      // Showing Alert Dialog with Response JSON Message.
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );}
  
  }
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red 
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Homepage"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
         
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/Logo-UNTAR.png',
                width: 200,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 40.0,
              ),

              Text(
                "Schedule id",
                style: TextStyle(fontSize: 20.0),
              ),

              TextField(
                controller: scheduleidController,
                decoration: InputDecoration(
                hintText: "Input Schedule id",
                ),

              ),

              SizedBox(height: 20.0,),
              flatButton(
                "Scan QR CODE"
              ),
              SizedBox(height: 20.0,),
              flatButton2("LOGOUT", MyApp()),
            ],
          ),
        ),
      )
    );
  }

  Widget flatButton(String text) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: scanning,
      child: Text(
        text,
        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red,width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Widget flatButton2(String text, Widget widget) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: () async {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red,width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }

}
