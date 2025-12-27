import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/model/DBHelper.dart';
class AddNewSupplyScreen extends StatefulWidget {
  const AddNewSupplyScreen({super.key});

  @override
  State<AddNewSupplyScreen> createState() => _AddNewSupplyScreenState();
}

class _AddNewSupplyScreenState extends State<AddNewSupplyScreen> {
  //  name,description,qty,dosage,methodOfUse,costPerUnit,supplierId
  TextEditingController _nameC=TextEditingController();
  int? _s_id;
  TextEditingController _descriptionC=TextEditingController();
  TextEditingController _qtyC=TextEditingController();
  TextEditingController _dosageC=TextEditingController();
  TextEditingController _methodOfUseC=TextEditingController();
  TextEditingController _costPerUnitC=TextEditingController();
  TextEditingController _supplierIdC=TextEditingController();
  bool isAnyError=false;
  List<dynamic> listOfAllSupplier=[];
  int? sid;
  String errorMsg="";

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
          title: Text('The Wellmeadows Hospital ',style: TextStyle(
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
                            hintText: 'Enter Supplier Name',
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
                      SizedBox(
                          width: 250,
                          child: TextField(
                            controller: _descriptionC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Enter Description',
                              label: Text('Description'),
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
                          controller:_qtyC ,
                          decoration: InputDecoration(
                            hintText: 'Enter Quantity',
                            label: Text('Quantity'),
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
                          controller:_dosageC ,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call),
                            hintText: 'Enter Dosage',
                            label: Text('Dosage'),
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
                          controller:_methodOfUseC ,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call),
                            hintText: 'Enter Method Of Use',
                            label: Text('Method of Use'),
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
                          controller:_costPerUnitC ,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call),
                            hintText: 'Enter Cost Per Unit',
                            label: Text('Cost Per Unit'),
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
                          controller:_supplierIdC,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call),
                            hintText: 'Enter Supplier ID',
                            label: Text('Supplier ID'),
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
                            if(_nameC.text.trim().isEmpty ||_descriptionC.text.trim().isEmpty
                            || _qtyC.text.trim().isEmpty|| _dosageC.text.trim().isEmpty
                            || _methodOfUseC.text.trim().isEmpty || _costPerUnitC.text.trim().isEmpty
                            || _supplierIdC.text.trim().isEmpty) {
                              isAnyError=true;
                              errorMsg="ALl Fields are not filled";
                              setState(() {
                              });
                            }else{
                              // inwert detail
                              var instance = DBHelper.instance;
                              // print(gender);

                              // print(_costPerUnitC.text);

                              var i = await instance.insertIntoPharmaSupply(name: _nameC.text, description: _descriptionC.text,
                                  qty:int.parse( _qtyC.text), dosage: double.parse(_dosageC.text), methodOfUse: _methodOfUseC.text,
                                  costPerUnit: double.parse(_costPerUnitC.text), supplierId: int.parse(_supplierIdC.text));
                              if(i==0) {
                                errorMsg="There is no Such Suppier";
                                print('No Supplier $i');
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
