import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Database? db;
  bool isDBLoaded=false;
  @override
  void initState()  {
    super.initState();
      // load database ...
    loadDB();
  }

  Future<void> loadDB()
  async {
      db=await DBHelper.instance.getDB(); // will initalize db
      await Future.delayed(Duration(seconds: 4));
      String whereToGo=await AppController.whereToRedirect();
      print('where to go'+whereToGo);
      if(!whereToGo.isEmpty) {
        Navigator.pushReplacementNamed(context,whereToGo);
      }
      // Navigator.pop(context)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:  Text('The Wellmeadows Hospital'),centerTitle:true,),
      body:Container(
        child: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
      bottomSheet: Text('By Mudassir Ashraf '),
    );
  }
}
