import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../controller/app_controller.dart';
import '../model/DBHelper.dart';

class AddStaffQualificatoin extends StatefulWidget {
  const AddStaffQualificatoin({super.key});

  @override
  State<AddStaffQualificatoin> createState() => _AddStaffQualificatoinState();
}

class _AddStaffQualificatoinState extends State<AddStaffQualificatoin> {
  TextEditingController _stf_idC = TextEditingController();
  TextEditingController _titleC = TextEditingController();
  TextEditingController _instituteC = TextEditingController();
  TextEditingController _startDateC = TextEditingController();
  TextEditingController _endDateC = TextEditingController();
  bool isAnyError = false;
  DateTime? _startDate;
  DateTime? _endDate;
  String errorMsg = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadQouta();
  }

  @override
  Widget build(BuildContext context) {
    // loadQouta();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Staff Qualification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        alignment: AlignmentGeometry.topCenter,
        children: [
          Lottie.asset(
            'assets/bgG.json',
            width: size.width,
            height: size.height * 1.18,
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
                  controller: _stf_idC,
                  decoration: InputDecoration(
                    hintText: 'Enter Staff ID',
                    label: Text('ID'),
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
                  controller: _titleC,
                  decoration: InputDecoration(
                    hintText: 'Enter Qualification Title',
                    label: Text('Qualification Title'),
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
                  controller: _instituteC,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.call),
                    hintText: 'Enter Institute Name',
                    label: Text('Institute Name'),
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
                  controller: _startDateC,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select Start Date',
                    // labelStyle: 'Dat',
                    labelText: 'Start Date',
                    prefixIcon: Icon(Icons.today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.timestamp(),
                    );
                    _startDate = pickedDate;
                    if (pickedDate != null) {
                      _startDateC.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    }
                  },
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _endDateC,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                    // labelStyle: 'Dat',
                    labelText: 'Date Of Birth',
                    prefixIcon: Icon(Icons.today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.timestamp(),
                    );
                    _endDate = pickedDate;
                    if (pickedDate != null) {
                      _endDateC.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    }
                  },
                ),
              ),
              if (isAnyError && errorMsg.isNotEmpty) SizedBox(height: 15),
              if (isAnyError && errorMsg.isNotEmpty)
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
                    int? id = int.tryParse(_stf_idC.text);
                    if (_endDate == null ||
                        _startDate == null ||
                        _stf_idC.text.isEmpty ||
                        _instituteC.text.isEmpty) {
                      errorMsg = "All fields are not filled";
                      isAnyError = true;
                      setState(() {});
                    } else if (id == null) {
                      errorMsg = "Staff ID Should be number";
                      isAnyError = true;
                      setState(() {});
                    } else if (_startDate!.compareTo(_endDate!) >= 0) {
                      errorMsg = "End Date should be Greater then Start Date";
                      isAnyError = true;
                      setState(() {});
                    } else {
                      // try inserting
                      var instance = DBHelper.instance;
                      // instance
                      var i = await instance.insertIntoStaffQualification(
                        StaffId: id,
                        title: _titleC.text,
                        startDate: AppController.getDBStyleDate(_startDate!),
                        endDate: AppController.getDBStyleDate(_endDate!),
                        institute: _instituteC.text,
                      );
                      if (i == 0) {
                        errorMsg = "No Such Staff Member With Given id Exists";
                        isAnyError = true;
                        setState(() {});
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  label: Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
