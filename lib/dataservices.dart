import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:smartpresensi_v2/model.dart';
 
class KehadiranServices {
  
  //IP Address hosting
 static const ROOT = 'https://majalah-in.000webhostapp.com/flutter/flutter-data.php';
  
  /*
  //IP rumah ivan
  static const ROOT = 'http://192.168.1.11/smart_presensi/flutter/flutter-data.php';
  */
  /*
  //IP rumah ntep
  static const ROOT = 'http://192.168.100.135/smart_presensi/flutter/flutter-data.php';
  */
  /*
  //IP Address dirumah ivan
  static const ROOT = 'http://192.168.1.2/smart_presensi/flutter/flutter-data.php';
  */

  //static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _GET_BY_ID = 'GET_BY_ID';
  //static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_ATT_ACTION = 'UPDATE_ATT';
  //static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  //static const _DELETE_EMP_ACTION = 'DELETE_EMP';


  //GET ALL
  static Future<List<KehadiranModel>> getKehadiran(String scheduleid) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['scheduleid'] = scheduleid;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<KehadiranModel> list = parseResponse(response.body);
        return list;
      } else {
        return List<KehadiranModel>();
      }
    } catch (e) {
      return List<KehadiranModel>(); // return an empty list on exception/error
    }
  }
/*
  //GET BY HASH
  static Future<KehadiranModel> getMahasiswa(String code, String scheduleid) async{
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_BY_ID;
      map['code'] = code;
      map['scheduleid'] = scheduleid;
      final response = await http.post(ROOT, body: map);
      print('getMahasiswa Response: ${response.body}');
      if (200 == response.statusCode) {
        //return KehadiranModel.fromJson(json.decode(response.body));
        KehadiranModel list = KehadiranModel.fromJson(json.decode(response.body));
        //KehadiranModel list = parseResponsemodel(response.body);
        return list;
      } else {
        return KehadiranModel();
      }
    } catch (e) {
      return KehadiranModel(); // return an empty list on exception/error
    }
  }
*/

  //GET BY HASH
  static Future<List<KehadiranModel>> getMahasiswa(String code,String scheduleid) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_BY_ID;
      map['code'] = code;
      map['scheduleid'] = scheduleid;
      final response = await http.post(ROOT, body: map);
      print('getMahasiswa Response: ${response.body}');
      if (200 == response.statusCode) {
        List<KehadiranModel> list = parseResponse(response.body);
        return list;
      } else {
        return List<KehadiranModel>();
      }
    } catch (e) {
      return List<KehadiranModel>(); // return an empty list on exception/error
    }
  }

 
  static List<KehadiranModel> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<KehadiranModel>((json) => KehadiranModel.fromJson(json)).toList();
  }

  static KehadiranModel parseResponsemodel(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<KehadiranModel>((json) => KehadiranModel.fromJson(json))();
  }

  //update attendance
  static Future<String> updateAttendant(String code, String scheduleid) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_ATT_ACTION;
      map['code'] = code;
      map['scheduleid'] = scheduleid;
      final response = await http.post(ROOT, body: map);
      print('updateAttendant Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }


  // Method to add employee to the database...
/*
  static Future<String> addEmployee(String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
*/


  // Method to update an Employee in Database...
/*
  static Future<String> updateEmployee(
      String empId, String firstName, String lastName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['first_name'] = firstName;
      map['last_name'] = lastName;
      final response = await http.post(ROOT, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
*/


  // Method to Delete an Employee from Database...
/*
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
*/


}