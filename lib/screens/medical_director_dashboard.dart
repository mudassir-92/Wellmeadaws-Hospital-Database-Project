import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';

class MedicalDirectorDashboard extends StatefulWidget {
  const MedicalDirectorDashboard({super.key});
  @override
  State<MedicalDirectorDashboard> createState() =>
      _MedicalDirectorDashboardState();
}

class _MedicalDirectorDashboardState extends State<MedicalDirectorDashboard> {
  String? passWord;
  int _index = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> _supplier = [];
  List<Map<String, dynamic>> _supply = [];
  List<Map<String, dynamic>> _staff = [];
  // List<Map<String, dynamic>> _
  List<Map<String, dynamic>> _ward=[];

  Future<void> _reloadQoutaSupply() async {
    _supplier = await DBHelper.instance.getAllSuppliers();
    _supply = await DBHelper.instance.getALlSupply();
    _staff=await DBHelper.instance.getAllStaff();
    _ward=await DBHelper.instance.getAllWards();
    setState(() {
      isLoading = false;
    });
  }
  Future<void> reloadQoutaStaff() async {
    _staff = await DBHelper.instance.getAllStaff();
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildSupplyScreen(BuildContext context) {
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
                    'Supplier',
                    style: TextStyle(backgroundColor: Colors.grey),
                  ),
                  SizedBox(width: 3),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addNewSupplier');
                      setState(() {
                        _reloadQoutaSupply();
                      });
                    },
                    child: Text("Add New Supplier"),
                  ),
                  SizedBox(width: 3),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/removeSupplier');
                    },
                    child: Text("Remove Supplier"),
                  ),
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
                          DataColumn2(label: Text('Supplier ID')),
                          DataColumn2(label: Text('Name')),
                          DataColumn2(label: Text('Address')),
                          DataColumn2(label: Text('Telephone')),
                        ],
                        rows: _supplier.map((e) {
                          return DataRow(
                            cells: [
                              DataCell(Text(e['s_id'].toString())),
                              DataCell(Text(e['name'].toString())),
                              DataCell(Text(e['address'].toString())),
                              DataCell(Text(e['telephone'].toString())),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
              Row(
                children: [
                  Text(
                    'Pharma Supply',
                    style: TextStyle(backgroundColor: Colors.grey),
                  ),
                  SizedBox(width: 3),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addNewSupply');

                      _reloadQoutaSupply();
                      // });
                    },
                    child: Text("Add New Supply"),
                  ),
                  SizedBox(width: 3),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/removeSupply');
                    },
                    child: Text("Remove Supply"),
                  ),
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
                          // drug_no INTEGER  PRIMARY KEY AUTOINCREMENT,
                          // //                 name TEXT NOT NULL,
                          // //                 description TEXT,
                          // //                 qty INTEGER,
                          // //                 dosage REAL, -- WILL BE IN MG/ML
                          // //                 method_of_use TEXT NOT NULL,
                          // //                 cost_per_unit REAL, -- FOR COUNTRY CURRENCY
                          // //                 s_id INTEGER NOT NULL,
                          // //                 FOREIGN KEY (s_id) REFERENCES supplier(s_id)
                          DataColumn2(label: Text('Drug No')),
                          DataColumn2(label: Text('Name')),
                          DataColumn2(label: Text('Description')),
                          DataColumn2(label: Text('Quantity')),
                          DataColumn2(label: Text('Dosage')),
                          DataColumn2(label: Text('Method of Use')),
                          DataColumn2(label: Text('Cost Per Unit')),
                          DataColumn2(label: Text('Supplier Id')),
                        ],
                        rows: _supply.map((e) {
                          return DataRow(
                            cells: [
                              DataCell(Text(e['drug_no'].toString())),
                              DataCell(Text(e['name'].toString())),
                              DataCell(Text(e['description'].toString())),
                              DataCell(Text(e['qty'].toString())),
                              DataCell(Text(e['dosage'].toString())),
                              DataCell(Text(e['method_of_use'].toString())),
                              DataCell(Text(e['cost_per_unit'].toString())),
                              DataCell(Text(e['s_id'].toString())),
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

  Widget _buildStaffScreen(BuildContext context) {
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Staff',
                      style: TextStyle(backgroundColor: Colors.green),
                    ),
                    SizedBox(width: 3),
                    OutlinedButton(
                      onPressed: () {
                         Navigator.pushNamed(context, '/addNewStaff');
                        setState(() {

                        });
                      },
                      child: Text("Add New Staff"),
                    ),
                    SizedBox(width: 3),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/removeStaff');
                      },
                      child: Text("Remove Staff"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addStaffExperience');
                      },
                      child: Text("Add Staff Experience"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addStaffQualification');
                      },
                      child: Text("Add Staff Qualification"),
                    ),
                  ],
                ),
              ),
              // add  table
              isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                height: size.height*.7 ,
                // stf_id INTEGER PRIMARY KEY AUTOINCREMENT,
                //                 name TEXT NOT NULL,
                //                 gender TEXT CHECK( gender IN ('f','m','o')), -- female ,male ,other
                //                 shift TEXT CHECK( shift IN ('d','n')), -- day ,night
                //                 telephone TEXT ,
                //                 dob TEXT,
                //                 address TEXT,
                //                 designation TEXT, -- INCHARGE  NURSE, MEDICAL DIRECTOR
                //                 insurance_number TEXT,
                //                 salary REAL
                child: DataTable2(
                  dividerThickness: 3,
                  // columnSpacing: 10,
                  headingRowColor: WidgetStatePropertyAll(
                    Colors.deepPurpleAccent,
                  ),
                  columns: [
                    DataColumn2(label: Text('Staff ID')),
                    DataColumn2(label: Text('Name')),
                    DataColumn2(label: Text('Gender')),
                    DataColumn2(label: Text('Shift')),
                    DataColumn2(label: Text('Telephone')),
                    DataColumn2(label: Text('DOB')),
                    DataColumn2(label: Text('Address')),
                    DataColumn2(label: Text('Designation')),
                    DataColumn2(label: Text('Insurance')),
                    DataColumn2(label: Text('Salary')),

                  ],
                  rows: _staff.map((e) {
                    return DataRow(
                      cells: [
                        DataCell(Text(e['stf_id'].toString())),
                        DataCell(Text(e['name'].toString())),
                        DataCell(Text(e['gender'].toString())),
                        DataCell(Text(e['shift'].toString())),
                        DataCell(Text(e['telephone'].toString())),
                        DataCell(Text(e['dob'].toString())),
                        DataCell(Text(e['address'].toString())),
                        DataCell(Text(e['designation'].toString())),
                        DataCell(Text(e['insurance_number'].toString())),
                        DataCell(Text(e['salary'].toString())),
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
  Widget _buildWardScreen(BuildContext context)
  {
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Wards',
                        style: TextStyle(backgroundColor: Colors.green),
                      ),
                      SizedBox(width: 3),
                      OutlinedButton(
                        onPressed: () {
                           Navigator.pushNamed(context, '/addNewWard');
                          setState(() {

                          });
                        },
                        child: Text("Add New Ward"),
                      ),
                      SizedBox(width: 3),
                      OutlinedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/removeStaff');
                        },
                        child: Text("Remove Ward"),
                      ),
                    ],
                  ),
                ),
                // add  table
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
                      DataColumn2(label: Text('Ward No')),
                      DataColumn2(label: Text('Ward Name')),
                      DataColumn2(label: Text('Number Of Beds')),
                      DataColumn2(label: Text('Location')),
                      DataColumn2(label: Text('Charge Nurse ID')),
                    ],
                    rows: _ward.map((e) {
                      return DataRow(
                        cells: [
                          DataCell(Text(e['ward_id'].toString())),
                          DataCell(Text(e['ward_name'].toString())),
                          DataCell(Text(e['number_of_beds'].toString())),
                          DataCell(Text(e['location'].toString())),
                          DataCell(Text(e['stf_id'].toString())),
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
  }

  @override
  void initState() {
    super.initState();
    _reloadQoutaSupply();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Wellmeadows Hospital ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      drawer:  Drawer(
          child:ListView(
            children: [
              DrawerHeader(child: Text('Menu'),decoration: BoxDecoration(color: Colors.blue),),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          _reloadQoutaSupply();
        },
      ),
      body: IndexedStack(
        index: _index,
        children: [
          _buildStaffScreen(context),
          _buildSupplyScreen(context),
          _buildWardScreen(context),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            // scr();
            //_reloadSupplier();
            print(value);
            _index = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.medical_information),
            label: 'Medical',
          ),
          NavigationDestination(
            icon: Icon(Icons.accessibility),
            label: 'Supply',
          ),
          NavigationDestination(icon: Icon(Icons.warehouse), label: 'wards'),
        ],
        // elevation: 2101,
        surfaceTintColor: Colors.pink,
      ),
    );
  }
}
