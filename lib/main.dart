import 'package:flutter/material.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
import 'package:wellmeadows_hospital/screens/LoginScreen.dart';
import 'package:wellmeadows_hospital/screens/add_new_requisition_screen.dart';
import 'package:wellmeadows_hospital/screens/add_new_staff_screen.dart';
import 'package:wellmeadows_hospital/screens/add_new_supplier_screen.dart';
import 'package:wellmeadows_hospital/screens/add_new_supply_screen.dart';
import 'package:wellmeadows_hospital/screens/add_new_ward_screen.dart';
import 'package:wellmeadows_hospital/screens/add_staff_contract_screen.dart';
import 'package:wellmeadows_hospital/screens/add_staff_experience_screen.dart';
import 'package:wellmeadows_hospital/screens/add_staff_qualificatoin.dart';
import 'package:wellmeadows_hospital/screens/doctor_dashboard_screen.dart';
import 'package:wellmeadows_hospital/screens/home_screen.dart';
import 'package:wellmeadows_hospital/screens/incharge_nurse_dashboard_screen.dart';
import 'package:wellmeadows_hospital/screens/medical_director_dashboard.dart';
import 'package:wellmeadows_hospital/screens/medical_director_signup_screen.dart';
import 'package:wellmeadows_hospital/screens/registration_clerk_dashboard_screen.dart';
import 'package:wellmeadows_hospital/screens/remove_staff_screen.dart';
import 'package:wellmeadows_hospital/screens/remove_supplier_screen.dart';
import 'package:wellmeadows_hospital/screens/remove_supply_screen.dart';
import 'package:wellmeadows_hospital/screens/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory=databaseFactoryFfi;
  // await DBHelper.instance.insertInSupplier(name: "Aftab Nawaz", address: "Peshawar", mobile: "03297629759");
  // DBHelper.
  // AppController.
  runApp(myApp());
}
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Wellmeadows Hospital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff4CAF50),
        scaffoldBackgroundColor: Colors.white
      ),
      // home: SplashScreen(),
      initialRoute: '/splash',
      routes: {
        '/splash':(context)=>SplashScreen(),
        '/home':(context)=>HomeScreen(),
        '/login':(context)=>Loginscreen(),
        '/directorSignUp':(context)=>MedicalDirectorSignupScreen(),
        '/directorDashboard':(context)=>MedicalDirectorDashboard(),
        '/addNewSupplier':(context)=>AddNewSupplierScreen(),
        '/removeSupplier':(context)=>RemoveSupplierScreen(),
        '/addNewSupply':(context)=>AddNewSupplyScreen(),
        '/removeSupply':(context)=>RemoveSupplyScreen(),

        // staff screens are below
        '/addNewStaff':(context)=>AddNewStaffScreen(),
        '/removeStaff':(context)=>RemoveStaffScreen(),
        '/addStaffExperience':(context)=>AddStaffExperienceScreen(),
        '/addStaffQualification':(context)=>AddStaffQualificatoin(),
        '/addStaffContract':(context)=>AddStaffContractScreen(),
        '/addNewWard':(context)=>AddNewWardScreen(),
        '/inchargeNurseDashBorad':(context)=>InchargeNurseDashboardScreen(),
        '/registrationClerkScreen':(context)=>RegistrationClerkDashboardScreen(),
        '/doctorDashBoardScreen':(context)=>DoctorDashboardScreen()
      },
    );
  }
}
class hh extends StatefulWidget {
  const hh({super.key});

  @override
  State<hh> createState() => _hhState();
}

class _hhState extends State<hh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('The Wellmeadows Hospital'),),
      body: Text("kon"),

    );
  }
}

