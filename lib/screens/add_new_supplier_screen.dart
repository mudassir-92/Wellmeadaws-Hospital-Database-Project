import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wellmeadows_hospital/controller/app_controller.dart';

import '../model/DBHelper.dart';
class AddNewSupplierScreen extends StatefulWidget {
  const AddNewSupplierScreen({super.key});

  @override
  State<AddNewSupplierScreen> createState() => _AddNewSupplierScreenState();
}

class _AddNewSupplierScreenState extends State<AddNewSupplierScreen> {
  TextEditingController _nameC=TextEditingController();
  int? _s_id;
  TextEditingController _supC=TextEditingController();
  TextEditingController _addressC=TextEditingController();
  TextEditingController _teleC=TextEditingController();
  bool isAnyError=false;
  Future<void> loadQouta()
  async {
   _s_id = await AppController.getMinAvailableSupplierId();
   setState(() {
      _supC.text=_s_id!.toString();
      print(_s_id);
   });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadQouta();
  }

  @override
  Widget build(BuildContext context) {
    // loadQouta();
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
                  )
              ),
              SizedBox(
                height: 15,
              ),
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
              if(isAnyError)
                SizedBox(
                  height: 15,
                ),
              if(isAnyError)
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
                width: 150,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    // check if any issue with data then insert into
                    if(_nameC.text.trim().isEmpty  || _teleC.text.trim().isEmpty ||_addressC.text.trim().isEmpty)
                    {
                      isAnyError=true;
                      setState(() {
                      });
                    }else{
                      // inwert detail
                      var instance = DBHelper.instance;
                      // print(gender);
                      var i = await instance.insertInSupplier(name: _nameC.text, address: _addressC.text, mobile: _teleC.text);
                      // if(i!=0) {
                      //   showDialog(context: context, builder: (context) {
                      //     return AlertDialog(
                      //       title: Text('Success'),
                      //       content: Text('Supplier Added successfully'),
                      //       actions: [
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: Text('OK'),
                      //         )
                      //       ],
                      //     );
                      //   });
                      // navigate to Medical director
                      Navigator.pop(context);
                    }
                  },
                  label: Text('SignUp'),
                ),
              ),
            ]
        )
        ]
    )
    );
  }
}
