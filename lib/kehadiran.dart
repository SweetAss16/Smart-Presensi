import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpresensi_v2/dataservices.dart';
import 'package:smartpresensi_v2/main.dart';
import 'package:smartpresensi_v2/model.dart';


class DataKehadiran extends StatefulWidget {
  
  DataKehadiran({this.scheduleid,this.roomname,this.coursename,this.date,this.time}) : super();
 
  final String title = 'Data kehadiran';

  final String scheduleid ;
  final String roomname;
  final String coursename;
  final String date;
  final String time;

  @override
  _DataKehadiranState createState() => _DataKehadiranState();
}

class _DataKehadiranState extends State<DataKehadiran> {
  List<KehadiranModel> _kehadiran;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  String qrCodeResult = "Not Yet";
  String roomname,coursename,date,time;
 
  @override
  void initState() {
    super.initState();
    _kehadiran = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); //
    _getKehadiran();
  }
 
  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }
 
  _getKehadiran() {
    _showProgress('Loading Data Kehadiran...');
    KehadiranServices.getKehadiran(widget.scheduleid).then((kehadiran) {
      setState(() {
        _kehadiran = kehadiran;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${kehadiran.length}");

    });
  }

  _updateattend(code,scheduleid) {

    KehadiranServices.updateAttendant(code, scheduleid).then((result) {
      if ('success' == result) {
        Navigator.of(context).pop();
        _getKehadiran();
      }
    });
  }

  _scan() async {
    String codeSanner = await BarcodeScanner.scan();    //barcode scnner
    
    setState(() {
      qrCodeResult = codeSanner;
    });

    
    //pake dialog box
    //hosting
    var url = 'https://majalah-in.000webhostapp.com/flutter/flutter-code-box.php';
    
    /*
    //pake dialog box
    //ip rumah ivan
    var url = 'http://192.168.1.11/smart_presensi/flutter/flutter-code-box.php';
    */
    /*
    //pake dialog box
    //ip rumah ntep
    var url = 'http://192.168.100.135/smart_presensi/flutter/flutter-code-box.php';
    */

    // Store all data with Param Name.
    var data = {'code': qrCodeResult , 'scheduleid': widget.scheduleid};

     // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    
    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    
    if(message == "Mahasiswa Code doesn't exist"){
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
      );
    }
    else{
      //pake dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)
            ),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Text(message[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
                        SizedBox(height: 20,),
                        Text('NIM',style: TextStyle(fontSize: 10),),
                        Text(message[1],style: TextStyle(fontSize: 20),),
                        SizedBox(height: 15,),
                        Text('ROOM',style: TextStyle(fontSize: 10),),
                        Text(message[2],style: TextStyle(fontSize: 20),),
                        SizedBox(height: 15,),
                        Text('SEAT',style: TextStyle(fontSize: 10),),
                        Text(message[3],style: TextStyle(fontSize: 20),),
                        SizedBox(height: 15,),
                        Text('ATTENDANCE',style: TextStyle(fontSize: 10),),
                        Text(message[4],style: TextStyle(fontSize: 20),),
                        SizedBox(height: 20,),
                        RaisedButton(
                          onPressed: () {
                            _updateattend(qrCodeResult, widget.scheduleid);
                          },
                          color: Colors.redAccent,
                          child: Text('ATTEND', style: TextStyle(color: Colors.white),),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -60,
                  child: CircleAvatar(
                    
                    //hosting
                    backgroundImage: NetworkImage('https://majalah-in.000webhostapp.com/img/students_profile/'+message[1]+'.jpg'),
                    
                    /*
                    //ip rumah ivan
                    backgroundImage: NetworkImage('http://192.168.1.11/smart_presensi/img/students_profile/'+message[1]+'.jpg'),
                    */
                    /*
                    //ip rumah ntep
                    backgroundImage: NetworkImage('http://192.168.100.135/smart_presensi/img/students_profile/'+message[1]+'.jpg'),
                    */

                    backgroundColor: Colors.redAccent,
                    radius: 60,
                  )
                ),
              ],
            )
          );
        }
      );

    }
  }


  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('NIM'),
            ),
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('ATTENDANCE'),
            ),
            DataColumn(
              label: Text('SEAT'),
            ),
          ],
          rows: _kehadiran
              .map(
                (kehadiran) => DataRow(cells: [
                  DataCell(
                    Text(kehadiran.username),
                  ),
                  DataCell(
                    Text(kehadiran.name.toUpperCase()),
                  ),
                  DataCell(
                    Text(kehadiran.attendance.toUpperCase())
                  ),
                  DataCell(
                    Text(kehadiran.seat_number.toUpperCase()),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }


  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getKehadiran();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0,),
            Text(
              widget.roomname, 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0,),
            Text(
              widget.coursename, 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10.0,),
            Text(
              widget.date, 
              textAlign: TextAlign.center,
            ),
            Text(widget.time, textAlign: TextAlign.center,),
            SizedBox(height: 20.0,),
            FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () async {
                Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                "FINISH",
                style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red,width: 3.0),
              borderRadius: BorderRadius.circular(20.0)),
            ),
            SizedBox(height: 20.0,),
            Text(
              "Data Kehadiran",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scan();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}