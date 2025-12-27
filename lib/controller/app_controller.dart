import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';

class AppController {
  static Future<int> getWhoisLoggedIn() async {
    var instance = await SharedPreferences.getInstance();
    int? stffid = instance.getInt('login');
    return stffid ?? -1;
  }

  Future<void> setDirectedLoggedIn() async {
    var instance = await SharedPreferences.getInstance();
    await instance.setBool('directedLoggedIn', true);
  }

  Future<bool?> isDirectedLoggedIn() async {
    var instance = await SharedPreferences.getInstance();
    return await instance.getBool('directedLoggedIn');
  }

  static Future<void> setWhoIsLoggedIn(int stf_id) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('login', stf_id);
  }

  static Future<void> dire() async {
    var instance = await SharedPreferences.getInstance();

    if (instance.containsKey('directorPassword')) {
      return;
    }
    // cyber security issue
    await instance.setString(
      'directorPassword',
      "786",
    ); // will be stores in hash
  }

  Future<String?> getDirectorPassowrd() async {
    var instance = await SharedPreferences.getInstance();
    if (instance.containsKey('directorPassword'))
      return instance.getString('directorPassword');
    return null;
  }

  static Future<int> getAvailableStaffId() async {
    var instance = DBHelper.instance;
    var minStaffList = await instance.getMinStaffId();
    // print(minStaffList[0]['ms']);
    if (minStaffList[0]['ms'] == null) {
      return 1;
    }
    return minStaffList[0]['ms'] + 1;
  }

  static String getGenderChar(String gender,bool flag) {
    gender = gender.toLowerCase();
    // print(gender);
    if (gender.compareTo('male') == 0)
      return flag?'m':"M";
    else if (gender.compareTo('female') == 0)
      return flag?'f':"F";
    return flag?'o':" ";
  }

  static String getMartialStausChar(String status) {
    status = status.toLowerCase();
    print('status is : $status');
    // print(gender);
    if (status.compareTo('married') == 0) {
      return "Y";
    } else if (status.compareTo('single') == 0)
      return "N";
    return "0";
  }

  static String getDBStyleDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  static Future<String> whereToRedirect() async {
    int id = await getWhoisLoggedIn();
    int min = await getAvailableStaffId();
    var designationOfMap = await DBHelper.instance.getDesignationOfStaffWithId(
      id: id,
    );

    print('id $id to redirect');
    if (min == 1)
      return "/directorSignUp";
    else if (id == 1) {
      return '/directorDashboard';
    } else if (id == -1) {
      return '/login';
    } else {
      // get Designation
      var designationOfMap = await DBHelper.instance
          .getDesignationOfStaffWithId(id: id);

      var desig = designationOfMap[0]['designation'] as String;
      print(desig);
      if (desig.compareTo('Incharge Nurse') == 0) {
        return '/inchargeNurseDashBorad';
      } else if (desig.compareTo('Registration Clerk') == 0) {
        return "/registrationClerkScreen";
      }else if(desig.compareTo('Doctor') == 0){
        return '/doctorDashBoardScreen';
      }
    }
    return "";
  }

  static Future<String> getRouteFromLoginToWhere(int id) async {
    var ls = await DBHelper.instance.getDesignationOfStaffWithId(id: id);
    // print(ls);
    String desig = ls[0]['designation'] as String;
    //print('designatoin is $desig');
    if (desig.compareTo('Incharge Nurse') == 0) {
      return '/inchargeNurseDashBorad';
    } else if (desig.compareTo('Registration Clerk') == 0) {
      return '/registrationClerkScreen';
    } else if (desig.compareTo('Doctor') == 0)
    {
      return '/doctorDashBoardScreen';
    } else {
      return "/director";
    }
  }

  static Future<void> setPassWordof({
    required int id,
    required String password,
  }) async {
    var instance = await SharedPreferences.getInstance();
    instance.setString('$id', password);
  }

  static Future<String?> getPasswordOf({required int id}) async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('$id');
  }

  static Future<int> getMinAvailableSupplierId() async {
    var instance = await SharedPreferences.getInstance();
    var id = await instance.getInt('nextsid');
    if (id == null) return 1;
    return id + 1;
  }

  static Future<void> setMaxSupplierId(int key) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setInt('nextsid', key);
  }

  static Future<bool> doesAnySupplierExistWithId(int id) async {
    var ls = await DBHelper.instance.getSupplierWithSupplierID(id);
    return ls.isNotEmpty;
  }

  static Future<bool> doesAnySupplierExistWithIdWithDesgination({
    required int id,
    required String desg,
  }) async {
    var ls = await DBHelper.instance.getStaffWhereDesignationAndIdid(
      id: id,
      designation: desg,
    );
    return ls.isNotEmpty;
  }

  static String getDBStyleDayNight({required String str}) {
    if (str.compareTo("Day") == 0) {
      return 'd';
    } else {
      return 'n';
    }
  }

  static Future<int> getMaxstaffId() async {
    var minStaffId = await DBHelper.instance.getMaxStaffId();
    return minStaffId[0]['ms'];
  }

  static Future<String> getNameOfStaff({required int id}) async {
    var ls = await DBHelper.instance.getNameOdStaffWithId(id: id);
    return ls[0]['name'];
  }

  static Future<int> wardIdOfInchargeNurse({required int nurse_id}) async {
    var ls = await DBHelper.instance.getWardWithStfId(stf_id: nurse_id);
    // print(ls);
    return ls[0]['ward_id'];
  }

  static void addDescriptionToPatient({required int p_id,required String description})
  async {
    var instance = await SharedPreferences.getInstance();
    instance.setString('desc$p_id', description);
  }
  static Future<String?> getDescriptionOfPatient({required int p_id})
  async {
    var instance = await SharedPreferences.getInstance();
    return instance.getString('desc$p_id');
  }
  static Future<void> AddToDoctorList({
    required int doc_id,
    required int patientId,
  }) async {
    var instance = await SharedPreferences.getInstance();
    var stringList = instance.getStringList('d$doc_id');
    if (stringList == null) {
      List<String> ls = ['$patientId'];
      instance.setStringList('d$doc_id', ls);
    } else {
      stringList.add('$patientId');
      instance.setStringList('d$doc_id', stringList);
    }
  }
  static Future<List<String>?> getAllPIdOfASpecificDoctor({required int id})
  async {
    var instance = await SharedPreferences.getInstance();
    return  instance.getStringList('d$id');
  }

}
