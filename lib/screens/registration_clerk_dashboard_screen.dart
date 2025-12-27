import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../controller/app_controller.dart';
import '../model/DBHelper.dart';
class RegistrationClerkDashboardScreen extends StatefulWidget {
  const RegistrationClerkDashboardScreen({super.key});

  @override
  State<RegistrationClerkDashboardScreen> createState() => _RegistrationClerkDashboardScreenState();
}

class _RegistrationClerkDashboardScreenState extends State<RegistrationClerkDashboardScreen> {
  TextEditingController _nameC = TextEditingController();
  TextEditingController _addressC=TextEditingController();
  TextEditingController _teleC=TextEditingController();
  String? MartialStatus;
  String? gender;
  bool isAnyError = false;
  String errorMsg="";
  int _index=0;
  String? idStr;
  TextEditingController _doctorIdC=TextEditingController();
  TextEditingController _descriptionC=TextEditingController();
  String patientStr="";
  List<Map<String,dynamic>> _doctorList=[];
  List<Map<String,dynamic>> _patientList=[];
  TextEditingController _nok_NameC=TextEditingController();
  TextEditingController  _nok_Relation=TextEditingController();
  TextEditingController _nok_tele=TextEditingController();
  TextEditingController _nok_address=TextEditingController();
  Future<void> loadQouta() async {
    // get All Pharma Supply
   _doctorList= await DBHelper.instance.getStaffWhereDesignation(designation: 'Doctor');
   _patientList=await DBHelper.instance.getAllPatients();
   print(_patientList);
    setState(() {});
  }
  void resetAll(){
    _nok_address=TextEditingController();
    _nok_NameC=TextEditingController();
    _nok_Relation=TextEditingController();
    _nok_tele=TextEditingController();
    _nameC = TextEditingController();
    _addressC=TextEditingController();
     _teleC=TextEditingController();
     MartialStatus=null;
     gender=null;
     isAnyError = false;
     errorMsg="";
     _doctorIdC=TextEditingController();
     _descriptionC=TextEditingController();
     _dobC=TextEditingController();
     _doctorIdC=TextEditingController();
     idStr=null;
      doctor_id_sel=null;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }
  Widget _buildAddPaitientScreen(BuildContext context)
  {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        alignment: AlignmentGeometry.topCenter,
        children: [
          Lottie.asset(
            'assets/bgG.json',
            width: size.width,
            height: size.height ,
            fit: BoxFit.cover,
            repeat: true,
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 300,
                child: Image.asset('assets/logo.png'),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _nameC,
                  decoration: InputDecoration(
                    hintText: 'Enter Patient Name', // should be less then available
                    label: Text('Name'),
                    // labelText: 'id'
                    border: OutlineInputBorder(
                      // borderRadius:
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _addressC,
                  decoration: InputDecoration(
                    hintText: 'Enter Address', // should be less then available
                    label: Text('Address'),
                    // labelText: 'id'
                    border: OutlineInputBorder(
                      // borderRadius:
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _teleC,
                  decoration: InputDecoration(
                    hintText: 'Enter Telephone', // should be less then available
                    label: Text('Telephone'),
                    // labelText: 'id'
                    border: OutlineInputBorder(
                      // borderRadius:
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _dobC,
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: 'Select Date',
                      // labelStyle: 'Dat',
                      labelText: 'Date Of Birth',
                      prefixIcon: Icon(Icons.today),
                      border: OutlineInputBorder(
                      )
                  ),
                  onTap: () async{
                    final DateTime? pickedDate=await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.timestamp());
                    var _dateTime=pickedDate;
                    if(pickedDate!=null) {
                      _dobC.text='${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    }},
                ),
              ),
              SizedBox(height: 15),
              DropdownButton<String>(
                // icon: Icon(Icons.),
                  hint: Text('Select Martial Status'),value: MartialStatus,items: ['Married','Single'].map((u)=>DropdownMenuItem(value:u,child: Text(u))).toList(), onChanged: (u){
                setState(() {
                  MartialStatus=u;
                });
              }),
              SizedBox(height: 15),
              DropdownButton<String>(
                // icon: Icon(Icons.),
                  hint: Text('Select Gender'),value: gender,items: ['Male','Female'].map((u)=>DropdownMenuItem(value:u,child: Text(u))).toList(), onChanged: (u){
                setState(() {
                  gender=u;
                });
              }),
              SizedBox(height: 15),
              DropdownButton<String>(
                hint: Text('Select Doctor'),
                value: doctor_id_sel,
                items: _doctorList
                    .map(
                      (u) => DropdownMenuItem<String>(
                    value: 'id: ${u['stf_id']} : ${u['name']}',
                    child: Text('id: ${u['stf_id']} : ${u['name']}'),
                  ),
                )
                    .toList(),
                onChanged: (String? k) {
                  setState(() {
                    doctor_id_sel = k;
                    //  print(allSupply.map((e) => "'${e['name']}'").toList());
                    print("Current value: '$doctor_id_sel'");
                  });
                },
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _descriptionC,
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter Description', // should be less then available
                    label: Text('Description'),
                    // labelText: 'id'
                    border: OutlineInputBorder(
                      // borderRadius:
                    ),
                  ),
                ),
              ),
              if (isAnyError) SizedBox(height: 15),
              if (isAnyError)
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.red,
                  child: Text(
                    errorMsg,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              SizedBox(
                width: 150,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if(_nameC.text.trim().isEmpty || _addressC.text.trim().isEmpty
                    || _teleC.text.trim().isEmpty || _dobC.text.trim().isEmpty
                    ||gender==null || MartialStatus==null ||
                        doctor_id_sel==null || doctor_id_sel!.trim().isEmpty || _descriptionC.text.trim().isEmpty)
                      {
                        print(doctor_id_sel);
                        errorMsg="Please fill all the areas";
                        isAnyError=true;
                        setState(() {
                        });
                      }else{
                      String abc=doctor_id_sel!;
                      //print(abc.split(':')[1]);
                       var doctor_id = int.tryParse(abc.split(':')[1]);
                       isAnyError=false;
                       int i=await DBHelper.instance.insertIntoPatients(name: _nameC.text, address: _addressC.text,
                           tele: _teleC.text, dob: _dobC.text, martialStat: AppController.getMartialStausChar(MartialStatus!), gender: AppController.getGenderChar(gender!,false), d_id: doctor_id!, description: _descriptionC.text);
                       if(i==0){
                         errorMsg="Insertion Failed";
                         isAnyError=true;
                         setState(() {
                         });
                       }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Patient Added Successfully'))
                          );
                          resetAll();
                          setState(() {
                          });
                       }

                    }
                  },
                  label: Text('Add Patient'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildNextOfKinScreen(BuildContext context){
    {
      var size = MediaQuery.of(context).size;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          alignment: AlignmentGeometry.topCenter,
          children: [
            Lottie.asset(
              'assets/bgG.json',
              width: size.width,
              height: size.height ,
              fit: BoxFit.cover,
              repeat: true,
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 300,
                  child: Image.asset('assets/logo.png'),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nok_NameC,
                    decoration: InputDecoration(
                      hintText: 'Enter Patient Name', // should be less then available
                      label: Text('Name'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nok_address,
                    decoration: InputDecoration(
                      hintText: 'Enter Address', // should be less then available
                      label: Text('Address'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nok_tele,
                    decoration: InputDecoration(
                      hintText: 'Enter Telephone', // should be less then available
                      label: Text('Telephone'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                SizedBox(height: 15),
                DropdownButton<String>(
                  hint: Text('Select Patient'),
                  value: idStr,
                  items: _patientList
                      .map(
                        (u) => DropdownMenuItem<String>(
                      value: u['p_id'].toString(),
                      child: Text('id: ${u['p_id']} ${u['name']}'),
                    ),
                  )
                      .toList(),
                  onChanged: (String? k) {
                    setState(() {
                      idStr = k;
                      //  print(allSupply.map((e) => "'${e['name']}'").toList());
                      print("Current value: '$idStr'");
                    });
                  },
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nok_Relation,
                    decoration: InputDecoration(
                      hintText: 'Next of Kin is ...', // should be less then available
                      label: Text('Relationship'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                if (isAnyError) SizedBox(height: 15),
                if (isAnyError)
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.red,
                    child: Text(
                      errorMsg,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                SizedBox(
                  width: 150,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      if(_nok_NameC.text.trim().isEmpty || _nok_address.text.trim().isEmpty
                      || _nok_tele.text.trim().isEmpty || _nok_tele.text.trim().isEmpty || idStr==null
                      )
                      {
                        errorMsg="Please fill all the areas";
                        isAnyError=true;
                        setState(() {
                        });
                      }else{
                        String? abc=idStr!;
                        // print(do)
                        // print(abc);
                        var p_id = int.tryParse(abc);
                        isAnyError=false;
                        int i=await DBHelper.instance.insertIntoNextOfKin(name: _nok_NameC.text, relationShip: _nok_Relation.text, telephone: _nok_tele.text, p_id: p_id!);
                        if(i==0){
                          errorMsg="Insertion Failed";
                          isAnyError=true;
                          setState(() {
                          });
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Next of Kin Added Successfully'))
                          );
                          resetAll();
                          setState(() {
                          });
                        }

                      }
                    },
                    label: Text('Add Next of Kin'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
  int? drugId;
  String? doctor_id_sel;
  TextEditingController _dobC=TextEditingController();
  @override
  Widget build(BuildContext context) {
    // loadQouta();

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
      body: IndexedStack(
        index: _index,
        children: [
          _buildAddPaitientScreen(context),
          _buildNextOfKinScreen(context)
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.medical_information),
            label: 'Patient',
          ),
          NavigationDestination(
            icon: Icon(Icons.accessibility),
            label: 'Next Of Kin',
          ),
        ],
        // elevation: 2101,
        surfaceTintColor: Colors.pink,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        loadQouta();
      },
      child: Icon(Icons.refresh),),
    );
  }
}