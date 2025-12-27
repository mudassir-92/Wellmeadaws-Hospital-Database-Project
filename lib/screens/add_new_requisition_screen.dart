import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';

import '../model/DBHelper.dart';

class AddNewRequisitionScreen extends StatefulWidget {
  final ward_id;
  const AddNewRequisitionScreen({super.key, required  this.ward_id});
  @override
  State<AddNewRequisitionScreen> createState() =>
      _AddNewRequisitionScreenState();
}

class _AddNewRequisitionScreenState extends State<AddNewRequisitionScreen> {
  TextEditingController _qtyC = TextEditingController();
  int? _s_id;
  bool isAnyError = false;
  String errorMsg="";
  List<Map<String, dynamic>> allSupply = [];
  Future<void> loadQouta() async {
    // get All Pharma Supply
    allSupply = await DBHelper.instance.getALlSupply();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQouta();
  }

  int? drugId;
  String? drugName;

  @override
  Widget build(BuildContext context) {
    // loadQouta();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Wellmeadows Hospital ',
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
                height: 150,
                width: 300,
                child: Image.asset('assets/logo.png'),
              ),
              SizedBox(height: 15),
              DropdownButton<String>(
                hint: Text('Select Drug'),
                value: drugName,
                items: allSupply
                    .map(
                      (u) => DropdownMenuItem<String>(
                        value: u['name'],
                        child: Text(u['name']),
                      ),
                    )
                    .toList(),
                onChanged: (String? k) {
                  setState(() {
                    drugName = k;
                    //  print(allSupply.map((e) => "'${e['name']}'").toList());
                    print("Current value: '$drugName'");
                  });
                },
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _qtyC,
                  decoration: InputDecoration(
                    hintText: 'Enter Quantity Name', // should be less then available
                    label: Text('Quantity'),
                    // labelText: 'id'
                    border: OutlineInputBorder(
                      // borderRadius:
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
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
                    // check if any issue with data then insert into
                    int? num=int.tryParse(_qtyC.text);
                    if (_qtyC.text.trim().isEmpty || drugName==null) {
                      errorMsg="Fields not filled";
                      isAnyError = true;
                      setState(() {});
                    }else if(num==null){
                      isAnyError = true;
                      errorMsg="Quantity should be a Number";
                      setState(() {});
                    } else {
                      // inwert detail
                      var instance = DBHelper.instance;
                      var dt=DateTime.now();
                      var dbStyleDate = AppController.getDBStyleDate(dt);
                      // get DrugNo from drug name
                      for(int i=0;i<allSupply.length;i++){
                        if(allSupply[i]['name']==drugName){
                          drugId=allSupply[i]['drug_no'];
                        }
                      }
                      var i = await instance.insertIntoRequisition(dateOrdered: dbStyleDate, ward_id: widget.ward_id, orders: [(drugNo: drugId!,qty: num)]);
                      print('came back with $i');
                      if(i==-1){
                        errorMsg="Quantity is Low";
                        isAnyError=true;
                        setState(() {
                        });
                      }else if(i==0){
                        isAnyError=true;
                        errorMsg='Error Inserting';
                      }else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  label: Text('SignUp'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
