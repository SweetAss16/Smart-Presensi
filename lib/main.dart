import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'mainmenu.dart';

void main() {
 runApp(MaterialApp(
   theme: ThemeData(
      primarySwatch: Colors.red
    ),
   debugShowCheckedModeBanner: false,
   home: Login(),
 ));
}

class Login extends StatefulWidget {
 @override
 _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
 LoginStatus _loginStatus = LoginStatus.notSignIn;
 String username, password;
 final _key = new GlobalKey<FormState>();

 bool _secureText = true;

 showHide() {
   setState(() {
     _secureText = !_secureText;
   });
 }

 check() {
   final form = _key.currentState;
   if (form.validate()) {
     form.save();
     login();
   }
 }

 login() async {
    
    //hosting
    final response = await http.post("https://majalah-in.000webhostapp.com/flutter/flutter-login.php",
       body: {"username": username, "password": password});
    
    /*
    //ip rumah ivan
    final response = await http.post("http://192.168.1.11/smart_presensi/flutter/flutter-login.php",
       body: {"username": username, "password": password});
    */
    /*
    //ip rumah ntep
    final response = await http.post("http://192.168.100.135/smart_presensi/flutter/flutter-login.php",
       body: {"username": username, "password": password});
    */
   final data = jsonDecode(response.body);
   int value = data['value'];
   String pesan = data['message'];
   String usernameAPI = data['username'];
   String nameAPI = data['name'];

   if (value == 1) {
     setState(() {
       _loginStatus = LoginStatus.signIn;
       savePref(value, usernameAPI, nameAPI );
     });
     print(pesan);
   } else {
     print(pesan);
   }
 }

 savePref(int value, String username, String name ) async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     preferences.setInt("value", value);
     preferences.setString("username", username);
     preferences.setString("name", name);
     //preferences.commit();
   });
 }

 var value;
 getPref() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     value = preferences.getInt("value");

     _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
   });
 }

 signOut() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     preferences.setInt("value", null);
     //preferences.commit();
     _loginStatus = LoginStatus.notSignIn;
   });
 }

 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   getPref();
 }

 @override
 Widget build(BuildContext context) {
   switch (_loginStatus) {
     case LoginStatus.notSignIn:
       return Scaffold(
         appBar: AppBar(
           title: Text("Login"),
         ),
         body: Form(
           key: _key,
           child: ListView(
             padding: EdgeInsets.all(16.0),
             children: <Widget>[
               SizedBox(
                height: 40.0,
              ),
               Image.asset(
                'assets/images/Logo-UNTAR.png',
                width: 200,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 40.0,
              ),
               TextFormField(
                 validator: (e) {
                   if (e.isEmpty) {
                     return "Please insert username";
                   }
                 },
                 onSaved: (e) => username = e,
                 decoration: InputDecoration(
                   labelText: "username",
                 ),
               ),
               TextFormField(
                 obscureText: _secureText,
                 onSaved: (e) => password = e,
                 decoration: InputDecoration(
                   labelText: "Password",
                   suffixIcon: IconButton(
                     onPressed: showHide,
                     icon: Icon(_secureText
                         ? Icons.visibility_off
                         : Icons.visibility),
                   ),
                 ),
               ),
               SizedBox(
                height: 40.0,
              ),
               MaterialButton(
                 onPressed: () {
                   check();
                 },
                 child: Text("Login"),
               ),
               
             ],
           ),
         ),
       );
       break;
     case LoginStatus.signIn:
       return MainMenu(signOut);
       break;
   }
 }
}
