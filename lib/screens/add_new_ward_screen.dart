import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';

import '../model/DBHelper.dart';

class AddNewWardScreen extends StatefulWidget {
  const AddNewWardScreen({super.key});

  @override
  State<AddNewWardScreen> createState() => _AddNewWardScreenState();
}

class _AddNewWardScreenState extends State<AddNewWardScreen> {
  //  name,description,qty,dosage,methodOfUse,costPerUnit,supplierId
  TextEditingController _nameC = TextEditingController();
  int? _s_id;
  TextEditingController _noOfBedsC = TextEditingController();
  TextEditingController _locationC = TextEditingController();
  TextEditingController _chargeNusreC = TextEditingController();
  TextEditingController _methodOfUseC = TextEditingController();
  TextEditingController _costPerUnitC = TextEditingController();
  TextEditingController _supplierIdC = TextEditingController();
  bool isAnyError = false;
  List<dynamic> listOfAllSupplier = [];
  int? sid;
  String errorMsg = "";

  Future<void> loadQouta() async {
    var instance = DBHelper.instance;
    var allSuppliers = await instance.getAllSuppliers();
    listOfAllSupplier = allSuppliers.map((e) {
      return e['s_id'];
    }).toList();
    print(listOfAllSupplier);
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Ward ', style: TextStyle(color: Colors.white)),
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
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nameC,
                    decoration: InputDecoration(
                      hintText: 'Enter Ward Name',
                      label: Text('Ward Name'),
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
                    controller: _noOfBedsC,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.bed),
                      hintText: 'Enter Number of Beds',
                      label: Text('Number of Beds'),
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
                    controller: _locationC,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'Enter Location',
                      label: Text('Location'),
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
                    controller: _chargeNusreC,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      hintText: 'Enter Charge Nurse ID',
                      label: Text('Charge Nurse ID'),
                      // labelText: 'id'
                      border: OutlineInputBorder(
                        // borderRadius:
                      ),
                    ),
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
                      // check if any issue with data then insert into
                      int? nobb=int.tryParse(_noOfBedsC.text);
                      int? nurse_id=int.tryParse(_chargeNusreC.text);
                      if (_nameC.text.trim().isEmpty ||
                          _noOfBedsC.text.trim().isEmpty ||
                          _locationC.text.trim().isEmpty ||
                          _chargeNusreC.text.trim().isEmpty) {
                        isAnyError = true;
                        errorMsg = "ALl Fields are not filled";
                        setState(() {});
                      }else if(nobb==null || nurse_id==null){
                        isAnyError = true;
                        errorMsg = "Number of beds and Nurse Id Should be Number";
                        setState(() {});
                      }
                      else{
                        // inwert detail
                        var instance = DBHelper.instance;
                        // print(gender);
                        print("Aaya");

                        var i = await instance.insertIntoWard(wardName: _nameC.text, nob: int.parse(_noOfBedsC.text), location: _locationC.text, stfId: int.parse(_chargeNusreC.text));
                        if (i == 0) {
                          isAnyError=true;
                          errorMsg = "There is No Such In-charge Nurse found with given Id";
                          print('No Supplier $i');
                          setState(() {});
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                    label: Text('SignUp'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
