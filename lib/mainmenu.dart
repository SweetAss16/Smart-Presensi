import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpresensi_v2/kehadiran.dart';

// class _RegisterState extends State<Register> {

class MainMenu extends StatefulWidget {
 final VoidCallback signOut;
 MainMenu(this.signOut);
 @override
 _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
 signOut() {
   setState(() {
     widget.signOut();
   });
 }

  String username = "";
  String name = "";
  final scheduleidController = TextEditingController();

  //TabController tabController;

 getPref() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
      username = preferences.getString("username");
      name = preferences.getString("name");
   });
 }

 @override
 void initState() {
   super.initState();
   getPref();
 }

 Future scanning() async{
    String scheduleid = scheduleidController.text;
    
    //hosting
    var url = 'https://majalah-in.000webhostapp.com/flutter/flutter-scanning.php';
    
    /*
    //ip rumah ivan
    var url = 'http://192.168.1.11/smart_presensi/flutter/flutter-scanning.php';
    */
    /*
    //ip rumah ntep
    var url = 'http://192.168.100.135/smart_presensi/flutter/flutter-scanning.php';
    */

    // Store all data with Param Name.
    var data = {'scheduleid': scheduleid};

     // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    if(message == 'Schedule Exist')
    { 
      
      //hosting
      //GET COURSE DETAIL
      var url1 = 'https://majalah-in.000webhostapp.com/flutter/flutter-course.php'; 
      
      /*
      //ip rumah ntep
      //GET COURSE DETAIL
      var url1 = 'http://192.168.100.135/smart_presensi/flutter/flutter-course.php'; 
      */

      // Store all data with Param Name.
      var data1 = {'scheduleid': scheduleidController.text};

      // Starting Web API Call.
      var response = await http.post(url1, body: json.encode(data1));
        
      // Getting Server response into variable.
      var message1 = jsonDecode(response.body);

      if(message1 == "Data Course doesn't exist"){
        // Showing Alert Dialog with Response JSON Message.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(message1),
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
        );
      }
      else{
        // Navigate to Profile Screen & Sending username to Next Screen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DataKehadiran(
            scheduleid : scheduleidController.text,
            roomname : message1[0],
            coursename : message1[1],
            date : message1[2],
            time : message1[3],
            )
          )
        );
      }
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
   return DefaultTabController(
     length: 4,
     child: Scaffold(
       appBar: AppBar(
         title: Text("Dashboard"),
         actions: <Widget>[
           IconButton(
             onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      height: 320,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            "Help",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Cara Penggunaan :"),
                                  SizedBox(height: 10,),
                                  Text("1. Masukkan Schedule id yang telah diberikan administrator"),
                                  SizedBox(height: 10,),
                                  Text("2. Klik icon camera di pojok kanan bawah"),
                                  SizedBox(height: 10,),
                                  Text("3. Periksa data mahasiswa"),
                                  SizedBox(height: 10,),
                                  Text("4. Jika sudah benar, dapat mengklik tombol 'ATTEND' "),
                                  SizedBox(height: 10,),
                                  Text("5. Jika tidak benar, silahkan klik diluar kotak data mahasiswa untuk membatalkan"),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    child: Text(
                                      "OK, SAYA MENGERTI",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
             },
             icon: Icon(Icons.help),
           ),
           IconButton(
             onPressed: () {
               signOut();
             },
             icon: Icon(Icons.power_settings_new),
           )
         ],
        
       ),
       body:SingleChildScrollView(
         
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "WELCOME , "+name,
                style: TextStyle(fontSize: 20.0),
              ),
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
                height: 45,
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
              SizedBox(height: 30.0,),
              flatButton(
                "NEXT"
              ),
            ],
          ),
        ),
     ),
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

}