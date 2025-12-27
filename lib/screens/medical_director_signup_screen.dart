import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';

class MedicalDirectorSignupScreen extends StatefulWidget {
  const MedicalDirectorSignupScreen({super.key});

  @override
  State<MedicalDirectorSignupScreen> createState() => _MedicalDirectorSignupScreenState();
}
class _MedicalDirectorSignupScreenState extends State<MedicalDirectorSignupScreen> {
  int? _avlStfId;
  var _idC=TextEditingController();
  var _nameC=TextEditingController();
  String? gender;
  var _teleC=TextEditingController();
  var _dobC=TextEditingController();
  var _addressC=TextEditingController();
  var _insuranceC=TextEditingController();
  var _salaryC=TextEditingController();
  var _passwordC=TextEditingController();

  TextEditingController dateController = TextEditingController();
  DateTime? _dateTime;

  Future<void> loadQouta()
  async {
    _avlStfId =  await AppController.getAvailableStaffId();
    print(_avlStfId==null);
    setState(() {
      // when qouta is loaded then show it on UI
      // idc.text="${avlStfId}DSfdsf";
    });
  }
  bool isAnyError=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }
  @override
  Widget build(BuildContext context) {
    if(_avlStfId!>1) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('The Wellmeadows Hospital ',style: TextStyle(
            color: Colors.white
        ),),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all( 16),
        child: Stack(
          alignment: AlignmentGeometry.topCenter,
          children:[
            Lottie.asset(
              'assets/bgG.json',
              width: size.width,
              height: size.height*1.18,
              fit: BoxFit.cover,
              repeat: true,
            ),
            Column(
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
                // fetch the available staff id
                SizedBox(
                  width: 250,
                  child: TextField(
                    readOnly: _avlStfId!=null,
                     // controller: ,
                    decoration: InputDecoration(
                      hintText: _avlStfId==null?'Loading...':_avlStfId.toString(),
                      label: Text('id'),
                      // labelText: 'id',
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
                     controller: _nameC,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                      label: Text('Name'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButton<String>(hint: Text('Select Gender'),value: gender,items: ['Male','Female','other'].map((u)=>DropdownMenuItem(value:u,child: Text(u))).toList(), onChanged: (u){
                  setState(() {
                    gender=u;
                  });
                }),
                // shift ik hi hai director ki only on director
                // telephone
                SizedBox(
                  width: 250,
                  child: TextField(
                     controller:_teleC ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      hintText: 'Enter Your telephone',
                      label: Text('Telephone'),
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
                //  DOB pickeer
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
                // Address
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                     controller: _addressC,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'Enter Your Address',
                      label: Text('Address'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // insurnce number
                SizedBox(
                  width: 250,
                  child: TextField(
                     controller: _insuranceC,
                    // keyboardType: TextInputType.,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.airline_seat_legroom_extra_rounded),
                      hintText: 'Enter Your Insurance number',
                      label: Text('Insurance No'),
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
                     controller: _salaryC,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      hintText: 'Enter Your Salary',
                      label: Text('Salary'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                // password
                SizedBox(
                  height: 15,
                ),
                 SizedBox(
                  width: 250,
                  child: TextField(
                     controller: _passwordC,
                    // keyboardType: TextInputType.,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Enter New Password',
                      label: Text('Password'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
                  ),
                ),
                if (isAnyError)
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.red,
                    child: Text(
                      "Some Entry is not correct",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 150,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      // check if any issue with data then insert into
                      if(_nameC.text.trim().isEmpty || gender==null || _teleC.text.trim().isEmpty ||_dobC.text.trim().isEmpty
                      || _addressC.text.trim().isEmpty ||  _insuranceC.text.trim().isEmpty ||
                          _salaryC.text.trim().isEmpty || _passwordC.text.isEmpty
                      )
                        {
                          isAnyError=true;
                          setState(() {

                          });
                        }else{
                        // inwert detail
                        var instance = DBHelper.instance;
                        print(gender);
                        await instance.insertIntoStaff(name: _nameC.text, gender:AppController.getGenderChar(gender!,true),
                        address: _addressC.text,designation: 'medical director',dob: AppController.getDBStyleDate(_dateTime!),
                          insurance_no: _insuranceC.text ,salary: double.parse(_salaryC.text),telephone: _teleC.text
                        );

                        // navigate to Medical director
                        AppController.setWhoIsLoggedIn(1);
                        AppController.setPassWordof(id: 1, password: _passwordC.text);
                        Navigator.pushReplacementNamed(context, '/directorDashboard');
                      }
                    },
                    label: Text('SignUp'),
                  ),
                ),
              ],
            ),
          ]
        )
      ),
      // bottomSheet: Text('Developed by Mudassir'),

    );
  }
}
