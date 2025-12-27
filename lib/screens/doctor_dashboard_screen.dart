import 'package:flutter/material.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
import 'package:wellmeadows_hospital/screens/patient_detail_managment_screen.dart';
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int? doctorId;
  List<Map<String,dynamic>> ls=[];
  String name="";
  int _index=0;
  // load all patients belonging to this teacher
  List<Map<String,dynamic>> patients=[];
  String? desc;
  List<String?>? pids;
  List<int> ? ppids;
  Future<void> loadQouta() async {
    doctorId = await AppController.getWhoisLoggedIn();
     ls = await DBHelper.instance.getStaffWhereDesignationAndIdid(designation: 'Doctor', id: doctorId!);
      name=ls[0]['name'];
      pids = await AppController.getAllPIdOfASpecificDoctor(id:doctorId!);
      ppids=pids?.map((e) => int.parse(e!),).toList();
      // desc=await AppController.getDescriptionOfPatient(p_id: widget., )
     patients=await DBHelper.instance.getPatientWithIds(ls: ppids??[]);
      setState(() {

      });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }
  Widget _buildPatientScreen(BuildContext context){
    return Column(
      children: [
        Expanded(
          child: patients.isEmpty
              ? Center(child: CircularProgressIndicator())
              :ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
            final p=patients[index];
            // print('index $index with $p');
            return InkWell(
              onTap: () {
                // push to navigator
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PatientDetailManagmentScreen(p_id:p['p_id']);
                },));
              },
              child: ListTile(
                leading: CircleAvatar(child: Text(p['name'][0]),),
                title: Text(p['name']),
                // trailing: ,
              ),
            );
          },),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body:IndexedStack(
        index: 0,
        children: [
         _buildPatientScreen(context),
          Text('Hello')
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){
        setState(() {
          loadQouta();
        });
      },
        child: Icon(Icons.refresh),),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) {
            _index=value;
            setState(() {
              // print(_index);
            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.people_sharp), label: 'Patients'),
            NavigationDestination(icon: Icon(Icons.man), label: '==2'),
          ]),
      drawer:  Drawer(
        child:ListView(
          children: [
            DrawerHeader(decoration: BoxDecoration(color: Colors.blue),child: Text('Menu'),),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await AppController.setWhoIsLoggedIn(-1);
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
    );
  }
}
