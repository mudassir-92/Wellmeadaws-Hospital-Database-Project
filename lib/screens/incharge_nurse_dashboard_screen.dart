import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
import 'package:wellmeadows_hospital/screens/add_new_requisition_screen.dart';

import '../controller/app_controller.dart';
class InchargeNurseDashboardScreen  extends StatefulWidget {
  const InchargeNurseDashboardScreen ({super.key});

  @override
  State<InchargeNurseDashboardScreen > createState() => _InchargeNurseDashboardScreen();
}

class _InchargeNurseDashboardScreen extends State<InchargeNurseDashboardScreen > {
  int _index = 0;
  String _name = "";
  int? nurseId;
  int wardId = -1;
  int stfId = -1;
  List<Map<String, dynamic>>? ls;
  bool isLoading=true;
  List<Map<String,dynamic>> _wardRequisition=List.empty();
  List<Map<String,dynamic>> _inPatients=List.empty();
  Widget _buildFirstScreen() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome "),
            Text(_name, style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),)
          ],
        ),
        // will be shown the ward info
        if(wardId==-1)
          SizedBox(
            height: 50,
          ),
        if(wardId==-1)
          Text('Assigned to No Ward'),
        SizedBox(height: 100,),
        if(wardId!=-1)
          Text("Assigned to ${ls?[0]['ward_name']}")
        // implement to check all

      ],
    );
  }
  Widget _buildInPatientAndWardRequizitionScreen(BuildContext context)
   {
     var size = MediaQuery.of(context).size;
     // print('dsfsdf');
     return Column(
       // crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         SizedBox(height: 3),
         // add all about suppleir
         Expanded(
           flex: 2,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             // mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Row(
                 children: [
                   Text(
                     'Requisitions',
                     style: TextStyle(backgroundColor: Colors.grey),
                   ),
                   SizedBox(width: 3),
                   OutlinedButton(
                     onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return AddNewRequisitionScreen(ward_id: wardId,);
                       },));
                       setState(() {
                       });
                     },
                     child: Text("Add Requisition"),
                   ),
                   SizedBox(width: 3),
                 ],
               ),
               SizedBox(height: 3),
               isLoading
                   ? CircularProgressIndicator()
                   : SizedBox(
                 height: size.height * .3,
                 child: DataTable2(
                   dividerThickness: 3,
                   // columnSpacing: 10,
                   headingRowColor: WidgetStatePropertyAll(
                     Colors.deepPurpleAccent,
                   ),
                   columns: [
                     DataColumn2(label: Text('Requisition Id')),
                     DataColumn2(label: Text('Date Ordered')),
                   ],
                   rows: _wardRequisition.map((e) {
                     return DataRow(
                       cells: [
                         DataCell(Text(e['r_id'].toString())),
                         DataCell(Text(e['date_ordered'].toString())),
                       ],
                     );
                   }).toList(),
                 ),
               ),
               Row(
                 children: [
                   Text(
                     'In patients',
                     style: TextStyle(backgroundColor: Colors.grey),
                   ),
                   SizedBox(width: 3),
                 ],
               ),
               SizedBox(height: 3),
               isLoading
                   ? CircularProgressIndicator()
                   : SizedBox(
                 height: size.height * .35,
                 child: DataTable2(
                   dividerThickness: 3,
                   // columnSpacing: 10,
                   headingRowColor: WidgetStatePropertyAll(
                     Colors.deepPurpleAccent,
                   ),
                   columns: [
                     DataColumn2(label: Text('Patient ID')),
                     DataColumn2(label: Text('Name')),
                     DataColumn2(label: Text('Bed No')),
                     DataColumn2(label: Text('Admit Date')),
                     DataColumn2(label: Text('Exit Date')),
                   ],
                   rows: _inPatients.map((e) {
                     return DataRow(
                       cells: [
                         DataCell(Text(e['p_id'].toString())),
                         DataCell(Text(e['name'].toString())),
                         DataCell(Text(e['bed_no'].toString())),
                         DataCell(Text(e['admit_date'].toString())),
                         DataCell(Text(e['exit_date'].toString())),
                       ],
                     );
                   }).toList(),
                 ),
               ),
             ],
           ),
         ),
       ],
     );
   }
  // get ward she/he is asiigned to

  Future<void> firstloadQouta()
  async {
    stfId=await AppController.getWhoisLoggedIn();
    wardId=await AppController.wardIdOfInchargeNurse(nurse_id: stfId);
    _name=await AppController.getNameOfStaff(id: stfId);
    ls=await DBHelper.instance.getWardWithStfId(stf_id: stfId);
    _wardRequisition=await DBHelper.instance.getAllRequisitionsOfWard(wardId: wardId);
    _inPatients=await DBHelper.instance.getAllInPatientOfWard(wardNo: wardId);
    await DBHelper.instance.deleteRequesistionInRange(start: 1, end: 4);
    setState(() {
      // pragma
      isLoading=false;
    });

    // print('check1:$ls');
  }

  Future<void> loadQouta()
  async {
    setState(() {
      print(ls);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
    firstloadQouta();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "In-charge Nurse",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
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
      body:IndexedStack(
        index: _index,
        children: [
          _buildFirstScreen(),
          _buildInPatientAndWardRequizitionScreen(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){
        setState(() {
          firstloadQouta();
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
        NavigationDestination(icon: Icon(Icons.man), label: 'Ward Info'),
        NavigationDestination(icon: Icon(Icons.man), label: '==2'),
      ]),
    );
  }
}
