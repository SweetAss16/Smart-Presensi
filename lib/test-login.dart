import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'test-home.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
     primarySwatch: Colors.red 
    ),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    )
  );


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
Widget build(BuildContext context) {
return MaterialApp(
  theme: ThemeData(
      primarySwatch: Colors.red
    ),
  debugShowCheckedModeBanner: false,
  home: Scaffold(
      appBar: AppBar(title: Text('Smart Presensi')),
      body: Center(
        child: LoginUser()
        )
      )
    );
}
}

class LoginUser extends StatefulWidget {

LoginUserState createState() => LoginUserState();

}

class LoginUserState extends State {

  // For CircularProgressIndicator.
  bool visible = false ;

  // Getting value from TextField widget.
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

Future userLogin() async{

  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });

  // Getting value from Controller
  String username = usernameController.text;
  String password = passwordController.text;

  // SERVER LOGIN API URL
  var url = 'http://10.0.2.2/smart_presensi/flutter/flutter-login.php';

  // Store all data with Param Name.
  var data = {'username': username, 'password' : password};

  // Starting Web API Call.
  var response = await http.post(url, body: json.encode(data));

  // Getting Server response into variable.
  var message = jsonDecode(response.body);

  // If the Response Message is Matched.
  if(message == 'Login Matched')
  {

    // Hiding the CircularProgressIndicator.
      setState(() {
      visible = false; 
      });

    // Navigate to Profile Screen & Sending username to Next Screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username : usernameController.text))
      );
  }else{

    // If username or Password did not Matched.
    // Hiding the CircularProgressIndicator.
    setState(() {
      visible = false; 
      });

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
return Scaffold(
  body: SingleChildScrollView(
    child: Center(
    child: Column(
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(top:100),
          child: Text('User Login Form', 
                  style: TextStyle(fontSize: 21))),

        Divider(),          

        Container(
        width: 280,
        padding: EdgeInsets.all(10.0),
        child: TextField(
            controller: usernameController,
            autocorrect: true,
            decoration: InputDecoration(hintText: 'Enter Your username Here'),
          )
        ),

        Container(
        width: 280,
        padding: EdgeInsets.all(10.0),
        child: TextField(
            controller: passwordController,
            autocorrect: true,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter Your Password Here'),
          )
        ),

        RaisedButton(
          onPressed: userLogin,
          color: Colors.green,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
          child: Text('Login'),
        ),

        Visibility(
          visible: visible, 
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: CircularProgressIndicator()
            )
          ),

      ],
    ),
  )));
}
}
