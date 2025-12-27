import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';

import '../model/DBHelper.dart';

class AddNewStaffScreen  extends StatefulWidget {
  const AddNewStaffScreen ({super.key});

  @override
  State<AddNewStaffScreen > createState() => _AddNewStaffScreen();
}

class _AddNewStaffScreen extends State<AddNewStaffScreen >
{
  //  name,description,qty,dosage,methodOfUse,costPerUnit,supplierId
  TextEditingController _nameC=TextEditingController();
  int? _s_id;
  TextEditingController _teleC=TextEditingController();
  TextEditingController _addressC=TextEditingController();
  TextEditingController _insuranceC=TextEditingController();
  TextEditingController _salaryC=TextEditingController();
  TextEditingController _passwordC=TextEditingController();
  TextEditingController _supplierIdC=TextEditingController();
  TextEditingController _dobC=TextEditingController();
  DateTime? _dateTime;
  bool isAnyError=false;
  List<dynamic> listOfAllSupplier=[];
  int? sid;
  String errorMsg="";
  String? gender;
  String? shift;
  String? designation;
  Future<void> loadQouta()
  async {
    var instance = DBHelper.instance;
    var allSuppliers = await instance.getAllSuppliers();
    listOfAllSupplier=allSuppliers.map((e) {
      return e['s_id'];
    },).toList();
    print(listOfAllSupplier);
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
        appBar:AppBar(
          title: Text('Add New Staff',style: TextStyle(
              color: Colors.white
          ),
          ),
          backgroundColor: Colors.black,
        ),
        body:Stack(
            alignment: AlignmentGeometry.topCenter,
            children:[
              Lottie.asset(
                'assets/bgG.json',
                width: size.width,
                height: size.height*1.18,
                fit: BoxFit.cover,
                repeat: true,
              ),
              SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 300,
                        child: Image.asset('assets/logo.png'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: _nameC,
                          decoration: InputDecoration(
                            hintText: 'Enter Staff Name',
                            label: Text('Name'),
                            // labelText: 'id'
                            border: OutlineInputBorder(
                              // borderRadius:
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButton<String>(
                        // icon: Icon(Icons.),
                          hint: Text('Select Gender'),value: gender,items: ['Male','Female','other'].map((u)=>DropdownMenuItem(value:u,child: Text(u))).toList(), onChanged: (u){
                        setState(() {
                          gender=u;
                        });
                      }),
                      DropdownButton<String>(
                        // icon: Icon(Icons.),
                          hint: Text('Select Shift'),value: shift,items: ['Day','Night',].map((u)=>DropdownMenuItem(value:u,child: Text(u))).toList(), onChanged: (u){
                        setState(() {
                          shift=u;
                        });
                      }),

                      SizedBox(
                          width: 250,
                          child: TextField(
                            controller: _teleC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.call),
                              hintText: 'Enter Telephone',
                              label: Text('Telephone'),
                              // labelText: 'id'
                              border: OutlineInputBorder(
                                // borderRadius:
                              ),
                            ),
                          )
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                            _dateTime=pickedDate;
                            if(pickedDate!=null) {
                              _dobC.text='${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                            }},
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller:_addressC ,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on_outlined),
                            hintText: 'Enter Address',
                            label: Text('Address'),
                            // labelText: 'id'
                            border: OutlineInputBorder(
                              // borderRadius:
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButton<String>(
                        // icon: Icon(Icons.),
                          hint: Text('Select Designation'),value: designation,items: ['Incharge Nurse','Doctor','Registration Clerk'].map((u)=>DropdownMenuItem(value:u,child: Text(u))).toList(), onChanged: (u){
                        setState(() {
                          designation=u;
                        });
                      }),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller:_insuranceC ,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.call),
                            hintText: 'Enter Insurance Number',
                            label: Text('Insurance Number'),
                            // labelText: 'id'
                            border: OutlineInputBorder(
                              // borderRadius:
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller:_salaryC ,
                          decoration: InputDecoration(
                            hintText: 'Enter Salary',
                            label: Text('Salary'),
                            // labelText: 'id'
                            border: OutlineInputBorder(
                              // borderRadius:
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller:_passwordC ,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText: 'Enter Password',
                            label: Text('Password'),
                            // labelText: 'id'
                            border: OutlineInputBorder(
                              // borderRadius:
                            ),
                          ),
                        ),
                      ),

                      if(isAnyError && errorMsg.isNotEmpty)
                        SizedBox(
                          height: 15,
                        ),
                      if(isAnyError && errorMsg.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.red,
                          child: Text(
                            errorMsg,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 150,
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            // check if any issue with data then insert into
                            if(_nameC.text.trim().isEmpty ||_teleC.text.trim().isEmpty
                                || _addressC.text.trim().isEmpty|| _insuranceC.text.trim().isEmpty
                                || _salaryC.text.trim().isEmpty || _passwordC.text.trim().isEmpty
                                || gender==null || shift==null || designation==null) {
                              isAnyError=true;
                              errorMsg="ALl Fields are not filled";
                              setState(() {
                              });
                            }else{
                              // inwert detail
                              var instance = DBHelper.instance;
                              // print(gender);

                              // print(_costPerUnitC.text);

                              var i = await instance.insertIntoStaff(name: _nameC.text, address: _addressC.text,gender: AppController.getGenderChar(gender!,true),
                                  designation: designation!,dob: AppController.getDBStyleDate(_dateTime!),insurance_no: _insuranceC.text,telephone: _teleC.text,
                                  salary: double.tryParse(_salaryC.text),shift:AppController.getDBStyleDayNight(str: shift!));
                              AppController.setPassWordof(id: await AppController.getMaxstaffId(), password: _passwordC.text);
                              if(i==0) {
                                errorMsg="Error in Insertion";
                                // print('No Supplier $i');
                                setState(() {
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          },
                          label: Text('SignUp'),
                        ),
                      ),
                    ]
                ),
              )
            ]
        )
    );
  }
}